#!/bin/bash

# Use this file to install test dependencies and run the tests.
# It will be copied to /tests/test.sh and run from the working directory.

# Check if we're in a valid working directory
if [ "$PWD" = "/" ]; then
    echo "Error: No working directory set. Please set a WORKDIR in your Dockerfile before running this script."
    exit 1
fi

# Install pytest if not available (should be in base image)
if ! /opt/venv/bin/python -c "import pytest" 2>/dev/null; then
    echo "Installing pytest and pytest-ctrf..."
    /opt/venv/bin/pip install pytest pytest-ctrf
fi

# ============================================
# Use soffice to recalculate formulas in result files
# This ensures any Excel formulas written by the agent are evaluated
# ============================================
echo "Recalculating formulas in result files with LibreOffice..."

# Create temporary directory for conversion
TEMP_DIR=$(mktemp -d)
# Create temporary user profile directory for LibreOffice
USER_PROFILE_DIR=$(mktemp -d)

# Find all result files and process them
for result_file in /app/sheet/*_result.xlsx; do
    if [ -f "$result_file" ]; then
        echo "  Processing: $(basename "$result_file")"

        # LibreOffice calc will open, recalculate formulas, and save
        # Use temp directory to avoid input/output path conflict
        # Use UserInstallation to avoid IO errors in headless environments
        soffice \
          "-env:UserInstallation=file://$USER_PROFILE_DIR" \
          --headless \
          --norestore \
          --calc \
          --convert-to xlsx \
          --outdir "$TEMP_DIR" \
          "$result_file" 2>&1 | grep -v "Warning" || true

        # Move the converted file back to original location
        temp_file="$TEMP_DIR/$(basename "$result_file")"
        if [ -f "$temp_file" ]; then
            mv "$temp_file" "$result_file"
            echo "  ✓ Formula recalculation complete for $(basename "$result_file")"
        else
            echo "  ✗ Warning: Conversion failed for $(basename "$result_file")"
        fi
    fi
done

# Clean up temporary directories
rm -rf "$TEMP_DIR"
rm -rf "$USER_PROFILE_DIR"

echo "All formulas recalculated."


# ============================================
# Archive sheet files to verifier logs for post-analysis
# ============================================
echo "Archiving sheet files for post-analysis..."
mkdir -p /logs/verifier/sheets/input
mkdir -p /logs/verifier/sheets/output
mkdir -p /logs/verifier/sheets/golden

# Copy input files (original init files)
if ls /app/sheet/*_init.xlsx 1> /dev/null 2>&1; then
    cp /app/sheet/*_init.xlsx /logs/verifier/sheets/input/
    echo "  Copied input files to /logs/verifier/sheets/input/"
fi

# Copy output files (agent-generated result files)
if ls /app/sheet/*_result.xlsx 1> /dev/null 2>&1; then
    cp /app/sheet/*_result.xlsx /logs/verifier/sheets/output/
    echo "  Copied output files to /logs/verifier/sheets/output/"
fi

# Copy golden files for reference
if ls /tests/*_golden.xlsx 1> /dev/null 2>&1; then
    cp /tests/*_golden.xlsx /logs/verifier/sheets/golden/
    echo "  Copied golden files to /logs/verifier/sheets/golden/"
fi

echo "Sheet file archiving complete."

# ============================================
# Archive Python scripts to verifier logs for analysis
# ============================================
echo "Archiving Python scripts for analysis..."
mkdir -p /logs/verifier/scripts

# Copy all Python files from /app directory
if ls /app/*.py 1> /dev/null 2>&1; then
    cp /app/*.py /logs/verifier/scripts/
    echo "  Copied Python scripts from /app/ to /logs/verifier/scripts/"
fi

# Also check common subdirectories where scripts might be saved
for subdir in /app/src /app/scripts /app/code; do
    if [ -d "$subdir" ] && ls $subdir/*.py 1> /dev/null 2>&1; then
        cp $subdir/*.py /logs/verifier/scripts/
        echo "  Copied Python scripts from $subdir/"
    fi
done

echo "Python script archiving complete."

# Run pytest with openpyxl dependency for Excel file handling
# Note: DO NOT use set -e before this line, as we need to capture the exit code
/opt/venv/bin/pytest \
    --ctrf /logs/verifier/ctrf.json \
    /tests/test_outputs.py \
    -v -rA

# Capture the exit code
TEST_EXIT_CODE=$?

# Generate multi-metric reward based on test result and formula usage
if [ $TEST_EXIT_CODE -eq 0 ]; then
    ACCURACY=1
else
    ACCURACY=0
fi

# Extract formula ratio from the saved statistics
FORMULA_RATIO=0
if [ -f /logs/verifier/formula_stats.json ]; then
    # Use Python to parse JSON and extract formula_ratio
    FORMULA_RATIO=$(/opt/venv/bin/python3 -c "
import json
try:
    with open('/logs/verifier/formula_stats.json', 'r') as f:
        stats = json.load(f)
    print(stats.get('formula_ratio', 0))
except:
    print(0)
")
fi

# Write multi-metric reward as JSON
# cat > /logs/verifier/reward.json <<EOF
# {
#   "accuracy": $ACCURACY,
# }
# EOF

# write reward.txt
# 如果测试通过，不管 accuracy 和 formula_ratio 都写 1
# 如果测试不通过，不管 accuracy 和 formula_ratio 都写 0
if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "1" > /logs/verifier/reward.txt
else
    echo "0" > /logs/verifier/reward.txt
fi

# Note: Only reward.json is generated. Verifier will read it if reward.txt doesn't exist.
# If both files exist, verifier prioritizes reward.txt (which we don't want for multi-metric)

echo ""
echo "=== Reward Metrics ==="
echo "Accuracy: $ACCURACY"
echo "Formula Ratio: $FORMULA_RATIO"
echo "======================"

# Exit with the test exit code
exit $TEST_EXIT_CODE

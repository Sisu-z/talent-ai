## Task

I need to automate cashflow generation for approximately 1,500 bonds where each bond has a principal amount in column A, interest in column B, payment frequency in column C (1 for annual, 2 for semi-annual, 4 for quarterly), and maturity date in column D, with date headers in row 4 from E4 to AB4. Create formulas in the range E6:AB25 that display "-" in row 5, and for rows 6-25 calculate cashflows showing interest payments at regular intervals based on the frequency working backwards from the maturity date, principal plus interest at the maturity date, and "-" for non-payment dates, then center align the entire E6:AB25 range while preserving existing number formatting.

---

## Environment

**Working Directory:** `/app`
- Input Excel files: `/app/sheet/`
- Output format: `name.xlsx` → `name_result.xlsx`
  - Example: `/app/sheet/1_12307_init.xlsx` → `/app/sheet/1_12307_init_result.xlsx`

**Python Setup:**
- Version: Python 3.11
- Interpreter: `/opt/venv/bin/python` (always use this, not `/usr/bin/python3`)
- Pre-installed: pandas, openpyxl, xlsxwriter, xlrd, odfpy, numpy, scipy, matplotlib, requests, tabulate

**Execution:**
- Create Python script files before running (e.g., `/app/solve_task.py`)
- Execute: `/opt/venv/bin/python /app/solve_task.py`

---

## Output Requirements

- Preserve original Excel structure
- Only modify required result cells
- Save as `*_result.xlsx` in `/app/sheet/`
- Use programmatic approach (pandas, openpyxl, etc.)

---

## Formula-First Requirement 

**Priority: Write Excel formulas, not pre-computed values.**

- Treat Python as a **formula generator**, not a calculator
- When possible, write Excel formulas (e.g., `SUM`, `COUNTIF`, `VLOOKUP`, `XLOOKUP`, `IF`) into cells
- Use `openpyxl` or `xlsxwriter`: `cell.value = "=SUM(A1:A10)"`
- Only write concrete values if:
  1. Excel formulas cannot express the logic
  2. Task explicitly requires fixed values
  3. Formulas would break expected structure

**Rule:** If a human Excel user would use formulas, you should output formulas too.
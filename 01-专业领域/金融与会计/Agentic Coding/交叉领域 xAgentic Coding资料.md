**致各位领域，准入培训大概需要您10-30分钟时间，其目的是让您在最熟悉的领域了解AI模型训练数据格式与框架，在后续作业过程中节约您的时间。**

_请您选择最擅长的领域开始考试，这将决定您之后领取的任务所属领域。_

  

**由于是交叉领域，您可以用Claude code等模型进行代码编写与数据格式解析，辅助您答题。本说明内exam_001为示例题目，请您领取题目后基于题目数据完成考试。**

  

**本考试题目格式参考terminal Bench数据格式，引用 harbor 框架进行判卷处理。**

**建议本地安装后利用harbor命令执行 oracle test，提交前在本地测试，如果得到reward=1，说明你的修复成功。**

repo:[https://github.com/laude-institute/harbor.git](https://github.com/laude-institute/harbor.git)

在 Harbor 里执行 Oracle测试，使用以下命令：

1. 进入 Harbor 项目目录

cd /Users/Desktop/hl-harbor

1. 执行单个题目的 Oracle 测试

  uv run harbor trials start -p "/Users/1Desktop/exam_001" -a oracle

2. 或者用相对路径（如果题目在 Harbor目录内）

uv run harbor trials start -p <题目路径> -a oracle

|   |   |
|---|---|
|**考核目标**|验证专家能否正确解决 Terminal Bench 风格的任务|
|**时间限制**|30-60 分钟/题|
|**通过标准**|reward = 1.0（专家提交任务zip包，后台程序自动验证）|
|**补考次数**|2（共3次机会）|

|   |
|---|
|## **题目列表**|

|   |   |   |   |   |
|---|---|---|---|---|
|示例题目||类型|难度|说明|
|`exam_001`||文件处理|Easy|日志分析脚本 - 分析 Web 服务器访问日志|

##   

## 操作步骤

### 步骤 1: 下载zip到本地

[📎 exam_001.zip](https://www.talents-ai.com/expert/dashboard#)

├── environment
│   ├── Dockerfile
├── instruction.md
├── solution
│   ├── oracle_convert.py
│   └── solve.sh
└── tests
    ├── test_outputs.py
    └── test.sh

### windows支持[📎 exam_001.tar](https://www.talents-ai.com/expert/dashboard#)

###   

### 步骤 2: 阅读任务说明

`exam_001`

[📎 instruction.md](https://www.talents-ai.com/expert/dashboard#)

仔细阅读：

- **任务描述** - 你需要完成什么
- **输入** - 数据文件的位置和格式
- **要求** - 需要实现的具体功能
- **输出格式** - 输出文件的格式要求

  

### 步骤 3: 本地构建镜像尝试解决问题并测试

- Dockerfile：您需要本地构建镜像，在相同环境中尝试解决问题，如果您需要安装您擅长的语言依赖。
- 请确认无过多冗余安装，无风险操作。一旦发现，立即暂停考试，全平台封禁处理

`exam_001`

[📎 Dockerfile](https://www.talents-ai.com/expert/dashboard#)

  

### 步骤 4: 编写解决方案

在 solution`/` 目录下创建 `solve.sh` 等文件：

**注意事项：**

1. 必须是 Bash shell 脚本solve.sh，拉起其他solve.py或其他您擅长的语言脚本来解决问题

2. 脚本开头需要 `#!/bin/bash`

3. 输出文件必须写入指定位置

4. 输出格式必须严格按照 `instruction.md` 的要求

  

### 步骤 5: 提交

您确认完成答题后，请在对应提交框提交**zip文件**

提交前请您确认：

- 您可以修改dockerfile，必须确认的是确认提交的solve与dockerfile完全匹配
- 禁止在.sh文件、dockerfile内引入过多无用的依赖或执行风险命令
- 您提交的文件命名方式必须是全部小写英文字体
- 您提交的**zip包**参确认solution与environment 内放置了您修改的文件：
-
#### 领域与题目

学习材料

|   |   |   |   |   |
|---|---|---|---|---|
|物理|数学|生物|化学|机械工程|
|[📎 exam_002.zip](https://www.talents-ai.com/expert/dashboard#)|[📎 exam_003.zip](https://www.talents-ai.com/expert/dashboard#)|[📎 exam_004.zip](https://www.talents-ai.com/expert/dashboard#)|[📎 exam_005.zip](https://www.talents-ai.com/expert/dashboard#)|[📎 exam_006.zip](https://www.talents-ai.com/expert/dashboard#)|

|   |   |
|---|---|
|软件工程/计算机|金融|
|[📎 exam_007.zip](https://www.talents-ai.com/expert/dashboard#)|[📎 samples4-1.zip](https://www.talents-ai.com/expert/dashboard#)|

下载您最擅长领域的题目，开始准入考试

请确认您下一个章节选择的领域与您下载的题目zip包领域匹配。

1. 金融 x Agentic Coding编程题

考试目的是为了让您更了解后续作业数据结构，您可以将开源 https://github.com/harbor-framework/harbor 框架下载到本地执行oracel测试  
Oracle 不是一个真正的AI Agent，它只是"作弊"地直接用标准答案（solution部分）来完成任务，也就是您提交的部分，直接执行通过单元测试（test部分）  
如果您的solution能在该harbor框架内进行oracle测试，得到reward=1，则提交后必定能考试通过  
与Claude code、cursor、codex等vibe coding 工具深度交互，基于您的领域知识完成考试。  
请注意，提交压缩包仅支持zip，并且请勿修改目录层级，否则会出现路径问题。  
  
Harbor 题包提交目录要求：请将答案脚本放在 solution/solve.sh，并将运行环境文件放在 environment/ 目录（至少包含 environment/Dockerfile）。不要使用 submission/solve.sh 作为答案入口；压缩包请保留题包原有目录层级，并仅提交 ZIP 文件
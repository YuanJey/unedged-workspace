# unedged-workspace

Unedged 项目 Monorepo 根工作区仓库。

## 目录结构与架构映射

| 路径 | 子仓库名称 | 平台 / 技术栈 | 职责描述 |
| :--- | :--- | :--- | :--- |
| `client/` | [unedged-client](https://github.com/YuanJey/unedged-client) | Godot 4 | 游戏客户端核心逻辑与渲染工程 |
| `server/` | [unedged-server](https://github.com/YuanJey/unedged-server) | Go | 游戏服务端网络、业务状态与并发架构 |

## 工作区拉取与子模块同步

若首次克隆本工作区：
```bash
git clone --recurse-submodules https://github.com/YuanJey/unedged-workspace.git
```

若已有工作区拉取最新子模块状态：
```bash
git submodule update --init --recursive
```

## 变更日志与审计追溯

### [2026-11-23 - 核心系统落地与基线构建]
- **共享契约与自动化构建**：
  - 注入 `configs/weapons.json`：定义唐刀（TANGDAO）大类基础帧数据、姿态加成（单持/换手/双持）及 3 把名器代偿机制。
  - 注入 `proto/battle.proto`：定义三向攻防枚举（`CombatDirection`）、握持姿态（`GripStance`）、60Hz 逻辑帧指令包（`PlayerFrameInput`）与战前属性配置（`FighterLoadout`）。
  - 注入根目录 `Makefile`：支持配置同步（`make sync-configs`）、协议编译与服务端启动。
- **客户端子模块（client/ - Godot 4）**：
  - 配置 `project.godot`：设定视口分辨率 1920x1080 与全套 InputMap 战斗键位映射。
  - 实现核心状态机：`scripts/combat/combat_constants.gd` 与 `scripts/combat/combat_state_machine.gd`，支持三向判定、11 帧精准弹反与单双持姿态加成。
  - 同步共享配置至 `assets/configs/weapons.json`。
- **服务端子模块（server/ - Go）**：
  - 初始化 Go 模块 `unedged-server` 并引入 `kcp-go/v5`。
  - 构建网关主入口 `cmd/gateway/main.go` 与 60Hz 定时驱动论剑房间 `internal/room/room.go`。
  - 构建配置读取模块 `internal/config/config.go`。
- **版本归档**：
  - 子模块 `client` (HEAD -> `d80e9e6`) 与 `server` (HEAD -> `a74421e`) 分别推送至 GitHub。
  - 主仓库同步更新子模块指针并固化公共契约。

### [2026-11-23 - 初始化基线]
- **初始化工程基线**：建立 Monorepo 根工作区配置，引入全局 `.gitignore`。
- **架构子模块规划**：挂载 `client/` (unedged-client) 与 `server/` (unedged-server)。
- **Submodule 引用固化**：已成功建立 `.gitmodules` 映射并锚定初始子仓库 HEAD。

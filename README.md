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

### [2026-11-23]
- **初始化工程基线**：建立 Monorepo 根工作区配置，引入全局 `.gitignore`。
- **架构子模块规划**：挂载 `client/` (unedged-client) 与 `server/` (unedged-server)。
- **Submodule 引用固化**：已成功建立 `.gitmodules` 映射并锚定初始子仓库 HEAD。

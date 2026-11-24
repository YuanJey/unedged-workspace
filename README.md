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

### [2026-11-24 - 《刀剑2》“秋红叶”经典神韵 3D 角色重塑]
- **秋红叶标志性形体重构**：
  - 构建侠客高束马尾发辫（`Ponytail`，斜向后上方微扬姿态）、束发朱红发带（`HairRibbon`）与前额不羁碎发刘海。
  - 上身采用经典枫红交领战袍（`StandardMaterial3D_cloth_autumn`）配合修长双开叉下摆。
  - 呈现标志性的单侧重铠不对称美感：右肩配深冷玄铁棱角肩铠（`RightPauldron`），左肩展现潇洒交领布肩。
- **寒枫唐刀配饰升级**：
  - 直刃采用冷钢淬火微泛淡红寒芒，青铜镂空方圆刀镡，刀首尾端新增朱红小剑穗（`TasselMesh`）。
- **阵营质感适配**：
  - P1 玩家确认为“秋红叶”枫红玄铁武服；P2 木桩切换为素灰武者服与古青铜试炼铠。
- **版本归档**：
  - 子模块 `client` (HEAD -> `1e463af`) 推送至 GitHub。
  - 主工作区同步更新 submodule 引用指针。

### [2026-11-24 - 战斗规则重构：彻底剔除双手霸体机制]
- **规则修正与全链路净化**：
  - **契约层**：从 `configs/weapons.json` 及 `client/assets/configs/weapons.json` 彻底删除 `has_hyper_armor_on_top_heavy` 字段；`proto/battle.proto` 修正注释为“双手沉劲，高伤重势”。
  - **服务端**：`server/internal/config/config.go` 剔除结构体字段，通过全量编译校验。
  - **客户端**：`combat_constants.gd`、`combat_state_machine.gd` 移除 `has_hyper_armor` 状态变量与赋值分支，所有未成功格挡命中强制进入受击硬直（Hitstun）；`fighter_controller.gd` 看板与 `arena.tscn` 引导文案纠正为“双手重势”。
- **版本归档**：
  - 子模块 `client` (HEAD -> `8c68bf9`) 与 `server` (HEAD -> `7f0168e`) 分别推送至 GitHub。
  - 主工作区同步更新 submodule 引用指针。

### [2026-11-24 - 3D 角色模型美化与武侠斗笠剑客装配]
- **剑客形体多层级重构**：
  - 彻底替换原有单一胶囊体，构建复合中式剑客视觉网格（`VisualModel`）：竹编微斜宽檐斗笠（`HatMesh`）、遮面玄黑面罩（`MaskMesh`）、倒梯形玄铁胸铠（`ChestArmor`）、束腰朱红带扣（`WaistBelt`）、战袍长裙摆（`RobeSkirt`）及棱角外展护肩板甲。
- **唐刀冷兵器部件精细化**：
  - 将原单一长方块升级为包含狭长冷钢直刃（高反光金属度）、方圆青铜雕花刀镡（`GuardMesh`）、暗色防滑柄卷（`HiltMesh`）及刀首配重环（`PommelMesh`）的完整唐刀。
- **敌我阵营 PBR 材质分色**：
  - 玩家（P1）：玄黑夜行武袍 + 青冷玄铁铠 + 寒芒冷钢直刃。
  - 木桩（P2）：赤赭古铜铠 + 暗红战袍 + 淬火暗红铜刃，大幅提升 3D 对弈视觉辨识度。
- **工程构建净化**：
  - 注入 `client/.gitignore`，从 Git 索引彻底清除 `.godot/` 本地着色器与编辑器缓存目录。
- **版本归档**：
  - 子模块 `client` (HEAD -> `5406ea8`) 推送至 GitHub。
  - 主工作区同步更新 submodule 引用指针。

### [2026-11-24 - 修复 Godot 4 CombatConstants 全局类名解析中断]
- **符号绑定解耦与时序保护**：
  - 在 `hitbox_3d.gd`、`hurtbox_3d.gd`、`combat_state_machine.gd`、`fighter_controller.gd` 头部显式注入 `const CombatConstants = preload(...)`。
  - 彻底规避 Godot 4 引擎在冷启动与动态重载阶段全局类名（Global Class Cache）未建立完成导致的 `Parse Error: Identifier "CombatConstants" not declared in the current scope`。
- **版本归档**：
  - 子模块 `client` (HEAD -> `dd271f5`) 推送至 GitHub。
  - 主工作区同步更新 submodule 引用指针。

### [2026-11-24 - 客户端 3D 角色与受击判定盒可视化]
- **碰撞判定核心组件**：
  - 编写 `client/scripts/combat/hitbox_3d.gd`：挂载于武器刃部，由状态机有效判定帧（`ATTACK_ACTIVE`）精确门禁激活/停用，支持鲜红半透明高亮。
  - 编写 `client/scripts/combat/hurtbox_3d.gd`：包裹角色躯干，监听 Hitbox 碰撞并接入三向攻防与 11 帧弹反裁决，提供常态绿/蓝格挡/金光弹反/血红受击动态自发光材质反馈。
- **3D 角色与控制机装配**：
  - 编写 `client/scripts/character/fighter_controller.gd`：读取输入打包 60Hz 掩码、驱动 CharacterBody3D、握持姿态切换（单持/换手/双手霸体）与武器挥砍物理表现。
  - 构建预制体 `client/scenes/fighter.tscn`：集成胶囊体、Hitbox、Hurtbox、三向架势指示器与头顶 3D 状态 Label。
- **灰盒测试擂台主场景**：
  - 搭建 `client/scenes/arena.tscn`：布设地面、光照、俯仰摄像机，部署玩家角色（P1）与自动周期出刀的木桩（Dummy P2），并在 `project.godot` 中设为主入口。
- **版本归档**：
  - 子模块 `client` (HEAD -> `29c3c29`) 推送至 GitHub。
  - 主工作区同步更新 submodule 引用指针。

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

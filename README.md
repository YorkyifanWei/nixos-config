# NixOS 配置

基于 flakes 和 Home Manager 的个人 NixOS-WSL 配置管理。

## 系统信息

- **系统**: NixOS 25.05 (WSL 环境)
- **主机名**: wsl
- **配置管理**: Flakes
- **用户管理**: Home Manager
- **默认用户**: yorkwei
- **默认 shell**: Nushell
- **默认编辑器**: Helix
- **镜像源**: 清华大学镜像

## 特性

- 🚀 **模块化配置**: 清晰的项目结构，易于维护和扩展
- ⚡ **软链接配置文件**: 修改配置文件后无需重新构建，立即生效
- 📦 **声明式包管理**: 使用 Flakes 和 Home Manager 管理所有软件包
- 🎨 **XDG 目录规范**: 开发工具数据集中管理，避免污染家目录
- 🔄 **自动优化**: 自动优化存储空间和清理历史版本
- 💻 **VSCode Remote 支持**: 通过 nix-ld 支持运行非 NixOS 二进制程序

## 项目结构

```
.
├── flake.nix              # Flake 入口，定义输入和输出
├── flake.lock             # 锁文件，确保可重现构建
├── README.md              # 本文档
├── CLAUDE.md              # AI 交互说明
├── DEPLOYMENT.md          # 部署指南
│
├── hosts/                 # 主机特定配置
│   └── wsl/
│       └── default.nix    # WSL 系统配置
│
├── modules/               # 可复用的系统模块
│   ├── nix/
│   │   └── default.nix    # Nix 设置 (flakes, 镜像, 存储优化)
│   └── wsl/
│       └── default.nix    # WSL 特定设置
│
└── home/                  # Home Manager 配置
    ├── default.nix        # 主入口: 用户账户 + Home Manager 配置
    ├── shell/             # Shell 相关配置
    │   ├── default.nix    # Shell 软件包声明
    │   ├── common.nix     # 通用环境变量
    │   ├── nushell/       # Nushell 配置
    │   └── starship/      # Starship 配置
    ├── fonts/             # 字体配置
    │   └── default.nix    # 字体包 + Fontconfig
    └── programs/          # 程序配置
        ├── default.nix    # 程序软件包声明
        ├── helix/         # Helix 编辑器
        ├── lazygit/       # Lazygit
        ├── yazi/          # Yazi 文件管理器
        └── zellij/        # Zellij 终端复用器
```

## 使用方法

### 应用配置

⚠️ 以下命令必须在 **NixOS-WSL 环境**中执行!

```bash
# 重建并切换到新配置
sudo nixos-rebuild switch --flake .#wsl

# 测试构建但不切换
sudo nixos-rebuild build --flake .#wsl
```

### 配置文件即时生效

所有程序配置文件使用软链接，修改后无需重新构建：

```bash
# 修改任何配置文件，例如：
vim home/shell/starship/starship.toml
vim home/programs/helix/config.toml

# 保存后立即生效！✨
```

### 更新依赖

```bash
# 更新所有输入
nix flake update

# 更新特定输入
nix flake update nixpkgs
```

## 已配置软件

### Shell 和终端

- **Nushell** - 默认 shell，类型安全的现代 shell
- **Starship** - 跨 shell 的现代化提示符工具
- **Zellij** - 现代终端复用器

### 开发工具

- **Helix** - 模态编辑器，默认编辑器
- **Lazygit** - Git TUI 工具
- **Git** - 版本控制系统
- **Rustup** - Rust 工具链管理器
- **Go** - Go 编程语言
- **fnm** - Node.js 版本管理器
- **claude-code** - Claude Code CLI 工具

### 实用工具

- **Yazi** - 终端文件管理器
- **ripgrep** - 快速的文本搜索工具
- **fzf** - 模糊查找工具
- **fd** - 更好的 find 替代品
- **zoxide** - 智能目录跳转
- **_7zz** - 7zip 压缩工具
- **typst** - 现代排版系统
- **typstyle** - Typst 代码格式化工具

### 字体

- **JetBrains Mono Nerd Font** - 带图标的等宽字体
- **Vista Fonts CHS** - 中文字体包

## 开发工具环境变量

项目采用 **XDG 规范** 管理开发工具数据目录：

- **Rust**: `CARGO_HOME`, `RUSTUP_HOME` → `$XDG_DATA_HOME/cargo`, `$XDG_DATA_HOME/rustup`
- **Go**: `GOPATH` → `$XDG_DATA_HOME/go`
- **Node.js**: `FNM_DIR` → `$XDG_DATA_HOME/fnm`
- **Python**: `UV_*` → `$XDG_CACHE_HOME/uv`, `$XDG_DATA_HOME/uv/*`

配置位置：
- **Home Manager 环境变量**: `home/shell/common.nix`
- **Nushell 环境变量**: `home/shell/nushell/env.nu`

## 添加新软件

### 添加用户包

**Shell 相关工具**:
编辑 `home/shell/default.nix`

**程序相关工具**:
编辑 `home/programs/default.nix`

**字体**:
编辑 `home/fonts/default.nix`

### 添加程序配置文件

1. 在 `home/programs/` 创建目录
2. 添加配置文件
3. 创建 `default.nix` 设置目录软链接:
```nix
{ config, pkgs, ... }:
let
  configPath = "${config.home.homeDirectory}/nixos-config/home/programs/你的程序";
in
{
  xdg.configFile."你的程序".source =
    config.lib.file.mkOutOfStoreSymlink configPath;
}
```
4. 在 `home/programs/default.nix` 导入该模块

## 首次部署

详细步骤请参考 [DEPLOYMENT.md](DEPLOYMENT.md)。

快速开始：

```bash
# 1. 启用 Flakes (首次安装)
sudo cp configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch

# 2. 部署 Flakes 配置
sudo nixos-rebuild switch --flake .#wsl

# 3. 修改密码
passwd
```

## 常见问题

### 如何查看已安装的包?

```bash
# 系统包
nix-store -q --requisites /run/current-system/sw

# 用户包
home-manager packages
```

### 如何搜索可用的包?

```bash
nix search nixpkgs 包名
```

或访问 [NixOS 包搜索](https://search.nixos.org/packages)

### 如何回滚配置?

```bash
# 查看系统代数
sudo nixos-rebuild list-generations

# 回滚到上一版本
sudo nixos-rebuild switch --rollback
```

### 如何清理存储空间?

项目已配置自动优化和垃圾回收：
- 每周自动清理 7 天前的历史版本
- 自动优化 Nix store，删除重复文件

手动清理：
```bash
nix-collect-garbage --delete-old
```

## 学习资源

### 官方文档
- [NixOS 手册](https://nixos.org/manual/nixos/stable/)
- [Home Manager 手册](https://nix-community.github.io/home-manager/)
- [NixOS & Flakes 指南](https://nixos-and-flakes.thiscute.world/zh-cn/)
- [NixOS 包搜索](https://search.nixos.org/packages)

### 社区资源
- [NixOS Wiki](https://nixos.wiki/)
- [Home Manager Options](https://mynixos.com/home-manager)
- [NixOS-WSL 仓库](https://github.com/nix-community/NixOS-WSL)

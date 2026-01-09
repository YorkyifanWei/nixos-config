# NixOS 配置

基于 Flakes 和 Home Manager 的个人 NixOS-WSL 配置管理。

## 系统信息

- 系统: NixOS 25.05 (WSL 环境)
- 主机名: wsl
- 配置管理: Flakes
- 用户管理: Home Manager
- 默认用户: yorkwei
- 默认 shell: Nushell
- 默认编辑器: Helix
- 镜像源: MirrorZ 高校联合镜像

## 特性

- 模块化配置: 清晰的项目结构，易于维护和扩展
- 软链接配置文件: 修改配置文件后无需重新构建，立即生效
- 声明式包管理: 使用 Flakes 和 Home Manager 管理所有软件包
- XDG 目录规范: 开发工具数据集中管理，避免污染家目录
- 自动优化: 自动优化存储空间和清理历史版本
- 二进制文件: 通过 nix-ld 支持运行非 NixOS 二进制程序

## 项目结构

```
.
├── flake.nix              # Flake 入口，定义输入和输出
├── flake.lock             # 锁文件，确保可重现构建
├── configuration.nix      # 用于初始化创建用户、启动 flakes 等功能
├── README.md              # 本文档
├── CLAUDE.md              # AI 交互说明
├── Justfile               # just 命令快捷方式
│
├── hosts/                 # 主机特定配置
│   └── wsl/               # WSL 系统配置
│
├── modules/               # 可复用的系统模块
│   ├── nix/               # Nix 设置 (flakes, 镜像, 存储优化)
│   └── wsl/               # WSL 特定设置
│
└── home/                  # Home Manager 配置
    ├── default.nix        # 主入口: 用户账户 + Home Manager 配置
    ├── shell/             # Shell 相关配置
    ├── fonts/             # 字体配置
    └── programs/          # 程序配置
```

## 首次部署

快速开始:

```bash
# 1. 启用 Flakes (首次安装)
sudo cp configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch

# 2. 部署 Flakes 配置
# 需要确定配置文件在 ~/nixos-config 目录
cd && git clone https://github.com/YorkyifanWei/nixos-config.git
sudo nixos-rebuild switch --flake ~/nixos-config#wsl

# 3. 修改密码
passwd
```

此后可以直接使用 `nixconfig` 快速移动到 nixos-config 目录，然后使用 Justfile 来应用配置。

## 使用方法

### 使用 Justfile 快捷命令

```bash
# 应用配置
just switch

# 详细调试模式
just switch-verbose

# 仅构建
just build

# 更新所有依赖
just update

# 更新特定依赖
just update-input nixpkgs

# 清理存储空间
just clean

# 搜索包
just search <包名>

# 查看所有可用命令
just --list
```

### 配置文件即时生效

所有程序配置文件使用软链接，修改后无需重新构建。

修改任何配置文件，保存后立即生效。

### 更新依赖

```bash
# 更新所有输入
just update

# 更新特定输入
just update-inpud <nixpkgs>
```

## 添加新软件

### 添加用户包

Shell 相关工具:
编辑 `home/shell/default.nix`

程序相关工具:
编辑 `home/programs/default.nix`

字体:
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

## 存储管理

### 清理存储空间

项目已配置自动优化和垃圾回收:
- 每周自动清理 7 天前的历史版本
- 自动优化 Nix store，删除重复文件

手动清理:

```bash
# 删除 7 天前的历史 generation
just clean-history
# 清理未引用的软件包
just collect-garbage
# 清理重复文件
just optimise

# 或使用 clean 应用上面所有清理
just clean
```

### 查看系统代际管理

```bash
# 查看系统代际
just list-gen

# 回滚到上一版本
just rollback
# 回滚到特定版本
just rollback-to <generation>
```

## 社区资源

- [NixOS 手册](https://nixos.org/manual/nixos/stable/)
- [Home Manager 手册](https://nix-community.github.io/home-manager/)
- [NixOS & Flakes 指南](https://nixos-and-flakes.thiscute.world/zh/)
- [NixOS 包搜索](https://search.nixos.org/packages)
- [NixOS Wiki](https://nixos.wiki/)
- [Home Manager Options](https://mynixos.com/home-manager)
- [NixOS-WSL 仓库](https://github.com/nix-community/NixOS-WSL)

# NixOS-WSL 部署指南

本文档说明如何在全新的 NixOS-WSL 环境中部署此配置。

## 首次部署流程

### 步骤 1: 首次启动 NixOS-WSL

首次安装并启动 NixOS-WSL 后，系统使用默认的 `/etc/nixos/configuration.nix` 配置文件。

**重要**: 此时 **Flakes 功能尚未启用**，系统只会读取传统的 `configuration.nix`，**不会读取** `flake.nix`！

### 步骤 2: 启用 Flakes 功能

使用项目提供的 [configuration.nix](configuration.nix) 替换默认配置：

```bash
# 1. 备份原配置
sudo cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak

# 2. 复制项目中的初始化配置
sudo cp configuration.nix /etc/nixos/configuration.nix

# 3. 重建系统（启用 Flakes 功能）
sudo nixos-rebuild switch
```

此时系统已启用 Flakes 功能，但仍在使用传统配置方式。

### 步骤 3: 部署 Flakes 配置

现在可以使用 Flakes 方式部署了：

```bash
# 方法一：使用软链接（推荐）
sudo mv /etc/nixos /etc/nixos.bak
sudo ln -s $(pwd) /etc/nixos
sudo nixos-rebuild switch --flake .#wsl

# 方法二：直接指定路径
sudo nixos-rebuild switch --flake $(pwd)#wsl
```

### 步骤 4: 设置用户密码

首次登录后需要修改密码：

```bash
passwd
```

## 常见问题

### Q1: 为什么首次部署不能直接使用 flake.nix?

**A**: NixOS 默认情况下未启用 Flakes 实验性功能。必须先通过传统的 `configuration.nix` 启用 Flakes，然后才能使用 `flake.nix` 配置。

### Q2: 如何验证 Flakes 是否已启用?

```bash
# 检查是否可以使用 nix 命令
nix --version

# 检查是否可以使用 flake 相关功能
nix flake --help
```

### Q3: 部署失败怎么办?

添加详细错误信息：

```bash
sudo nixos-rebuild switch --flake .#wsl --show-trace -L -v
```

## 日常使用

### 更新配置

修改配置文件后，重新部署：

```bash
sudo nixos-rebuild switch --flake .#wsl
```

### 更新依赖

```bash
# 更新所有 flake 输入
nix flake update

# 更新特定输入
nix flake update nixpkgs

# 部署更新后的配置
sudo nixos-rebuild switch --flake .#wsl
```

### 回滚配置

#### 方法一：通过 NixOS 历史版本

```bash
# 查看历史版本
sudo nixos-rebuild list-generations

# 回滚到上一版本
sudo nixos-rebuild switch --rollback
```

#### 方法二：通过 Git 回滚

```bash
# 回滚到上一个 commit
git checkout HEAD^1

# 部署
sudo nixos-rebuild switch --flake .#wsl
```

## 配置结构说明

### configuration.nix（初始化配置）

- **用途**: 首次启用 Flakes 功能
- **位置**: `/etc/nixos/configuration.nix`（首次部署时）
- **内容**:
  - 启用 Flakes 实验性功能
  - 创建 yorkwei 用户
  - 安装 git 等基础工具

### flake.nix（主配置）

- **用途**: 日常配置管理
- **位置**: 项目根目录
- **内容**:
  - 定义所有系统配置
  - 管理 Home Manager
  - 模块化组织结构

## 推荐的工作流

### 开发环境（在 Fedora 中）

1. 修改配置文件
2. 使用 Git 管理变更
3. 提交并推送

```bash
git add .
git commit -m "添加新软件"
git push
```

### 部署环境（在 NixOS-WSL 中）

1. 拉取最新配置
2. 测试构建
3. 应用配置

```bash
git pull
sudo nixos-rebuild build --flake .#wsl
sudo nixos-rebuild switch --flake .#wsl
```

## 存储空间管理

### 查看历史版本

```bash
nix profile history --profile /nix/var/nix/profiles/system
```

### 清理旧版本

```bash
# 清理 7 天前的历史版本
sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system

# 删除未使用的包
sudo nix-collect-garbage --delete-old

# 删除 Home Manager 的历史版本
nix-collect-garbage --delete-old
```

### 优化存储

```bash
# 优化 Nix store，删除重复文件
nix-store --optimise
```

**注意**: 项目已配置自动优化和垃圾回收（每周清理 7 天前的版本），通常不需要手动清理。

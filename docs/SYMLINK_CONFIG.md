# 软链接配置说明

## 概述

本项目使用 `config.lib.file.mkOutOfStoreSymlink` 为所有配置文件创建软链接，实现了**配置文件修改后立即生效，无需重新构建系统**。

## 工作原理

### 传统方式

```bash
# 1. 修改配置
vim home/shell/starship/starship.toml

# 2. 必须重新构建（耗时 30-60 秒）
sudo nixos-rebuild switch --flake .#wsl

# 3. 配置生效 ❌ 太慢了！
```

### 软链接方式 ✨

```bash
# 1. 修改配置
vim home/shell/starship/starship.toml

# 2. 立即生效！无需重建 ✅
```

## 实现细节

### Nix 配置

每个配置目录的 `default.nix` 使用软链接:

```nix
{ config, pkgs, ... }:
let
  # 配置文件的绝对路径
  configPath = "${config.home.homeDirectory}/nixos-config/home/programs/helix";
in
{
  # 使用 mkOutOfStoreSymlink 创建软链接
  xdg.configFile."helix/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${configPath}/config.toml";
}
```

### 文件结构

```
~/nixos-config/home/programs/helix/
├── default.nix          # Nix 配置（定义软链接）
└── config.toml          # 实际配置文件（软链接目标）

~/.config/helix/
└── config.toml          # 软链接 → ~/nixos-config/home/programs/helix/config.toml
```

## 已配置的软件

所有以下软件的配置文件都使用软链接:

### Shell 配置
- ✅ Nushell ([home/shell/nushell/default.nix](home/shell/nushell/default.nix))
- ✅ Starship ([home/shell/starship/default.nix](home/shell/starship/default.nix))

### 程序配置
- ✅ Helix ([home/programs/helix/default.nix](home/programs/helix/default.nix))
- ✅ Lazygit ([home/programs/lazygit/default.nix](home/programs/lazygit/default.nix))
- ✅ Yazi ([home/programs/yazi/default.nix](home/programs/yazi/default.nix))
- ✅ Zellij ([home/programs/zellij/default.nix](home/programs/zellij/default.nix))

## 使用指南

### 日常使用

```bash
# 修改任何配置文件
vim home/shell/starship/starship.toml

# 保存后立即生效！✨
# 重启对应程序即可看到变化
```

### 首次部署

```bash
# 首次部署时必须运行一次
sudo nixos-rebuild switch --flake .#wsl

# 之后修改配置文件就无需重建了
```

### 何时需要重建

只有以下情况需要运行 `sudo nixos-rebuild switch`:

- ❌ 添加/删除软件包
- ❌ 修改 Nix 配置结构
- ❌ 修改 `home.packages`
- ❌ 首次部署

✅ 修改配置文件内容无需重建！

## 优势

### 1. 极速调试 ⚡

对于频繁修改的配置（如编辑器、Shell），不再需要等待构建:

- 传统方式: 修改 → 等待 30-60 秒构建 → 测试
- 软链接方式: 修改 → 立即测试 ✨

### 2. 保持统一管理 📁

- ✅ 所有配置仍在 Nix 仓库中管理
- ✅ 通过 Git 追踪所有变更
- ✅ 可以轻松回滚历史版本

### 3. 最佳实践 🎯

这是 NixOS 社区推荐的最佳实践，特别适合:

- 编辑器配置（频繁修改）
- Shell 配置（经常调试）
- 工具配置（需要快速迭代）

## 常见问题

### Q: 软链接会破坏 Nix 的声明式特性吗？

**A**: 不会。软链接只是指向配置文件，仍然通过 Nix 声明式地创建。你只是绕过了"重新构建"这一步，但配置管理仍然是声明式的。

### Q: 如果配置文件是 Nix 生成的怎么办？

**A**: 这种情况不适用软链接。只有**静态配置文件**（手写的 toml/yaml/nu 等）才适合使用软链接。

### Q: 软链接路径是硬编码的吗？

**A**: 是的。软链接指向 `~/nixos-config/` 路径。如果你使用其他路径，需要修改配置文件中的路径。

### Q: 如何验证软链接是否生效？

**A**: 运行以下命令检查:

```bash
# 查看配置文件是否是软链接
ls -la ~/.config/starship.toml

# 应该看到类似输出:
# lrwxrwxrwx ... starship.toml -> /home/yorkwei/nixos-config/home/shell/starship/starship.toml
```

## 参考资料

- [NixOS & Flakes 指南 - 加速 Dotfiles 的调试](https://nixos-and-flakes.thiscute.world/zh-cn/other-optimizations/debug-dotfiles-faster)
- [Home Manager Options - xdg.configFile](https://nix-community.github.io/home-manager/options.html#opt-xdg.configFile)

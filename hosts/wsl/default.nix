# WSL 主机配置
# 这是 WSL 系统的主配置文件
# WSL 系统中没有 hardware-configuration.nix

{ config, lib, pkgs, ... }:
{
  imports = [
    # 导入可复用的模块
    ../../modules/system.nix
  ];

  # 系统级包(仅包含必要的系统工具)
  # 注意: git 已经在 modules/nix/default.nix 中作为 flakes 必需品安装
  environment.systemPackages = with pkgs; [
    # 仅添加真正需要系统级安装的工具
    # 大多数工具应该作为用户包安装(见 users/yorkwei/home-manager/default.nix)
  ];

  # 主机名
  networking.hostName = "wsl";

  # 启用 WSL 支持
  wsl.enable = true;
  # WSL 默认用户
  wsl.defaultUser = "yorkwei";
  # 启用 Docker Desktop 集成
  wsl.docker-desktop.enable = true;

  # NixOS 状态版本
  # 不要更改此值,除非了解其含义
  system.stateVersion = "25.05";
}

# WSL 主机配置
# 这是 WSL 系统的主配置文件
# WSL 系统中没有 hardware-configuration.nix

{ config, lib, pkgs, ... }:
{
  imports = [
    # 导入可复用的模块
    ../modules/system.nix
    # 导入用户配置
    ../users/yorkwei
  ];

  # ============================================
  # 用户账户设置
  # ============================================

  # 创建用户
  users.users.yorkwei = {
    isNormalUser = true;
    description = "York Wei";
    extraGroups = [ "wheel" "networkmanager" ];  # wheel = sudo 权限
    initialPassword = "changeme";  # 首次登录后请修改密码!
    shell = pkgs.nushell;  # 设置默认 shell 为 nushell
  };

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

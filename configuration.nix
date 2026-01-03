# NixOS-WSL 初始化配置
# 此文件仅用于首次在全新系统上启用 Flakes 和创建 yorkwei 用户
# 使用方法：sudo cp init/configuration.nix /etc/nixos/configuration.nix && sudo nixos-rebuild switch

{ config, pkgs, ... }:
{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  # 启用 Flakes 功能
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];

    # 使用清华镜像源加速下载
    substituters = [
      "https://mirror.tuna.tsinghua.edu.cn/nix-channels/store"
    ];
  };

  # 创建 yorkwei 用户
  users.users.yorkwei = {
    isNormalUser = true;
    description = "York Wei";
    extraGroups = [ "wheel" ];  # wheel = sudo 权限
    initialPassword = "";  # 首次登录后需要立即设置密码!
  };

  # 安装基础工具（用于首次部署）
  environment.systemPackages = with pkgs; [
    git       # 用于克隆项目仓库
  ];

  # WSL 默认用户设置为 yorkwei
  wsl.enable = true;
  wsl.defaultUser = "yorkwei";

  # NixOS 状态版本
  system.stateVersion = "25.05";
}

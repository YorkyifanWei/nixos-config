# Nix 设置模块
# 配置 Nix 包管理器的核心设置

{ config, lib, pkgs, ... }:
{
  # 启用 flakes 功能和优化存储空间
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];

    # 使用清华镜像源加速下载
    substituters = lib.mkForce [
      "https://mirrors.cernet.edu.cn/nix-channels/store"
    ];

    # 自动优化存储，节约磁盘空间
    # 也可以手动运行: nix-store --optimise
    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
    auto-optimise-store = true;
  };

  # 自动垃圾回收，保持低磁盘占用
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # 启用 nix-ld 以支持非 NixOS 二进制文件
  # 这允许运行未针对 NixOS 编译的二进制程序(如 VSCode Remote Server)
  # 参考: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/nix-ld.nix
  programs.nix-ld.enable = true;

  # Flakes 必需的系统包
  environment.systemPackages = with pkgs; [
    git
  ];
}

# Home Manager 主配置
# yorkwei 用户的个人配置
# 包含软件包管理和配置文件

{ config, pkgs, ... }:
{
  # ============================================
  # Home Manager 配置
  # ============================================

  home-manager = {
    # 使用系统的 nixpkgs,提高效率
    useGlobalPkgs = true;

    # 安装到用户配置文件
    useUserPackages = true;

    # 备份文件扩展名
    backupFileExtension = "hm-backup";

    # yorkwei 用户的 Home Manager 配置
    users.yorkwei = { ... }: {
      imports = [
        ./shell
        ./programs
        ./fonts
      ];

      # Home Manager 基本设置
      home.username = "yorkwei";
      home.homeDirectory = "/home/yorkwei";

      # 不要更改此值!
      home.stateVersion = "25.05";
    };
  };
}

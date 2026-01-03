# Home Manager 主配置
# yorkwei 用户的个人配置
# 包含用户账户设置、软件包管理和配置文件

{ config, pkgs, ... }:
{
  # imports = [
  #   ./shell
  #   ./programs
  #   ./fonts
  # ];

  # ============================================
  # 用户账户设置
  # ============================================

  # 创建用户
  users.users.yorkwei = {
    isNormalUser = true;
    description = "York Wei";
    extraGroups = [ "wheel" "networkmanager" ];  # wheel = sudo 权限
    initialPassword = "";  # 首次登录后请修改密码!
    shell = pkgs.nushell;  # 设置默认 shell 为 nushell
  };

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

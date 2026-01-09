# Git 配置
# 使用 Home Manager 的 programs.git 模块进行声明式配置

{ config, pkgs, ... }:
{
  # Git 配置
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "魏一凡";
    userEmail = "yorkwei_69473@163.com";

    extraConfig = {
      init.defaultBranch = "master";
      credential.helper = "store";

      # GitHub 镜像加速
      url."https://githubfast.com/".insteadOf = "https://github.com/";
    };
  };
}

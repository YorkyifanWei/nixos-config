# Zellij 终端复用器配置
# 使用软链接，修改配置后无需重新构建即可生效

{ config, pkgs, ... }:
let
  # Zellij 配置目录的绝对路径
  zellijPath = "${config.home.homeDirectory}/nixos-config/home/programs/zellij";
in
{
  # 使用软链接指向整个配置目录
  xdg.configFile."zellij".source =
    config.lib.file.mkOutOfStoreSymlink zellijPath;
}

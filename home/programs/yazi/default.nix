# Yazi 文件管理器配置
# 使用软链接，修改配置后无需重新构建即可生效

{ config, pkgs, ... }:
let
  # Yazi 配置目录的绝对路径
  yaziPath = "${config.home.homeDirectory}/nixos-config/home/programs/yazi";
in
{
  # 使用软链接指向整个配置目录
  xdg.configFile."yazi".source =
    config.lib.file.mkOutOfStoreSymlink yaziPath;
}

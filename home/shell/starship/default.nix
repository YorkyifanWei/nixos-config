# Starship Prompt 配置
# 使用软链接，修改配置后无需重新构建即可生效

{ config, pkgs, ... }:
let
  # Starship 配置目录的绝对路径
  starshipPath = "${config.home.homeDirectory}/nixos-config/home/shell/starship";
in
{
  # 使用软链接指向整个配置目录
  xdg.configFile."starship".source =
    config.lib.file.mkOutOfStoreSymlink starshipPath;
}

# Helix 编辑器配置
# 使用软链接，修改配置后无需重新构建即可生效

{ config, pkgs, ... }:
let
  # Helix 配置目录的绝对路径
  helixPath = "${config.home.homeDirectory}/nixos-config/home/programs/helix";
in
{
  # 使用软链接指向整个配置目录
  xdg.configFile."helix".source =
    config.lib.file.mkOutOfStoreSymlink helixPath;
}

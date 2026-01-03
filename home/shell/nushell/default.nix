# Nushell 配置
# 使用软链接，修改配置后无需重新构建即可生效

{ config, pkgs, ... }:
let
  # Nushell 配置目录的绝对路径
  # 假设配置仓库位于 ~/nixos-config
  nushellPath = "${config.home.homeDirectory}/nixos-config/home/shell/nushell";
in
{
  # 使用软链接指向整个配置目录
  xdg.configFile."nushell".source =
    config.lib.file.mkOutOfStoreSymlink nushellPath;
}

# Shell 配置
# 导入所有 shell 相关配置

{ config, pkgs, ... }:
{
  imports = [
    ./common.nix
    ./nushell
    ./starship
  ];
}

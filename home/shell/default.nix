# Shell 配置
# 导入所有 shell 相关配置

{ config, pkgs, ... }:
{
  imports = [
    ./common.nix
    ./nushell
    ./starship
  ];

  # Shell 相关软件包
  home.packages = with pkgs; [
    nushell       # 现代 shell
    starship      # 现代 prompt 工具
  ];
}

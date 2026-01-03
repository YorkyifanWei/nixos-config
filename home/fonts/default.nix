# 字体配置
# 使用 Home Manager 管理用户字体

{ config, pkgs, ... }:
{
  # 字体包
  home.packages = with pkgs; [
    # Nerd Fonts (带图标的等宽字体)
    nerd-fonts.jetbrains-mono
  ];

  # 启用 Fontconfig
  fonts.fontconfig.enable = true;
}

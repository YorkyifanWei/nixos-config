# 字体配置
# 使用 Home Manager 管理用户字体

{ config, pkgs, ... }:
{
  # 字体包
  home.packages = with pkgs; [
    # Nerd Fonts (带图标的等宽字体)
    nerd-fonts.jetbrains-mono
    # Noto 字体系列
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];

  # 启用 Fontconfig
  fonts.fontconfig.enable = true;

  # 设置默认字体
  fonts.fontconfig.defaultFonts = {
    serif     = [ "Noto Serif CJK SC" "Noto Serif" ];
    sansSerif = [ "Noto Sans CJK SC" "Noto Sans" ];
    monospace = [ "JetBrains Mono" "Noto Sans Mono CJK SC" "Noto Mono" ];
    emoji     = [ "Noto Color Emoji" ];
  };
}

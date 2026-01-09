# Programs 配置
# 导入所有程序相关配置

{ config, pkgs, ... }:
{
  imports = [
    ./git.nix
    ./helix
    ./yazi
    ./zellij
  ];

  # 所有程序相关的软件包
  home.packages = with pkgs; [
    # 常用命令行小工具
    wget          # 网络下载工具
    tree          # 目录树展示工具

    # 命令行工具增强
    ripgrep       # 更快的 grep
    fzf           # 模糊查找工具
    fd            # 更好的 find
    zoxide        # 智能目录跳转

    # 版本控制
    lazygit       # Git TUI 工具

    # 多媒体和文件处理
    ffmpeg        # 多媒体处理
    pandoc        # 文档格式转换
    jq            # JSON 处理
    imagemagick   # 图片处理

    # 压缩工具
    _7zz          # 7zip 压缩工具

    # PDF 处理
    poppler-utils # PDF 处理

    # 剪贴板工具(WSL 可能需要)
    xclip         # X11 剪贴板
    wl-clipboard  # Wayland 剪贴板
    xsel          # X11 选择工具

    # 开发工具
    rustup        # Rust 工具链管理器
    go            # Go 编程语言
    uv            # Python 包管理和项目管理工具
    devbox        # 开发环境管理工具
    just          # 命令运行工具
    claude-code   # Claude AI 命令行工具
  ];
}

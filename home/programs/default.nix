# Programs 配置
# 导入所有程序相关配置

{ config, pkgs, ... }:
{
  imports = [
    ./git.nix
    ./helix
    ./lazygit
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
    git           # 版本控制系统
    lazygit       # Git TUI 工具

    # 编辑器
    helix         # 模态编辑器

    # 终端复用器
    zellij        # 现代终端复用器

    # 文件管理器
    yazi          # 终端文件管理器

    # 多媒体和文件处理
    ffmpeg        # 多媒体处理
    jq            # JSON 处理
    imagemagick   # 图片处理

    # 压缩工具
    _7zz          # 7zip 压缩工具

    # PDF 处理
    poppler_utils # PDF 处理

    # 排版工具
    typst         # 现代排版系统
    typstyle      # Typst 代码格式化工具

    # 剪贴板工具(WSL 可能需要)
    xclip         # X11 剪贴板
    wl-clipboard  # Wayland 剪贴板
    xsel          # X11 选择工具

    # 开发工具
    rustup        # Rust 工具链管理器
    go            # Go 编程语言
    fnm           # Node.js 版本管理器
    claude-code   # Claude Code CLI 工具
  ];
}

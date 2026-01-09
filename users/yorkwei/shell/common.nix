# Shell 通用配置
# 环境变量和通用设置

{ config, pkgs, ... }:
{
  # 环境变量
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";

    # XDG 目录
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";

    # uv
    UV_CACHE_DIR = "$XDG_CACHE_HOME/uv";
    UV_PYTHON_INSTALL_DIR = "$XDG_DATA_HOME/uv/python";
    UV_TOOL_DIR = "$XDG_DATA_HOME/uv/tools";

    # Rust
    CARGO_HOME = "$XDG_DATA_HOME/cargo";
    RUSTUP_HOME = "$XDG_DATA_HOME/rustup";

    # Go
    GOPATH = "$XDG_DATA_HOME/go";
    GOMODCACHE = "$XDG_DATA_HOME/go/pkg/mod";

    # Gradle
    GRADLE_USER_HOME = "$XDG_DATA_HOME/gradle";

    # Starship
    STARSHIP_CONFIG = "$XDG_CONFIG_HOME/starship.toml";
  };

  # PATH
  home.sessionPath = [
    # Cargo bin 目录
    "$CARGO_HOME/bin"
    # Go bin 目录
    "$GOPATH/bin"
  ];
}

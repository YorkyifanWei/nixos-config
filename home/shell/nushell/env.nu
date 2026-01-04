# env.nu
#
# Installed by:
# version = "0.109.1"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

# 全局环境变量
## 终端色彩标记
$env.COLORTERM = "truecolor"
## XDG 目录设置
$env.XDG_DATA_HOME   = ($env.HOME | path join ".local" "share")
$env.XDG_CACHE_HOME  = ($env.HOME | path join ".cache")
$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")

# 各语言工具环境变量设置
## uv
$env.UV_CACHE_DIR = ($env.XDG_CACHE_HOME | path join "uv")
$env.UV_PYTHON_INSTALL_DIR = ($env.XDG_DATA_HOME | path join "uv" "python")
$env.UV_TOOL_DIR = ($env.XDG_DATA_HOME | path join "uv" "tools")
## fnm
$env.FNM_DIR = ($env.XDG_DATA_HOME | path join "fnm")
## rustup+cargo
$env.RUSTUP_HOME = ($env.XDG_DATA_HOME | path join "rustup")
$env.CARGO_HOME = ($env.XDG_DATA_HOME | path join "cargo")
## go
$env.GOPATH = ($env.XDG_DATA_HOME | path join "go")
$env.GOMODCACHE = ($env.GOPATH | path join "pkg" "mod")
## gradle
$env.GRADLE_USER_HOME = ($env.XDG_DATA_HOME | path join "gradle")

# 其他工具环境变量设置
## Claude Code
$env.CLAUDE_CONFIG_DIR = ($env.XDG_DATA_HOME | path join "claude-code")

# Path 环境变量设置
## Cargo 全局编译产物
$env.Path = ($env.Path | prepend $"($env.CARGO_HOME)/bin")
## Go 全局编译产物
$env.Path = ($env.Path | prepend $"($env.GOPATH)/bin")
## Node.js 工具
$env.Path = ($env.Path | prepend $"($env.FNM_DIR)/aliases/default/bin")

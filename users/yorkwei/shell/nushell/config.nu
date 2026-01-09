# config.nu
#
# Installed by:
# version = "0.109.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# Nushell 本体相关设置
## 关闭 Nushell 启动时显示的欢迎消息
$env.config.show_banner = false
## Nushell 设置默认编辑器
$env.config.buffer_editor = "hx"
## 设置 la 和 ll 函数
alias la  = ls -a
alias ll  = ls -l
alias lla = ls -al
## 设置 “用 Windows 文件资源管理器打开” 别名
alias explorer = explorer.exe
## 设置 `sudo nixos-rebuild switch --flake ~/nixos-config#wsl` 别名
alias nixconfig = cd ~/nixos-config


# Starship 配置
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# zoxide 配置
mkdir ($nu.data-dir | path join "vendor/autoload")
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

# Yazi 配置
## y shell wrapper
def --env y [...args] {
        let tmp = (mktemp -t "yazi-cwd.XXXXXX")
        yazi ...$args --cwd-file $tmp
        let cwd = (open $tmp)
        if $cwd != "" and $cwd != $env.PWD {
                cd $cwd
        }
        rm -fp $tmp
}

# 7zip 配置
## 用于处理 nushell 兼容性问题的函数（调用 bash 来处理）
## 适用于通过 7zip 官方 dnf 包安装的 7z
#def --wrapped 7z [...args] {
#  # 关键点：
#  # - 用 bash -lc 走 bash 的命令解析/环境
#  # - 用 "$@" 原样传参，避免空格/特殊字符参数被弄乱
#  ^bash -lc 'command 7z "$@"' bash -- ...$args
#}
## 7z 别名设置（用于 _7zz）
alias 7z = 7zz

# Lazygit 配置
alias lg = lazygit

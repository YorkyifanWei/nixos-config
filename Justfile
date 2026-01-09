# NixOS 配置管理
# 默认主机名: wsl,可通过 just switch host=xxx 指定

host := "wsl"

# 系统操作
switch host:
  sudo nixos-rebuild switch --flake .#{{host}}

switch-verbose host:
  sudo nixos-rebuild switch --flake .#{{host}} --show-trace -L -v

build host:
  sudo nixos-rebuild build --flake .#{{host}}

test host:
  sudo nixos-rebuild test --flake .#{{host}}

# Flakes 管理
update:
  nix flake update

update-input input:
  nix flake update {{input}}

info:
  nix flake show

check:
  nix flake check

# 系统管理
list-gen:
  sudo nixos-rebuild list-generations

rollback:
  sudo nixos-rebuild switch --rollback

rollback-to generation:
  sudo nixos-rebuild switch --switch-generation {{generation}}

# 存储管理
clean-history:
  sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system

collect-garbage:
  sudo nix-collect-garbage --delete-old

collect-garbage-home:
  nix-collect-garbage --delete-old

optimise:
  nix-store --optimise

clean: clean-history collect-garbage optimise
  @echo "清理完成!"

du:
  @nix-store --query --requisites /run/current-system | du -sh *

# 包管理
search package:
  nix search nixpkgs {{package}}

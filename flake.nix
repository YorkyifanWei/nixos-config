{
  description = "NixOS-WSL 配置 with Home Manager";

  inputs = {
    # 使用清华镜像的 Nixpkgs
    nixpkgs.url = "git+https://mirrors.cernet.edu.cn/nixpkgs.git?ref=nixos-unstable&shallow=1";

    # NixOS-WSL 官方 flake (使用 githubfast 镜像加速)
    nixos-wsl.url = "git+https://githubfast.com/nix-community/NixOS-WSL.git?ref=release-25.05&shallow=1";

    # Home Manager
    home-manager = {
      url = "git+https://githubfast.com/nix-community/home-manager.git?ref=release-25.05&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixos-wsl, home-manager, ... }: {
    # NixOS 系统配置
    nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
      };

      modules = [
        # NixOS-WSL 模块
        nixos-wsl.nixosModules.default

        # Home Manager NixOS 模块
        home-manager.nixosModules.home-manager

        # 主机特定配置
        ./hosts/wsl/default.nix

        # 用户配置和 Home Manager 集成
        ./home

        # 允许非自由软件包(如 vista-fonts-chs)
        { nixpkgs.config.allowUnfree = true; }
      ];
    };
  };
}

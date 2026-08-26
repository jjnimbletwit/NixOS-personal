{
  description = "NixOS from Scratch";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ncspot-src = {
      url = "github:hrkfdn/ncspot";
      flake = false;
    };
    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
	


  outputs = { self, nixpkgs, home-manager, nix-flatpak, waybar, ncspot-src, ... }: {
    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        nix-flatpak.nixosModules.nix-flatpak
        {
          environment.systemPackages = [
            waybar.packages.x86_64-linux.waybar
          ];
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit ncspot-src;
            };
            users.Jasper = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}

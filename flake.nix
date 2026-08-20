{
	description = "NixOS from Scratch";
	inputs = {
		nixpks.url = "nixpkgs/nixos-unstable";
		nix-flatpak.url = "github:gmodena/nix-flatpak";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	


	outputs = { self, nixpkgs, home-manager, nix-flatpak, ... }: {
		nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./configuration.nix
				home-manager.nixosModules.home-manager
				nix-flatpak.nixosModules.nix-flatpak
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.Jasper = import ./home.nix;
						backupFileExtension = "backup";
					};
				}
			];
		};
	};
}

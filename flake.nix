{
	description = "NixOS from Scratch";
	inputs = {
		nixpkgs.url = "nixpkgs/nixos-26.05";
		nix-flatpak.url = "github:gmodena/nix-flatpak";
		home-manager = {
			url = "github:nix-community/home-manager/release-26.05";
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

{
  description = "Nice Flake";
  inputs = {
    nixpkgs-lutris-pin.url = "nixpkgs/nixos-24.05";
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-lutris-pin,  home-manager, ... }@inputs:
  let
    inherit (self) outputs;
    system = "x86_64-linux";
    overlays = (import ./overlays);
    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system overlays;
      config.allowUnfree = true;
    };
    pkgs-lutris-pin = import nixpkgs-lutris-pin {
      inherit system overlays;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.dellG = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs outputs pkgs-lutris-pin pkgs-unstable; };
        modules = [
          { nixpkgs.overlays = overlays; }
          ./hosts/dellG
          ./modules/system
        ];
    };
    homeConfigurations = {
      keisuke5 = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./users/keisuke5  ];
          extraSpecialArgs = { inherit inputs outputs pkgs-lutris-pin pkgs-unstable; };
      };
    };
  };
}

{ config, lib, pkgs-unstable, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs-unstable.linuxPackages_xanmod_latest;
  time.timeZone = "Asia/Kolkata";
  environment.etc = { "machine-id".source = "/nix/persist/etc/machine-id"; };
  fileSystems."/var/log" = {
    device = "/nix/persist/var/log";
    fsType = "none";
    options = [ "bind" ];
    neededForBoot = true;
  };
  networking.hostName = "nixos-dellG";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-runtime-6.0.36"
  ];
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  system.stateVersion = "23.11";
}


{ config, lib, pkgs, inputs, ... }: {

  #Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages-rt_latest;

  #Desktop
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.defaultSession = "gnome-xorg";
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);
  environment.systemPackages = with pkgs; [ gnomeExtensions.appindicator ];
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  #Sound
  sound.enable = false;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #Video
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      nvidia-vaapi-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  hardware.nvidia = {
    nvidiaSettings = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  #Swap
  services.swapfile = {
    enable = true;
    path = "/nix/persist/swapfile";
    size = 12;
    swappiness = 1;
  };

  #Power
#  services.thermald.enable = true;
#  services.auto-cpufreq.enable = true;
#  services.auto-cpufreq.settings = {
#    battery = {
#      governor = "powersave";
#      turbo = "never";
#    };
#    charger = {
#      governor = "performance";
#      turbo = "auto";
#    };
#  };

  #Network
  networking.networkmanager.enable = true;

  #Services
#  programs.dell-gameshift.enable = true;
  programs.adb.enable = true;
  programs.gamemode.enable = true;
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = false;
  };
  programs.dconf.enable = true;

  #Users
  users.mutableUsers = false;
  users.users.keisuke5 = {
    home = "/home/keisuke5";
    initialHashedPassword =
      "$6$ZKqa0w3vM1rX9f1W$GvWMBomAs1pSgwQ2C6p8DZg5tvOdGNIxks7RpPUcIY9Rnf.aLH3kBPkEts28FFfPtkHXtTM.q0JkXP.u5m4NC0";
    isNormalUser = true;
    extraGroups =
      [ "wheel" "power" "video" "docker" "vboxusers" "libvirtd" "qemu-libvirtd" ];
  };
  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "keisuke5";
  };

  #Locale
  time.timeZone = "Asia/Kolkata";

  #Persistance
  systemd.tmpfiles.rules = [
    "L /var/lib/bluetooth - - - - /nix/persist/var/lib/bluetooth"
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
    "f /dev/shm/looking-glass 0660 keisuke5 qemu-libvirtd -"
  ];
  environment.etc = {
    "machine-id".source = "/nix/persist/etc/machine-id";
    "libinput/local-overrides.quirks".source =
      "/nix/persist/etc/libinput/local-overrides.quirks";
    "NetworkManager/system-connections".source =
      "/nix/persist/etc/NetworkManager/system-connections";
  };
  fileSystems."/var/log" = {
    device = "/nix/persist/var/log";
    fsType = "none";
    options = [ "bind" ];
    neededForBoot = true;
  };
  fileSystems."/var/lib/libvirt" = {
    device = "/nix/persist/var/lib/libvirt";
    fsType = "none";
    options = [ "bind" ];
    neededForBoot = true;
  };

  #Nixos
  networking.hostName = "nixos-dellG";
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  system.stateVersion = "23.11";
}

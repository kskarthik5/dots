{ config, ... }: {
  
  environment.etc."machine-id".source = "/nix/persist/etc/machine-id";

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=2G" "mode=755" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D843-AF23";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/f2dcf431-75b2-4c13-8aa1-4c969cfee1ad";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/1c51b8ca-6149-4cb6-ac88-64d7a979f861";
    fsType = "ext4";
  };

  fileSystems."/etc/NetworkManager" = {
    device = "/nix/persist/etc/NetworkManager";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/var/log" = {
    device = "/nix/persist/var/log";
    fsType = "none";
    options = [ "bind" ];
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/23f47901-1e50-4506-b86f-367d5807b669"; }];
}

{config, ... }:{
  hardware.graphics = { 
    enable = true;
    enable32Bit = true;
  };
  boot.kernelParams = [ "nvidia-drm.fbdev=1" ];
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
}

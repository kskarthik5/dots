{ config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    dconf
    simplescreenrecorder
    networkmanagerapplet
    pasystray
    xterm
    lf
    alacritty
    lxappearance
    pcmanfm
    htop
    discord
    neofetch
    picom
    nicotine-plus
    picard
    git
    nixfmt
    rhythmbox
    mpv
    transmission-gtk
    tree
    dunst
    flac
    unar
    brightnessctl
    unzip
    xfce.xfce4-screenshooter
    xfce.xfce4-clipman-plugin
    steam
    steam-run
    mangohud
    glxinfo
    steamtinkerlaunch
    #Custom
    (callPackage ../../pkgs/bgScripts.nix { })
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ zlib openssl.dev pkg-config]);
  };
}

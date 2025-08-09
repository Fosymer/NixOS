{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];


  ## Boot Configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.timeout = 5;
  boot.supportedFilesystems = [ "ntfs" ];

  ##  Host & Time Settings
  networking.hostName = "Cole-Laptop";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_ADDRESS = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
  };

  ## Wayland + Plasma 6
  services.xserver.enable = false;
  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  ## Sound (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ## Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  ## User Setup
    users.users.cole = {
    isNormalUser = true;
    description = "Cole Yokley";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "input" "libvirtd" "podman" ];
    packages = with pkgs; [
      kdePackages.kate
      kdePackages.kdenlive
      kdePackages.krdc
      kdePackages.plasma-browser-integration
    ];
  };

  ## Nix-ld
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ ];

  ## Shell Enhancements
  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "git" "z" "zoxide" "sudo" "tailscale" "vscode" "virtualenv" ];
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
  };

  environment.etc."zshrc".text = ''
    eval "$(oh-my-posh init zsh --config https://raw.githubusercontent.com/Fosymer/Oh-My-Posh-Config/main/Config.yaml)"
  '';

  ## Allow Unfree Packages
  nixpkgs.config.allowUnfree = true;

  ## Virtualization
  virtualisation.libvirtd.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.waydroid.enable = true;

  ## Networking / Tools
  services.tailscale.enable = true;
  programs.steam.enable = true;

  ## Logitech
  hardware.logitech.wireless.enable = true;

  ## Sudo NOPASSWD
  security.sudo.wheelNeedsPassword = false;
  environment.etc."polkit-1/rules.d/99-wheel-bypass.rules".text = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return "yes";
      }
    });
  '';

  ## Misc System Packages
  environment.systemPackages = with pkgs; [
    google-chrome
    zsh
    oh-my-posh
    git
    waydroid
    zsh-autosuggestions
    zsh-syntax-highlighting
    solaar
    logitech-udev-rules
    zoxide
    virt-manager
    libvirt
    killall
    ktailctl
    tailscale
    appimage-run
    vscode-fhs
    uv
    gcc
    python310
    distrobox
    kdePackages.partitionmanager
    everest-mons
    nil
    pipx
    libimobiledevice
    glibc
    libglibutil
    pmbootstrap
    nix-index
    rpi-imager
  ];


  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 5d";
  };


  ## Optional Services
  services.printing.enable = true;

  ## System State Version
  system.stateVersion = "25.05";
}

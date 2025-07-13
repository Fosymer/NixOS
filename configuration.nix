# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Cole-Laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


  # Enable networking
  networking.networkmanager.enable = true;

  # Enable Waydroid
  virtualisation.waydroid.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  # Enable and startup bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.wayland.enable = true;


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  #Mount HDD
  fileSystems."/mnt/HDD" = {
    device = "/dev/disk/by-uuid/84d94213-f39a-4fd7-a9c9-3e38d5dded35";
    fsType = "ext4";  # Change this according to your file system (e.g., "btrfs", "xfs", "ntfs-3g")
    options = [ "defaults" ];  # Optional: add mount options
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cole = {
    isNormalUser = true;
    description = "Cole Yokley";
    extraGroups = [ "networkmanager" "wheel" "input" "libvirtd" "podman"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kdePackages.kate
      kdePackages.plasma-browser-integration
      kdePackages.kdenlive
      kdePackages.krdc
    ];
  };

  # Enable Tailscale
  services.tailscale.enable = true;

  # Enable Steam
  programs.steam.enable = true;

  # Enable virtualisation and Podman
  virtualisation.libvirtd.enable = true;
  virtualisation.podman.enable = true;

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = false;
  services.displayManager.autoLogin.user = "cole";


  # Enable Logitech Hardware
  hardware.logitech.wireless.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
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
  ventoy-full
  appimage-run
  vscode-fhs
  uv
  gcc
  checkra1n
  python310
  distrobox
  boxbuddy
  podman
  python39Packages.pipx
  kdePackages.partitionmanager
  fusee-launcher
  everest-mons
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # sudo NOPASSWD
    security.sudo.wheelNeedsPassword = false;
    environment.etc."polkit-1/rules.d/99-wheel-bypass.rules".text = ''
  polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
          return "yes";
      }
  });
'';
  #Oh-My-Posh and Oh-My-Zsh
  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "git" "z" "zoxide" "sudo" "tailscale" "vscode" "virtualenv"];
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

};
  environment.etc."zshrc".text = ''
    eval "$(oh-my-posh init zsh --config https://raw.githubusercontent.com/Fosymer/Oh-My-Posh-Config/main/Config.yaml)"
  '';


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}

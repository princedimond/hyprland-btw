{ pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./config/fonts.nix
      ./config/packages.nix
    ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };


  zramSwap = {
    enable = true;
    memoryPercent = 40; # use ~50% of RAM for compressed swap (tweak as you like)
    priority = 100; # higher than any disk-based swap
  };

  networking = {
    hostName = "PD-TJ19380NLV";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Chicago";

  # GPU/VM profile for this single-host system
  # Current host: VM with virtio GPU (no dedicated AMD/Intel/NVIDIA module enabled).
  # The installer will set exactly ONE of these to true based on your GPU profile:
  drivers.amdgpu.enable = false; # AMD GPUs
  drivers.intel.enable = true; # Intel iGPU
  drivers.nvidia.enable = false; # NVIDIA GPUs

  # Enable VM guest services via the drivers module when running in a VM.
  # Disable this if you are installing on bare metal without QEMU/Spice.
  vm.guest-services.enable = false;

  # Add services 
  services = {
    getty.autologinUser = null; # disable auto-login
    openssh.enable = true;
    tumbler.enable = true;
    envfs.enable = true;
    seatd.enable = true;
    upower.enable = true;
    gnome.gnome-keyring.enable = true;
    libinput.enable = true;
    # Default XKB layout for Hyprland/X11 (overridden by installer).
    xserver.xkb.layout = "us";
    flatpak.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    displayManager.ly = {
      enable = true;
      settings = {
        animation = "matrix";
        bigclock = "true";
      };
    };
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = false;
    };
    firefox.enable = false;
    thunar.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh.enable = true; # ensure system zsh is configured for login shells
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";


  # Default console keymap (overridden by installer).
  console.keyMap = "us";

  # Define the primary user account. Don't forget to set a password with ‘passwd’.
  users.users."princedimond" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" ];
    home = "/home/princedimond";
    createHome = true;
    shell = pkgs.zsh;
  };


  # Example: add additional users (uncomment and adjust as needed)
  # users.users."seconduser" = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ];
  #   shell = pkgs.zsh;
  #   packages = with pkgs; [
  #     git
  #     htop
  #   ];
  # };

  systemd.services.flatpak-add-flathub = {
    description = "Add Flathub Flatpak remote";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" "flatpak-system-helper.service" ];
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };


  # Qt6 environment for quickshell
  environment = {
    sessionVariables = {
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };
    shellAliases = {
      fr = "nh os switch --hostname PD-TJ19380NLV ~/hyprland-btw";
      fu = "nh os switch --hostname PD-TJ19380NLV ~/hyprland-btw --update";
    };
  };

  nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  users.mutableUsers = true;
  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "25.11"; # Did you read the comment?

}


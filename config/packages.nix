{ pkgs, pkgs-unstable, ... }:
{
  #  Add packages below.

  environment.systemPackages =
    with pkgs;
    [
      ## Hyprland specific
      hyprpaper
      hyprshot
      hypridle
      hyprlock
      hyprpicker
      libnotify # send alerts
      xdg-desktop-portal-hyprland

      # Hyprland Related
      app2unit # launcher
      clipman
      cliphist
      grim
      quickshell
      libinput-gestures
      slurp
      nwg-look
      rofi
      wofi
      #waybar
      matugen
      wl-clipboard
      # Qt6 dependencies for quickshell-overview
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtwayland
      qt6.qt5compat
      qt6.qtmultimedia

      # Add your packages here
      #alejandra
      #atop
      bat
      btop
      #bottom
      catppuccin
      cargo
      #clang
      curl
      coreutils
      #dino # Jabber XMPP Client
      direnv # needed for zsh plugin and vscode
      fastfetch
      ferdium
      #foot
      #gajim # Japper XMPP client
      git
      #gcc
      gh
      gitkraken
      gping
      #htop
      #hyfetch
      inxi
      #kitty
      bibata-cursors
      keyd
      #lunarvim # Alternate neovim (lvim)
      #luarocks # LUA for nevoim
      #mdcat
      mesa-demos # needed for inxi
      meld
      microsoft-edge
      ncdu
      #nixd # nix lsp
      onefetch
      onlyoffice-desktopeditors
      pciutils
      #ranger
      #ripgrep
      rustup
      starship
      tmux # Terminal mux with hybridd ddubs-tonybtw config
      ugrep
      warp-terminal
      wget
      #zig
    ]
    ++ (with pkgs-unstable; [
      zed-editor
    ]);
}

{ config, lib, ... }:
let
  overviewSource = ./overview;
in
{
  # Quickshell-overview is a Qt6 QML app for Hyprland workspace overview
  # It shows all workspaces with live window previews, drag-and-drop support
  # Toggled via: SUPER + TAB (bound in config/hypr/binds.conf)
  # Started via exec-once in config/hypr/startup.conf

  # Seed the Quickshell overview code into ~/.config/quickshell/overview
  # Copy (not symlink) so QML module resolution works and users can edit files
  home.activation.seedOverviewCode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set -eu
    DEST="$HOME/.config/quickshell/overview"
    SRC="${overviewSource}"
    
    mkdir -p "$HOME/.config/quickshell"
    # Remove old directory and copy fresh (ensures QML updates are picked up)
    rm -rf "$DEST"
    cp -R "$SRC" "$DEST"
    chmod -R u+rwX "$DEST"
  '';
}

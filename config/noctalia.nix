{
  pkgs,
  inputs,
  ...
}: let
  noctaliaPath = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
  configDir = "${noctaliaPath}/share/noctalia-shell";
  # Provide a convenient `qs` shim so Hyprland bindings can call `qs -c ...`.
  qsShim = pkgs.writeShellScriptBin "qs" ''
    #!/usr/bin/env bash
    exec quickshell "$@"
  '';
in {
  # Ensure QuickShell is available to run `qs -c noctalia-shell`
  home.packages = [ pkgs.quickshell qsShim ];

  # Expose the Noctalia QuickShell config at ~/.config/quickshell/noctalia-shell
  xdg.configFile."quickshell/noctalia-shell".source = configDir;
}

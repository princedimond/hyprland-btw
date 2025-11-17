{
  pkgs,
  inputs,
  ...
}: let
  noctaliaPath = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
  configDir = "${noctaliaPath}/share/noctalia-shell";
in {
  # Ensure QuickShell is available to run `qs -c noctalia-shell`
  home.packages = [ pkgs.quickshell ];

  # Expose the Noctalia QuickShell config at ~/.config/quickshell/noctalia-shell
  xdg.configFile."quickshell/noctalia-shell".source = configDir;
}

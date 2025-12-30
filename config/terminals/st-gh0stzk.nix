{ pkgs, lib, ... }:
let
  st-gh0stzk = pkgs.stdenv.mkDerivation rec {
    pname = "st-gh0stzk";
    version = "0.9.2-graphics";
    src = ./st-terminal;

    nativeBuildInputs = [
      pkgs.pkg-config
      pkgs.ncurses
    ];
    buildInputs = [
      pkgs.zlib
      pkgs.imlib2
      pkgs.harfbuzz
      pkgs.freetype
      pkgs.fontconfig
      pkgs.xorg.libX11
      pkgs.xorg.libXft
      pkgs.xorg.libXrender
      pkgs.xorg.libXinerama
    ];

    # The upstream Makefile installs terminfo globally via `tic`. We install into $out
    # and place desktop/man under $out as well, so the package is self-contained.
    buildPhase = ''
      runHook preBuild
      make
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/bin" "$out/share/applications" "$out/share/man/man1" "$out/share/terminfo"
      install -m 0755 st "$out/bin/st"
      sed "s/VERSION/${version}/g" < st.1 > "$out/share/man/man1/st.1"
      install -m 0644 st.desktop "$out/share/applications/st.desktop"
      # Compile terminfo into the output tree
      ${pkgs.ncurses}/bin/tic -sx -o "$out/share/terminfo" st.info
      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "gh0stzk's patched st (st-graphics) with Kitty graphics protocol and other patches";
      homepage = "https://github.com/gh0stzk/st-terminal";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = [];
    };
  };
in
{
  # Install the terminal for the user/session. You can move this to system packages if preferred.
  home.packages = [
    st-gh0stzk
    # Optional: alternate launcher name to avoid collisions
    (pkgs.writeShellScriptBin "st-gh0stzk" ''
      exec st "$@"
    '')
  ];
}

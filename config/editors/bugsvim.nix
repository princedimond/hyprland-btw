{
  config,
  pkgs,
  lib,
  ...
}: let
  # Reference the local bugsvim config directory in this repo
  bugsvimSrc = ./bugsvim-nvim;
in {
  programs.neovim = lib.mkForce {
    enable = true;
    defaultEditor = false;
    vimAlias = false;
    viAlias = false;
    withNodeJs = true;
    withPython3 = true;

    # Install all required tools and language servers
    extraPackages = with pkgs; [
      # Language Servers
      lua-language-server
      pyright
      nodePackages.typescript-language-server
      tailwindcss-language-server
      clang-tools
      nodePackages.bash-language-server
      rust-analyzer
      nodePackages.vscode-langservers-extracted # html, css, json, eslint
      nil # Nix LSP
      hyprls

      # Formatters
      stylua
      ruff
      prettierd
      clang-tools # includes clang-format
      shfmt
      alejandra

      # Linters
      ruff
      nodePackages.eslint_d
      luajitPackages.luacheck
      cpplint

      # Additional tools
      ripgrep
      fd
      tree-sitter
      git
    ];
  };

  # Copy bugsvim config files as writable (not RO symlinks) so lazy.nvim can manage them
  xdg.configFile = let
    # Helper to recursively map directory contents
    mapDir = source: target:
      lib.mapAttrs' (name: _:
        lib.nameValuePair
        "nvim/${target}/${name}"
        {
          source = "${source}/${name}";
        })
      (builtins.readDir source);
  in
    # Copy root config files
    {
      "nvim/init.lua" = {
        source = "${bugsvimSrc}/init.lua";
      };
      "nvim/.stylua.toml" = {
        source = "${bugsvimSrc}/.stylua.toml";
      };
      "nvim/.luacheckrc" = {
        source = "${bugsvimSrc}/.luacheckrc";
      };
      "nvim/.luarc.json" = {
        source = "${bugsvimSrc}/.luarc.json";
      };
    }
    # Copy lua config modules
    // (mapDir "${bugsvimSrc}/lua/config" "lua/config")
    # Copy plugin configurations
    // (mapDir "${bugsvimSrc}/lua/plugins" "lua/plugins")
    # Copy language server configurations
    // (mapDir "${bugsvimSrc}/lua/servers" "lua/servers")
    # Copy utility modules
    // (mapDir "${bugsvimSrc}/lua/utils" "lua/utils");

  # Optional: Ensure directories and undo setup on first activation
  home.activation = {
    bugsvimSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
      # Create undo directory if it doesn't exist
      UNDO_DIR="$HOME/.local/share/nvim/undodir"
      if [ ! -d "$UNDO_DIR" ]; then
        $DRY_RUN_CMD mkdir -p "$UNDO_DIR"
        echo "Created NeoVim undo directory at $UNDO_DIR"
      fi

      # Lazy.nvim will self-bootstrap on first nvim run
      # The init.lua handles automatic cloning if lazy.nvim is not present
    '';
  };
}

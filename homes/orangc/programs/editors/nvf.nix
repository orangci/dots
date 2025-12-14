{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.hmModules.programs.editors.nvf;
in
{
  imports = [ inputs.nvf.homeManagerModules.default ];
  options.hmModules.programs.editors.nvf.enable = mkEnableOption "Enable neovim with nvf";

  config = mkIf cfg.enable {
    hmModules.programs.editors.xdg = "nvim";
    programs.nvf = {
      enable = true;
      defaultEditor = true;
      # this nvf configuration is based on https://github.com/fxzzi/NixOhEss/blob/main/modules/programs/nvf.nix
      # thanks fazzi
      settings.vim = {
        preventJunkFiles = true;
        undoFile.enable = true;
        enableLuaLoader = true;
        viAlias = true;
        vimAlias = true;
        clipboard = {
          enable = true;
          providers.wl-copy.enable = true;
        };

        lsp = {
          formatOnSave = true;
          trouble.enable = true;
          lspSignature.enable = true;
          lightbulb.enable = true;
        };

        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };

        lsp.enable = true;

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          nix = {
            inherit (config.hmModules.dev.nix) enable;
            lsp = {
              enable = true;
            };
          };
          markdown.enable = true;
          bash.enable = true;
          css.enable = true;
          html.enable = true;
          rust = {
            inherit (config.hmModules.dev.rust) enable;
            lsp.enable = true;
          };
          python.enable = config.hmModules.dev.python.enable;
        };

        notes = {
          todo-comments.enable = true;
          obsidian.enable = true;
        };

        visuals = {
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          fidget-nvim.enable = true;
          highlight-undo.enable = true;
          indent-blankline.enable = true;
        };

        statusline.lualine.enable = true;

        theme = {
          enable = true;
          transparent = true;
          # base16-colors = config.stylix.base16Scheme;
          # name = lib.mkDefault "catppuccin";
          # style = "mocha";
        };

        autopairs.nvim-autopairs.enable = true;

        autocomplete.nvim-cmp.enable = true;
        snippets.luasnip.enable = true;

        filetree.neo-tree.enable = true;

        tabline.nvimBufferline.enable = true;

        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        telescope.enable = true;

        git = {
          enable = true;
        };

        utility = {
          icon-picker.enable = true;
          diffview-nvim.enable = true;
          motion.leap.enable = true;
        };

        terminal.toggleterm.enable = true;

        ui = {
          noice.enable = true;
          colorizer.enable = true;
          illuminate.enable = true;
          breadcrumbs = {
            enable = true;
            navbuddy.enable = true;
          };
          fastaction.enable = true;
        };

        comments.comment-nvim.enable = true;
        presence.neocord.enable = true;
      };
    };
    home.file.".editorconfig".source = (pkgs.formats.ini { }).generate ".editorconfig" {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        indent_size = 2;
        indent_style = "space";
        insert_final_newline = true;
        max_line_width = 80;
        trim_trailing_whitespace = true;
      };
    };
  };
}

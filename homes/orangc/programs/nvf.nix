{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;

  cfg = config.hmModules.programs.nvf;
in {
  imports = [inputs.nvf.homeManagerModules.default];
  options.hmModules.programs.nvf.enable = mkEnableOption "Enable neovim with nvf";

  config = mkIf cfg.enable {
    programs.nvf = {
      enable = true;
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
        luaConfigRC = {
          basic = ''
            -- Restore terminal cursor to vertical beam on exit
            vim.api.nvim_create_autocmd("ExitPre", {
              group = vim.api.nvim_create_augroup("Exit", { clear = true }),
              command = "set guicursor=a:ver1",
              desc = "Set cursor back to beam when leaving Neovim.",
            })

            -- Remove "disable mouse" entries from the context menu
            vim.api.nvim_create_autocmd("VimEnter", {
              callback = function()
                vim.cmd("aunmenu PopUp.How-to\\ disable\\ mouse")
                vim.cmd("aunmenu PopUp.-1-")
              end,
              desc = "Remove 'disable mouse' entries from context menu",
            })
          '';
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
            enable = config.hmModules.dev.nix.enable;
            lsp = {
              enable = true;
              package = pkgs.nil;
            };
          };
          markdown.enable = true;
          bash.enable = true;
          css.enable = true;
          html.enable = true;
          rust = {
            enable = config.hmModules.dev.rust.enable;
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
          name = lib.mkDefault "catppuccin";
          style = "mocha";
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
          gitsigns.enable = true;
          gitsigns.codeActions.enable = false; # throws an annoying debug message
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
        presence.neocord.enable = false;
      };
    };
    home.file.".editorconfig".source = (pkgs.formats.ini {}).generate ".editorconfig" {
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

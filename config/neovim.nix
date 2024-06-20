{
  pkgs,
  config,
  lib,
  ...
}:
let
  palette = config.stylix.base16Scheme;
in
with lib;
{
  programs.neovim = {
    enable = true;
    coc.enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
        wl-clipboard
      ];
    plugins = with pkgs.vimPlugins; [
        alpha-nvim
        auto-session
        bufferline-nvim
        dressing-nvim
        indent-blankline-nvim
        nui-nvim
        finecmdline
        nvim-treesitter.withAllGrammars
        lualine-nvim
        nvim-autopairs
        nvim-web-devicons
        nvim-cmp
        nvim-surround
        nvim-lspconfig
        cmp-nvim-lsp
        cmp-buffer
        luasnip
        cmp_luasnip
        friendly-snippets
        lspkind-nvim
        comment-nvim
        nvim-ts-context-commentstring
        plenary-nvim
        neodev-nvim
        luasnip
        telescope-nvim
        todo-comments-nvim
        nvim-tree-lua
        telescope-fzf-native-nvim
        vim-tmux-navigator
        presence-nvim
      ];

  }
}

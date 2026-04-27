{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withRuby = false;
    withPython3 = false;

    initLua = ''
      ${builtins.readFile ./nvim/options.lua}
    '';
    
    extraPackages = with pkgs; [
      lua-language-server
      nixd
    ];

    plugins = with pkgs.vimPlugins; [

      {
        type = "lua";
        plugin = telescope-nvim;
        config = "${builtins.readFile ./nvim/plugin/telescope.lua}";
      }

      telescope-fzf-native-nvim

      {
        type = "lua";
        plugin = nvim-lspconfig;
        config = "${builtins.readFile ./nvim/plugin/lsp.lua}";
      }

      {
        type = "lua";
        plugin = comment-nvim;
        config = "require(\"Comment\").setup()";
      }

      {
        type = "viml";
        plugin = gruvbox-nvim;
        config = "colorscheme gruvbox";
      }

      neodev-nvim

      #code completion
      {
        type = "lua";
        plugin = nvim-cmp;
        config = "${builtins.readFile ./nvim/plugin/cmp.lua}";
      }

      plenary-nvim

      cmp_luasnip
      cmp-nvim-lsp

      luasnip
      friendly-snippets


      #botom line replacing vim default
      {
        type = "lua";
        plugin = lualine-nvim;
        config = "require(\"lualine\").setup()";
      }
      nvim-web-devicons

      #treesitter
      nvim-treesitter.withAllGrammars #da ist jetzt ohne die config...
      /* {
        plugin = nvim-treesitter.withAllGrammars;
        config = toLuaFile ./nvim/plugin/treesitter.lua;
      } */

      vim-nix

    ];

  };
}

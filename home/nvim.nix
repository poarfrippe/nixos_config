{ config, lib, pkgs, ... }:

{
  programs.neovim =
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in
  {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    initLua = ''
      ${builtins.readFile ./nvim/options.lua}
    '';
    
    extraPackages = with pkgs; [
      lua-language-server
      nixd
      rust-analyzer

      xclip
    ];

    plugins = with pkgs.vimPlugins; [

      {
        plugin = telescope-nvim;
        config = toLuaFile ./nvim/plugin/telescope.lua;
      }

      telescope-fzf-native-nvim

      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./nvim/plugin/lsp.lua;
      }

      {
        plugin = comment-nvim;
        config = toLua "require(\"Comment\").setup()";
      }

      {
        plugin = gruvbox-nvim;
        config = "colorscheme gruvbox";
      }

      neodev-nvim

      #code completion
      {
        plugin = nvim-cmp;
        config = toLuaFile ./nvim/plugin/cmp.lua;
      }

      plenary-nvim

      cmp_luasnip
      cmp-nvim-lsp

      luasnip
      friendly-snippets


      #botom line replacing vim default
      {
        plugin = lualine-nvim;
        config = toLua "require(\"lualine\").setup()";
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

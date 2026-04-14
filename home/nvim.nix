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
#      rnix-lsp
#aha ahnscheinend da nil_ls oder nixd. schaust du in lspconfig-all
      rust-analyzer

      xclip
    ];

    plugins = with pkgs.vimPlugins; [

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
      nvim-cmp 
      {
        plugin = nvim-cmp;
        config = toLuaFile ./nvim/plugin/cmp.lua;
      }

      {
        plugin = telescope-nvim;
        config = toLuaFile ./nvim/plugin/telescope.lua;
      }

      telescope-fzf-native-nvim
      plenary-nvim

      cmp_luasnip
      cmp-nvim-lsp

      luasnip
      friendly-snippets


      #botom line replacing vim default
      lualine-nvim
      nvim-web-devicons

      #treesitter

      vim-nix

    ];

  };
}

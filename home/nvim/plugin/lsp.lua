local on_attach = function(_, bufnr)

  local bufmap = function(keys, func)
    vim.keymap.set('n', keys, func, { buffer = bufnr })
  end

  bufmap('<leader>r', vim.lsp.buf.rename)
  bufmap('<leader>a', vim.lsp.buf.code_action)

  bufmap('gd', vim.lsp.buf.definition)
  bufmap('gD', vim.lsp.buf.declaration)
  bufmap('gI', vim.lsp.buf.implementation)
  bufmap('<leader>D', vim.lsp.buf.type_definition)

  bufmap('gr', require('telescope.builtin').lsp_references)
  bufmap('<leader>s', require('telescope.builtin').lsp_document_symbols)
  bufmap('<leader>S', require('telescope.builtin').lsp_dynamic_workspace_symbols)

  bufmap('K', vim.lsp.buf.hover)

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, {})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require('neodev').setup()
vim.lsp.config('lua_ls', {

  on_attach = on_attach,
  cmd = { 'lua-language-server' },
  -- Filetypes to automatically attach to.
  filetypes = { 'lua' },
  -- Sets the "workspace" to the directory where any of these files is found.
  -- Files that share a root directory will reuse the LSP server connection.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },

  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library',
          -- '${3rd}/busted/library',
        },
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = vim.api.nvim_get_runtime_file('', true),
      },
    })
  end,
  settings = {
    Lua = {
      codeLens = {
        enable = true
      },
      hint = {
        enable = true,
        semicolon = "Disable"
      }
    },
  },
})

vim.lsp.enable('lua_ls')


-- nachschauen in :h lspconfig-all
vim.lsp.config('nixd', {
  cmd = { 'nixd' },
  filetypes = { 'nix' },
  on_attach = on_attach,
  capabilities = capabilities,
  root_markers = {"flake.nix", ".git" },
})
vim.lsp.enable('nixd')

--rust_analyzer
vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },
  on_attach = on_attach,
  filetypes = { 'rust' },
  settings = {
    ['rust-analyzer'] = {
      lens = {
        debug = {
          enable = true
        },
        enable = true,
        implementations = {
          enable = true
        },
        references = {
          adt = {
            enable = true
          },
          enumVariant = {
            enable = true
          },
          method = {
            enable = true
          },
          trait = {
            enable = true
          }
        },
        run = {
          enable = true
        },
        updateTest = {
          enable = true
        }
      }
    }
  },
  experimental = {
    commands = {
      commands = { "rust-analyzer.showReferences", "rust-analyzer.runSingle", "rust-analyzer.debugSingle" }
    },
    serverStatusNotification = true
  }
})
vim.lsp.enable('rust_analyzer')


require('telescope').setup({
	extensions = {
    	fzf = {
      	fuzzy = true,                    -- false will only do exact matching
      	override_generic_sorter = true,  -- override the generic sorter
      	override_file_sorter = true,     -- override the file sorter
      	case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    	}
  	}
})

require('telescope').load_extension('fzf')

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>ff', builtin.find_files , { desc = '[f]uzzy [f]ind' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc = '[f]uzzy live [g]rep'})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {desc = '[f]uzzy [b]uffers'})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {desc = '[f]uzzy [h]elp tags'})
vim.keymap.set('n', '<leader>fs', builtin.git_status, {desc = '[f]uzzy git [s]tatus'})

return {
	{
		"numToStr/Comment.nvim",
		opts = { ---LHS of operator-pending mappings in NORMAL and VISUAL mode
			toggler = {
				-- -Line-comment toggle keymap
				-- line = '<leader>v',
				line = "<A-c>",
				---Block-comment toggle keymap
				-- block = '<A-S-c>',
			},
			opleader = {
				---Line-comment keymap
				-- line = '<leader>v',
				line = "<A-c>",
				---Block-comment keymap
				block = "gb",
			},
		},
	},
}

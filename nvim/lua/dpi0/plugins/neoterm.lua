return {
	{
		"dpi0/neoterm.nvim",
		-- dir = "/data/dev/lua/neoterm.nvim/",
		-- event = "BufAdd",
		config = function()
			require("neoterm").setup({
				clear_on_run = true, -- run clear command before user specified commands
				noinsert = false, -- disable entering insert mode when opening the neoterm window
				-- position = "top",
				-- position = "bottom",
				-- position = "right",
				-- position = "left",
				-- position = "center",
				-- position = "fullscreen",
				mode = "vertical",
				width = 0.7,
				height = 0.1,
			})

			vim.api.nvim_set_keymap(
				"n",
				"<leader>tv",
				':lua require("neoterm").open({ mode = "vertical" })<CR>',
				{ noremap = true, silent = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>th",
				':lua require("neoterm").open({ mode = "horizontal" })<CR>',
				{ noremap = true, silent = true }
			)

			vim.keymap.set("n", "<A-i>", ":NeotermOpen<CR>", { silent = true })
			vim.keymap.set("t", "<A-i>", "<C-\\><C-n>:NeotermToggle<CR>", { silent = true })
			vim.keymap.set("t", "<A-S-i>", "<C-\\><C-n>:NeotermExit<CR>", { silent = true })
			vim.keymap.set("i", "<A-i>", "<Esc>:NeotermToggle<CR>", { silent = true })
			vim.keymap.set("n", "<leader>lz", ":NeotermRun lz<CR>", { silent = true })

			vim.keymap.set("n", "<A-y>", ":lua require('neoterm').open({position ='right'})<CR>", { silent = true })
			vim.keymap.set("t", "<A-y>", "<C-\\><C-n>:NeotermToggle<CR>", { silent = true })

			vim.keymap.set(
				"n",
				"<A-S-y>",
				":lua require('neoterm').open({mode ='fullscreen', width})<CR>",
				{ silent = true }
			)
			vim.keymap.set("t", "<A-S-y>", "<C-\\><C-n>:NeotermToggle<CR>", { silent = true })
		end,
	},
}

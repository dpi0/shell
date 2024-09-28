return {
	{
		"itmecho/neoterm.nvim",
		-- dir = "~/dev/neoterm.nvim",
		config = function()
			require("neoterm").setup({
				clear_on_run = true, -- run clear command before user specified commands
				noinsert = false, -- disable entering insert mode when opening the neoterm window
				-- position = "fullscreen",
				-- position = "bottom",
				-- position = "center",
				-- position = "top",
				-- position = "left",
				position = "right",
				-- mode = "vertical",
				width = 0.7,
				height = 0.8,
			})

			vim.keymap.set("n", "<A-i>", ":NeotermOpen<CR>", { silent = true })
			vim.keymap.set("t", "<A-i>", "<C-\\><C-n>:NeotermToggle<CR>", { silent = true })
			vim.keymap.set("i", "<A-i>", "<Esc>:NeotermToggle<CR>", { silent = true })

			-- a second terminal
			vim.keymap.set(
				"n",
				"<A-o>",
				":lua require('neoterm').open({position = 'bottom', height = 0.4})<CR>",
				{ silent = true }
			)
			vim.keymap.set("t", "<A-o>", "<C-\\><C-n>:NeotermToggle<CR>", { silent = true })
			vim.keymap.set("i", "<A-o>", "<Esc>:NeotermToggle<CR>", { silent = true })
		end,
	},
}

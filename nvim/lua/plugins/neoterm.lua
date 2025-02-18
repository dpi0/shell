return {
	{
		"itmecho/neoterm.nvim",
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
				width = 0.8,
				height = 0.8,
			})

		-- Helper function for mappings
		local function bind(mode, lhs, rhs, opts)
			opts = opts or { noremap = true, silent = true }
			vim.keymap.set(mode, lhs, rhs, opts)
		end

		-- Main terminal (Neoterm)
		bind("n", "<A-i>", ":NeotermOpen<CR>")              -- Open terminal (normal mode)
		bind("t", "<A-i>", "<C-\\><C-n>:NeotermToggle<CR>") -- Toggle terminal (terminal mode)
		bind("i", "<A-i>", "<Esc>:NeotermToggle<CR>")       -- Toggle terminal (insert mode)

		-- Second terminal (Neoterm with custom position/height)
		-- bind("n", "<A-o>", function()
		-- 	require('neoterm').open({ position = 'bottom', height = 0.4 })
		-- end)                                               -- Open second terminal (normal mode)
		-- bind("t", "<A-o>", "<C-\\><C-n>:NeotermToggle<CR>") -- Toggle second terminal (terminal mode)
		-- bind("i", "<A-o>", "<Esc>:NeotermToggle<CR>")       -- Toggle second terminal (insert mode)

		end,
	},
}
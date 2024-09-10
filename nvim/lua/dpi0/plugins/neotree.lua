return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
			vim.opt.termguicolors = true

			require("neo-tree").setup({
				close_if_last_window = true,
				enable_git_status = true,
				window = {
					position = "right",
					width = 30,
				},
				buffers = {
					follow_current_file = {
						enabled = true, -- This will find and focus the file in the active buffer every time
					},
				},
				filesystem = {
					follow_current_file = {
						enabled = true,
					},
					filtered_items = {
						visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
						hide_dotfiles = false,
						hide_gitignored = true,
					},
				},
			})

			vim.keymap.set("n", "<A-e>", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
		end,
	},
}

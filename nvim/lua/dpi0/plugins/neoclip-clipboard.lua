return {
	{
		"AckslD/nvim-neoclip.lua",
		event = "VeryLazy",
		dependencies = {
			{ "nvim-telescope/telescope.nvim" },
		},
		keys = { { "<leader>sn", ":Telescope neoclip<cr>", desc = "Find registers (neoclip)" } },
		config = function()
			require("neoclip").setup()
		end,
	},
}

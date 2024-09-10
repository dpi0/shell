return {
	{
		-- "folke/tokyonight.nvim",
		"Mofiqul/vscode.nvim",
		-- 	"rebelot/kanagawa.nvim",
		-- "loctvl842/monokai-pro.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins

		-- config starts as soon as the plugin is loaded
		config = function()
			-- local bg = "#060609"

			-- require("tokyonight").setup({
			-- 	style = "night",
			-- 	on_colors = function(colors)
			-- 		colors.bg = bg
			-- 	end,
			-- })
			require("vscode").setup({
				-- style = "dark",
				-- transparent = "true",
				underline_links = true,
				color_overrides = {
					vsBack = "#1A1A1A",
				},
			})
		end,

		-- config = function()
		-- 	require("monokai-pro").setup({
		-- 		filter = "classic", -- classic | octagon | pro | machine | ristretto | spectrum
		-- 		overridePalette = function(filter)
		-- 			return {
		-- 				background = "#111111",
		-- 			}
		-- 		end,
		-- 	})
		-- end,

		init = function()
			-- vim.cmd.colorscheme("monokai-pro")
			-- vim.cmd.colorscheme("tokyonight")
			vim.cmd.colorscheme("vscode")
		end,
	},
}

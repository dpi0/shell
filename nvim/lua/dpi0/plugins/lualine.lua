return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "meuter/lualine-so-fancy.nvim" },
	config = function()
		local lualine = require("lualine")
		-- local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		local colors = {
			blue = "#00aefe",
			green = "#00fe61",
			violet = "#d02df9",
			yellow = "#fed800",
			orange = "#ff6a00",
			red = "#FF4A4A",
			fg = "#cbcbcb",
			bg = "#121e29",
			inactive_bg = "#2c3043",
		}

		local my_theme = {
			normal = {
				a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			insert = {
				a = { bg = colors.green, fg = colors.bg, gui = "bold" },
			},
			visual = {
				a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
			},
			command = {
				a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
			},
			replace = {
				a = { bg = colors.red, fg = colors.bg, gui = "bold" },
			},
			terminal = {
				a = { bg = colors.orange, fg = colors.bg, gui = "bold" },
			},
			inactive = {
				a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
				b = { bg = colors.inactive_bg, fg = colors.semilightgray },
				c = { bg = colors.inactive_bg, fg = colors.semilightgray },
			},
		}

		lualine.setup({
			options = {
				theme = "vscode",
				component_separators = { left = "│", right = "│" },
				section_separators = { left = "", right = "" },
				globalstatus = true,
				refresh = {
					statusline = 100,
				},
			},
			sections = {
				lualine_a = {
					{ "fancy_mode", width = 10 },
				},
				lualine_b = {
					-- { "fancy_branch" },
				},
				lualine_c = {
					-- { "fancy_cwd", substitute_home = true },
					{ "branch" },
					-- { "fancy_diff" },
					{
						"diff",
						colored = true,
						-- diff_color = {
						-- 	-- Same color values as the general color option can be used here.
						-- 	added = "#11fe00", -- Changes the diff's added color
						-- 	modified = "#fee000", -- Changes the diff's modified color
						-- 	removed = "#fe0000", -- Changes the diff's removed color you
						-- },
					},
					{ "filename", path = 2 },
				},
				lualine_x = {
					-- { "buffers", mode = 1 },
					-- { "fancy_macro" },
					{ "fancy_diagnostics" },
					-- { "fancy_searchcount" },
					{ "fancy_location" },
				},
				lualine_y = {
					-- { "fancy_filetype", ts_icon = "" },
				},
				lualine_z = {
					{ "fancy_lsp_servers" },
				},
			},
		})
	end,
}

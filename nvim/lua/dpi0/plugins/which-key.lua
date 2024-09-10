return {
	"folke/which-key.nvim",

	-- this makes it load very late as this is not that imp
	event = "VeryLazy",

	-- again init STARTS when nvim starts!
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500 -- how long each key will wait before activation 700ms
	end,

	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
}

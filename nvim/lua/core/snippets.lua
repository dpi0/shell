-- ===============================
-- Neovim Core Snippets
-- ===============================

-- Highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- ===========================
-- Diagnostics Configuration
-- ===========================
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		format = function(diagnostic)
			local code = diagnostic.code and string.format("[%s]", diagnostic.code) or ""
			return string.format("%s %s", code, diagnostic.message)
		end,
	},
	underline = false,
	update_in_insert = true,
	float = { source = "always" },
})

-- Make diagnostic background transparent
vim.cmd("highlight DiagnosticVirtualText guibg=NONE")

-- ===========================
-- Prevent LSP from overwriting Treesitter colors
-- ===========================
vim.highlight.priorities.semantic_tokens = 95 -- Lower than Treesitter's priority (100)

-- ===========================
-- Luasnip Configuration
-- ===========================
-- local ls = require("luasnip")
-- local s = ls.snippet
-- local t = ls.text_node
-- local i = ls.insert_node

-- -- Helper function to add multiple snippets for a file type
-- local function add_snippets(filetype, snippets)
--   ls.add_snippets(filetype, snippets)
-- end

-- -- Lua snippets
-- add_snippets("lua", {
--   s("h", t("hello world")),
--   s("var", { t("local "), i(1, "name"), t(" = "), i(2, "'some text'") }),
-- })

-- -- Markdown snippets
-- add_snippets("markdown", {
--   s("ccl", { t({ "```bash", "" }), i(1, ""), t({ "", "```" }) }),
--   s("img", { t("![image]("), i(1, "link"), t(")") }),
-- })

local bind = vim.keymap.set

-- BOLD AND ITALIC
bind("i", "<C-b>", "****<Left><Left>")
bind("i", "<C-y>", "**<Left>")

local function surround_word(prefix, suffix)
	-- Save the current cursor position
	local pos = vim.api.nvim_win_get_cursor(0)
	-- Get the word under the cursor
	local word = vim.fn.expand("<cword>")
	-- Replace the word with the formatted word
	vim.cmd("normal! ciw" .. prefix .. word .. suffix)
	-- Restore the cursor position
	vim.api.nvim_win_set_cursor(0, pos)
end

-- CHANGE WORD UNDER CURSOR
bind("n", "<leader>mb", function()
	surround_word("**", "**")
end, { noremap = true, silent = true, desc = "Bold" })

-- mapping for highlighting
bind("n", "<leader>mh", function()
	surround_word("{==", "==}")
end, { noremap = true, silent = true })

-- mapping for underline highlighting
bind("n", "<leader>mu", function()
	surround_word("{++", "++}")
end, { noremap = true, silent = true })

-- mapping for delete highlighting
bind("n", "<leader>md", function()
	surround_word("{--", "--}")
end, { noremap = true, silent = true })

-- mapping for comments
bind("n", "<leader>mc", function()
	surround_word("{>>", "<<}")
end, { noremap = true, silent = true })

-- Mapping for italics
bind("n", "<leader>mi", function()
	surround_word("*", "*")
end, { noremap = true, silent = true })

-- Mapping for surrounding with ()
bind("n", "<leader>(", function()
	surround_word("(", ")")
end, { noremap = true, silent = true })

-- Mapping for surrounding with []
bind("n", "<leader>[", function()
	surround_word("[", "]")
end, { noremap = true, silent = true })

-- Mapping for surrounding with {}
bind("n", "<leader>{", function()
	surround_word("{", "}")
end, { noremap = true, silent = true })

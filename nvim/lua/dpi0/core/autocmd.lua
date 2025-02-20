-- Highlight when yanking (copying) text
-- Define the custom highlight group with the desired color
vim.api.nvim_set_hl(0, "YankHighlight", { fg = "#000000", bg = "#00FFF7", bold = true })

-- Create the autocmd for TextYankPost
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 200 })
	end,
})

-- AUTO SAVE WHEN EXIT INSERT MODE
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	callback = function()
		if vim.fn.expand("%") ~= "" then
			vim.cmd("silent! write")
		end
	end,
})

-- AUTO ADD DASH AND NUMBERED LISTS IN MARKDOWN FILES
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.keymap.set("i", "<CR>", function()
			-- Get the current line content
			local line = vim.api.nvim_get_current_line()
			-- Check if the line starts with a dash followed by a space
			if string.match(line, "^%s*%- ") then
				return "\r- "
				-- Check if the line starts with a number followed by a period and a space
			elseif string.match(line, "^%s*%d+%. ") then
				local num = tonumber(string.match(line, "^%s*(%d+)"))
				return string.format("\r%d. ", num + 1)
			else
				return "\r"
			end
		end, { buffer = true, expr = true })
	end,
})

-- AUTO CLOSE ALL TERMINAL BUFFERS ON :qa
-- Create an augroup for managing terminal buffer closure
vim.api.nvim_create_augroup("TermClose", { clear = true })

-- Set an autocmd for the QuitPre event to close all terminal buffers
vim.api.nvim_create_autocmd("QuitPre", {
	group = "TermClose",
	callback = function()
		-- Get the list of all buffers
		local bufs = vim.api.nvim_list_bufs()
		-- Iterate through each buffer
		for _, buf in ipairs(bufs) do
			-- Check if the buffer is a terminal buffer using vim.bo[buf]
			if vim.bo[buf].buftype == "terminal" then
				-- Forcefully delete the terminal buffer
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end
	end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

-- CLOSE UNUSED BUFFERS
local id = vim.api.nvim_create_augroup("startup", {
	clear = false,
})

local persistbuffer = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	vim.fn.setbufvar(bufnr, "bufpersist", 1)
end

vim.api.nvim_create_autocmd({ "BufRead" }, {
	group = id,
	pattern = { "*" },
	callback = function()
		vim.api.nvim_create_autocmd({ "InsertEnter", "BufModifiedSet" }, {
			buffer = 0,
			once = true,
			callback = function()
				persistbuffer()
			end,
		})
	end,
})

vim.keymap.set("n", "<Leader>cub", function()
	local curbufnr = vim.api.nvim_get_current_buf()
	local buflist = vim.api.nvim_list_bufs()
	for _, bufnr in ipairs(buflist) do
		if vim.bo[bufnr].buflisted and bufnr ~= curbufnr and (vim.fn.getbufvar(bufnr, "bufpersist") ~= 1) then
			vim.cmd("bd " .. tostring(bufnr))
		end
	end
end, { silent = true, desc = "Close unused buffers" })

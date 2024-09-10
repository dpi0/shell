-- WRITE FILENAME
-- Define the save_as function
local function save_as()
	-- Get the current directory
	local current_dir = vim.fn.getcwd()
	-- Prompt the user to enter the filename with the absolute path, defaulting to the current directory
	local filename = vim.fn.input("Save as: ", current_dir .. "/", "file")
	-- Save the current buffer with the specified filename
	if filename ~= "" then
		vim.cmd("write " .. filename)
		-- Optionally set the buffer name to the new filename
		vim.api.nvim_buf_set_name(2, filename)
	else
		print("Save aborted: no filename provided.")
	end
end

-- Set the keymap to call the save_as function
vim.keymap.set({ "n", "i" }, "<C-e>", save_as, { noremap = true, silent = true })

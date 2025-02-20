-- set leader key to space
vim.g.mapleader = " "

local bind = vim.keymap.set -- for conciseness

-- enter visual block mode
bind("n", "<leader>vb", "<C-v>", { noremap = true, silent = true })
bind("n", "<leader>bd", ":bd<CR>", { silent = true, desc = "Delete current buffer" })
bind("n", "<leader>rf", ":e<CR>", { silent = true, desc = "Refresh current buffer" })
bind("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "chmod +x" })
bind("x", "<leader>p", [["_dP]], { desc = "Paste without copying to register" })
bind("n", "<leader>ll", "<cmd>Lazy<CR>", { desc = "Lazy Plugin Manager" })
bind("n", "<leader>rr", "<cmd>source %<CR>", { desc = "Reload neovim config" })

-- QUIT NEOVIM ALL BUFFERS
-- bind("n", "<E>", ":qa<CR>", { silent = true })

-- bind("n", "<C-w>", ":q<CR>", {silent = true, noremap = true})

-- swich to last used buffer/file and toggle
bind("n", "<A-a>", "<C-^>", { noremap = true, silent = true })
bind("i", "<A-a>", "<C-^>", { noremap = true, silent = true })

-- keep lines in the center of the screen
bind("n", "<C-d>", "<C-d>zz")
bind("n", "<C-u>", "<C-u>zz")
bind("n", "n", "nzzzv")
bind("n", "N", "Nzzzv")
bind("n", "<S-S-j>", "gj")
bind("n", "<S-k>", "gk")

-- indenting a visual block using Tab
bind("v", "<Tab>", ">gv", { noremap = true, silent = true })
bind("v", "<S-Tab>", "<gv", { noremap = true, silent = true })

-- delete line
bind("n", "<S-d>", "dd")

bind(
	"n",
	"<leader>cw",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace the all instances of the current word under the cursor" }
)

-- alt+backspace to delete backwards
bind("i", "<A-BS>", "<C-w>", { noremap = true, silent = true })
bind("n", "<A-BS>", "db", { noremap = true, silent = true })

-- use Esc to clear search highlights
bind("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- window management
bind("n", "<leader>wl", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
bind("n", "<leader>wj", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
bind("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
bind("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- move b/w windows
bind("n", "<C-h>", "<C-w><C-h>")
bind("n", "<C-l>", "<C-w><C-l>")
bind("n", "<C-j>", "<C-w><C-S-j>")
bind("n", "<C-k>", "<C-w><C-k>")

-- save current file
bind("n", "<C-s>", ":w<CR>", { silent = true })
bind("i", "<C-s>", "<Esc>:w<CR>", { silent = true })
bind("n", "<leader>s", ":w<CR>", { desc = "Save the current file", silent = true })

-- close all windows and quit nvim
bind("n", "<leader>qa", ":qa<CR>", { silent = true })
bind("n", "<C-q>", ":qa<CR>", { silent = true })

-- quit current file
bind("n", "<leader>q", ":q<CR>", { silent = true })
bind("n", "<A-q>", ":q<CR>", { silent = true })

-- select all text
bind("n", "<C-a>", "ggVG")
bind("n", "<leader>i", "ggVG=", { desc = "Indent all the text" })

-- move lines up/down
bind("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })
bind("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })
bind("x", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
bind("x", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- MULTICURSORS VIm
vim.g.VM_maps = {
	["Find Under"] = "<C-m>",
	["Find Subword Under"] = "<C-m>", -- Replace visual C-n
	["Select All"] = "<C-b>",
	["Add Cursor Down"] = "<A-S-j>",
	["Add Cursor Up"] = "<A-S-k>",
	-- ["Add Cursor At Pos"] = "<C-S-LeftMouse>",
	-- ['Visual Add'] = 'gb', -- Visual Mode
	-- ["Start Regex Search"] = "g/", -- Visual Mode
}

-- Bind leader ds to set tabstop, shiftwidth, expandtab, and retab
bind(
	"n",
	"<leader>ds",
	":set tabstop=2 shiftwidth=2 expandtab<CR>:retab<CR>",
	{ noremap = true, silent = true, desc = "Set tabstop, shiftwidth, expandtab, and retab" }
)

-- Bind leader dt to change the indent style to tabs of size 4 and retab
bind("n", "<leader>dt", function()
	vim.cmd("set tabstop=4 shiftwidth=4 noexpandtab")
	vim.cmd("retab!")
end, { noremap = true, silent = true, desc = "Change indent style to tabs of size 4 and retab" })

-- duplicate current line below
local function duplicate_line_below()
	local line = vim.api.nvim_get_current_line()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local lnum = cursor[1]
	vim.api.nvim_buf_set_lines(0, lnum, lnum, false, { line })
end

bind("n", "<A-d>", duplicate_line_below, { noremap = true, silent = true })
bind("v", "<A-d>", [[:t'>+2<CR>gv=gv]], { noremap = true, silent = true })

-- surround visually selected text with a given prefix and suffix
function _G.surround_visual(prefix, suffix)
	-- Get the start and end positions of the visual selection
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	-- Ensure start_pos is before end_pos
	if start_pos[2] > end_pos[2] or (start_pos[2] == end_pos[2] and start_pos[3] > end_pos[3]) then
		start_pos, end_pos = end_pos, start_pos
	end

	-- Get the text in the visual selection
	local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)

	-- If only one line is selected, surround the selected text
	if #lines == 1 then
		lines[1] = lines[1]:sub(1, start_pos[3] - 1)
			.. prefix
			.. lines[1]:sub(start_pos[3], end_pos[3])
			.. suffix
			.. lines[1]:sub(end_pos[3] + 1)
	else
		-- If multiple lines are selected, surround each line with prefix and suffix
		lines[1] = lines[1]:sub(1, start_pos[3] - 1) .. prefix .. lines[1]:sub(start_pos[3])
		lines[#lines] = lines[#lines] .. suffix .. lines[#lines]:sub(end_pos[3] + 1)
		for i = 2, #lines - 1 do
			lines[i] = prefix .. lines[i] .. suffix
		end
	end

	-- Set the modified lines back
	vim.api.nvim_buf_set_lines(0, start_pos[2] - 1, end_pos[2], false, lines)

	-- Reselect the visual area to restore the selection
	vim.cmd("normal! gv")
end

bind(
	"v",
	"<leader>sq",
	[[:lua surround_visual('"', '"')<CR>]],
	{ noremap = true, silent = true, desc = "Surround with double quotes" }
)
bind(
	"v",
	"<leader>s(",
	[[:lua surround_visual('(', ')')<CR>]],
	{ noremap = true, silent = true, desc = "Surround with ()" }
)
bind(
	"v",
	"<leader>sb",
	[[:lua surround_visual('**', '**')<CR>]],
	{ noremap = true, silent = true, desc = "Surround with **" }
)
-- bind('v', '<C-[>', [[:lua surround_visual('[', ']')<CR>]], { noremap = true, silent = true })
-- bind('v', '<C-S-[>', [[:lua surround_visual('{', '}')<CR>]], { noremap = true, silent = true })

local opt = vim.opt

-- PERFORMANCE
opt.lazyredraw = false -- Don’t update screen during macro and script execution
opt.updatetime = 50 -- decrease update time

-- UI
opt.mouse = "a" -- enable mouse mode useful for resize/splits
opt.showmode = false -- Don't show the mode, since it's already in the status line
opt.clipboard = "unnamedplus" -- sync clipboard b/w OS and neovim
opt.cursorline = true -- show which line your cursor is on
opt.termguicolors = true -- so that colors show up properly
opt.signcolumn = "yes" -- show the sign column on the left

-- SPELL
opt.spell = true
opt.spelllang = "en_us"

-- TEXT RENDERING
vim.g.have_nerd_font = true
opt.list = true
opt.listchars = { tab = "| ", trail = "·", nbsp = "␣" } -- »
opt.colorcolumn = "80" -- adds a color column after 80 chars
opt.number = true -- show the current absolute line number
opt.relativenumber = true
opt.scrolloff = 22 -- Minimal number of screen lines to keep above and below the cursor.
opt.syntax = "enable"
opt.wrap = true -- line wrapping
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- SPLIT
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- MISC
opt.swapfile = false -- creates a swapfile
opt.undofile = true -- enable persistent undo
opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
-- opt.spell = false

-- INDENT currently using 1 tab = 4 spaces
opt.expandtab = true -- Convert tabs to spaces
-- opt.tabstop = 4 -- Insert 4 spaces for a tab
-- opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
-- opt.softtabstop = 4 -- Number of spaces a <Tab> counts for while performing editing operations
-- opt.smarttab = true -- Insert `tabstop` number of spaces when hitting <Tab> in front of a line
opt.autoindent = true -- Copy indent from current line when starting a new line
opt.smartindent = true -- Do smart autoindenting when starting a new line

-- SEARCH
opt.ignorecase = true -- ignore case when searching
opt.hlsearch = true -- highlight on search
opt.incsearch = true -- incremental search that shows partial matches.
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

--- NEOVIDE
vim.o.guifont = "SF Mono:h13"
vim.g.neovide_cursor_animation_length = 0.05
vim.g.neovide_cursor_trail_size = 0.1
vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_refresh_rate = 120
vim.g.neovide_no_idle = true
vim.g.neovide_fullscreen = false
vim.g.neovide_remember_window_size = false
vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0
-- vim.g.neovide_transparency = 0.5
if vim.g.neovide then
	vim.keymap.set("n", "<C-s>", ":w<CR>") -- Save
	vim.keymap.set("v", "<C-c>", '"+y') -- Copy
	vim.keymap.set("n", "<C-v>", '"+P') -- Paste normal mode
	vim.keymap.set("v", "<C-v>", '"+P') -- Paste visual mode
	vim.keymap.set("i", "<C-v>", '<ESC>l"+Pli') -- Paste insert mode
	vim.keymap.set("c", "<C-v>", "<C-R>+") -- Paste command mode
end

-- VIMTEX
-- This is necessary for VimTeX to load properly. The "indent" is optional.
-- Note that most plugin managers will do this automatically.
-- vim.cmd("filetype plugin indent on")

-- This enables Vim's and neovim's syntax-related features. Without this, some
-- VimTeX features will not work (see ":help vimtex-requirements" for more
-- info).
-- vim.cmd("syntax enable")

-- Viewer options: One may configure the viewer either by specifying a built-in
-- viewer method:
-- vim.g.vimtex_view_method = "zathura"

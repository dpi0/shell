-- ===============================
-- Neovim Core Options
-- ===============================

local opt = vim.opt -- Shorter alias

-- UI Settings
opt.number = true -- Enable line numbers
opt.relativenumber = true -- Use relative line numbers
opt.signcolumn = "yes" -- Always show signcolumn
opt.numberwidth = 4 -- Set number column width
opt.cursorline = true -- Highlight current line
opt.wrap = false -- Disable line wrapping
opt.linebreak = true -- Prevent word splitting when wrapped
opt.colorcolumn = "80" -- Highlight column at 80 chars
opt.showmode = false -- Hide mode info (redundant with statusline)
opt.cmdheight = 1 -- Space in command line for messages
opt.syntax = "enable" -- Enable syntax highlighting
opt.termguicolors = true -- Enable 24-bit colors
opt.list = true -- Show whitespace characters
opt.listchars = { tab = "| ", trail = "·", nbsp = "␣" } -- Customize whitespace display

-- Clipboard & Input
opt.clipboard = "unnamedplus" -- Sync system clipboard
opt.mouse = "a" -- Enable mouse support
opt.whichwrap = "bs<>[]hl" -- Allow moving across lines with arrow keys

-- Indentation & Tabs
opt.autoindent = true -- Copy indentation from current line
opt.smartindent = true -- Smarter indentation
opt.expandtab = true -- Convert tabs to spaces
opt.shiftwidth = 4 -- Spaces per indentation level
opt.tabstop = 4 -- Tab width
opt.softtabstop = 4 -- Spaces a tab represents in editing

-- Splits & Window Behavior
opt.splitbelow = true -- Horizontal splits appear below
opt.splitright = true -- Vertical splits appear to the right
opt.scrolloff = 4 -- Keep 4 lines visible when scrolling
opt.sidescrolloff = 8 -- Keep 8 columns visible when scrolling

-- Performance & Behavior
opt.lazyredraw = false -- Don't redraw during macros/scripts
opt.updatetime = 50 -- Faster update time (default: 4000ms)
opt.timeoutlen = 300 -- Faster key sequence timeout (default: 1000ms)

-- Backup & Undo
opt.swapfile = false -- Disable swapfile
opt.backup = false -- Disable backup files
opt.writebackup = false -- Prevent editing files that are open elsewhere
opt.undofile = true -- Enable persistent undo

-- Command & File Handling
opt.fileencoding = "utf-8" -- Set file encoding
opt.conceallevel = 0 -- Show markdown code blocks
opt.showtabline = 0 -- Show tab line
opt.pumheight = 10 -- Popup menu height
opt.runtimepath:remove("/usr/share/vim/vimfiles") -- Separate Vim & Neovim plugins

-- Search
opt.ignorecase = true -- Case-insensitive search
opt.smartcase = true -- Case-sensitive if mixed-case search
opt.incsearch = true -- Show incremental matches
opt.hlsearch = true -- Highlight search results

-- Spell Checking
opt.spell = true -- Enable spell checking
opt.spelllang = "en_us" -- Set spell check language

-- Miscellaneous
vim.g.have_nerd_font = true -- Enable NERD font compatibility
opt.backspace = "indent,eol,start" -- Allow backspacing over everything
opt.shortmess:append("c") -- Suppress completion menu messages
opt.iskeyword:append("-") -- Treat words with `-` as single words
opt.formatoptions:remove({ "c", "r", "o" }) -- Disable auto-comment insertion
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions" -- Recommended session options - https://github.com/rmagatti/auto-session?tab=readme-ov-file#recommended-sessionoptions-config

-- ===========================
-- NEOVIDE Configuration
-- ===========================
-- if vim.g.neovide then
--     -- Font & UI Settings
--     vim.o.guifont = "SF Mono:h13"
--     vim.g.neovide_cursor_animation_length = 0.05
--     vim.g.neovide_cursor_trail_size = 0.1
--     vim.g.neovide_scroll_animation_length = 0.1
--     vim.g.neovide_refresh_rate = 120
--     vim.g.neovide_no_idle = true
--     vim.g.neovide_fullscreen = false
--     vim.g.neovide_remember_window_size = false
--     vim.g.neovide_padding_top = 0
--     vim.g.neovide_padding_bottom = 0
--     vim.g.neovide_padding_right = 0
--     vim.g.neovide_padding_left = 0
--     -- vim.g.neovide_transparency = 0.5  -- Uncomment to enable transparency

--     -- Keybindings
--     local map = vim.keymap.set
--     map("n", "<C-s>", ":w<CR>")  -- Save
--     map("v", "<C-c>", '"+y')     -- Copy
--     map("n", "<C-v>", '"+P')     -- Paste (normal mode)
--     map("v", "<C-v>", '"+P')     -- Paste (visual mode)
--     map("i", "<C-v>", '<ESC>l"+Pli') -- Paste (insert mode)
--     map("c", "<C-v>", "<C-R>+")  -- Paste (command mode)
-- end

-- ===========================
-- VIMTEX Configuration
-- ===========================

-- Ensure VimTeX loads correctly
-- vim.cmd("filetype plugin indent on")
-- vim.cmd("syntax enable")

-- -- Set PDF viewer
-- vim.g.vimtex_view_method = "zathura"

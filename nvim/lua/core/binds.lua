-- ===========================
-- Neovim Core Keymaps
-- ===========================

-- Set leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Disable spacebar's default behavior
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Shorter keymap options
local opts = { noremap = true, silent = true }

-- Helper function for keybindings with description
local function bind(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
end

-- Helper function for command execution
local function cmd(command)
  return "<cmd>" .. command .. "<CR>"
end

-- Duplicate current line below
local function duplicate_line_below()
  local line = vim.api.nvim_get_current_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lnum = cursor[1]
  vim.api.nvim_buf_set_lines(0, lnum, lnum, false, { line })
end

-- Toggle Oil.nvim
vim.api.nvim_create_user_command("OilToggle", function()
  vim.cmd((vim.bo.filetype == "oil") and "bd" or "Oil")
end, { nargs = 0 })

-- ===========================
-- MULTICURSOR MAPPINGS
-- ===========================
vim.g.VM_maps = {
  ["Find Under"] = "<C-m>",
  ["Find Subword Under"] = "<C-m>",
  ["Select All"] = "<C-b>",
  ["Add Cursor Down"] = "<A-S-j>",
  ["Add Cursor Up"] = "<A-S-k>",
}

-- ===========================
-- ESSENTIAL MAPPINGS
-- ===========================
bind("n", "<C-s>", cmd("w"), "Save file")
bind("i", "<C-s>", "<Esc>:w<CR>", "Save file")
bind("n", "<leader>sn", cmd("noautocmd w"), "Save without auto-formatting")
bind("n", "<C-A-s>", cmd("noautocmd w"), "Save without auto-formatting")
bind("n", "<leader>vb", "<C-v>", "Visual Block Mode")
bind("n", "<leader>bd", ":bd<CR>", "Delete current buffer")
bind("n", "<leader>rf", ":e<CR>", "Refresh current buffer")
bind("n", "<leader>x", "<cmd>!chmod +x %<CR>", "Make file executable (chmod +x)")
bind("x", "<leader>p", [["_dP]], "Paste without copying to register")
bind("n", "<leader>ll", "<cmd>Lazy<CR>", "Open Lazy Plugin Manager")
bind("n", "<leader>rr", "<cmd>source %<CR>", "Reload Neovim config")

bind("n", "<C-q>", cmd("qa"), "Quit all")
bind("n", "<A-q>", cmd("q"), "Quit current file")

bind("n", "<C-a>", "ggVG", "Select all text")

-- Move lines up/down
bind("n", "<A-j>", ":m .+1<CR>==", "Move line down")
bind("n", "<A-k>", ":m .-2<CR>==", "Move line up")
bind("x", "<A-j>", ":m '>+1<CR>gv=gv", "Move selection down")
bind("x", "<A-k>", ":m '<-2<CR>gv=gv", "Move selection up")

-- Buffer switching
bind("n", "<A-a>", "<C-^>", "Switch to last buffer")
bind("i", "<A-a>", "<C-^>", "Switch to last buffer")

-- Scroll and center
bind("n", "<C-d>", "<C-d>zz", "Scroll down and center")
bind("n", "<C-u>", "<C-u>zz", "Scroll up and center")
bind("n", "n", "nzzzv", "Next search result centered")
bind("n", "N", "Nzzzv", "Previous search result centered")

-- Indenting in visual mode
bind("v", "<Tab>", ">gv", "Indent right")
bind("v", "<S-Tab>", "<gv", "Indent left")

-- Delete line
bind("n", "<S-d>", "dd", "Delete line")

-- Replace all occurrences of word under cursor
bind("n", "<leader>cw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Replace word globally")

-- Backspace behavior
bind("i", "<A-BS>", "<C-w>", "Delete word backwards")
bind("n", "<A-BS>", "db", "Delete word backwards")

-- Clear search highlights
bind("n", "<Esc>", cmd("nohlsearch"), "Clear search highlights")

-- ===========================
-- WINDOW MANAGEMENT
-- ===========================
bind("n", "<leader>wl", "<C-w>v", "Split vertically")
bind("n", "<leader>wj", "<C-w>s", "Split horizontally")
bind("n", "<leader>we", "<C-w>=", "Equalize splits")
bind("n", "<leader>wx", cmd("close"), "Close split")

-- Window navigation
bind("n", "<C-h>", "<C-w>h", "Move left")
bind("n", "<C-l>", "<C-w>l", "Move right")
bind("n", "<C-j>", "<C-w>j", "Move down")
bind("n", "<C-k>", "<C-w>k", "Move up")

-- ===========================
-- TAB MANAGEMENT
-- ===========================
bind("n", "<leader>tn", ":tabnew<CR>") -- Open new tab
bind("n", "<leader>tw", ":tabclose<CR>") -- Close current tab
bind("n", "<leader>tl", ":tabnext<CR>") -- Go to next tab
bind("n", "<leader>th", ":tabprevious<CR>") -- Go to previous tab

bind("n", "<A-o>", ":OilToggle<CR>") -- Go to previous tab

-- Toggle line wrapping
bind("n", "<leader>lw", cmd("set wrap!"), "Toggle line wrapping")

-- Paste without overwriting register
bind("v", "p", '"_dP', "Paste without overwriting register")

-- ===========================
-- DIAGNOSTICS
-- ===========================
bind("n", "[d", cmd("lua vim.diagnostic.goto_prev()"), "Previous diagnostic")
bind("n", "]d", cmd("lua vim.diagnostic.goto_next()"), "Next diagnostic")
bind("n", "<leader>d", cmd("lua vim.diagnostic.open_float()"), "Show diagnostics")
bind("n", "<leader>q", cmd("lua vim.diagnostic.setloclist()"), "Show diagnostic list")

-- ===========================
-- INDENTATION STYLES
-- ===========================
bind("n", "<leader>ia", "ggVG=", "Indent entire file")
bind("n", "<leader>i2", cmd("set tabstop=2 shiftwidth=2 expandtab | retab"), "Set 2-space indent")
bind("n", "<leader>i4", function()
  vim.cmd("set tabstop=4 shiftwidth=4 noexpandtab")
  vim.cmd("retab!")
end, "Set 4-space indent with tabs")
-- Stay in indent mode
bind("v", "<", "<gv", "Indent left and reselect")
bind("v", ">", ">gv", "Indent right and reselect")

-- ===========================
-- CUSTOM FUNCTIONS
-- ===========================
vim.keymap.set("n", "<A-d>", duplicate_line_below, { desc = "Duplicate line below" })
bind("v", "<A-d>", [[:t'>+2<CR>gv=gv]], "Duplicate selection below")

-- checks if taplo is executable and sets it as the formatter for TOML files
if vim.fn.executable("taplo") == 1 then
  vim.bo.formatprg = "taplo fmt -"
end

-- vim.api.nvim_set_keymap("n", "A-C-f", "ggVGgq", { noremap = true, silent = true })

bind("n", "<A-t>", ":Todo<CR>", "Todo")

bind("n", "<leader>dfo", ":DiffviewOpen<CR>", "Diff Open")
bind("n", "<leader>dfc", ":DiffviewClose<CR>", "Diff Close")

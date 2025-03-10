require("core.options")
require("core.binds")
require("core.snippets")
require("core.autocmd")

-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

local hostname = vim.loop.os_gethostname()

-- Define the base plugins
local plugins = {
  -- require("plugins.alpha"), -- Startup dashboard for Neovim.
  require("plugins.autopairs"), -- Auto-closes brackets and quotes.
  require("plugins.auto-session"), -- Automatically restore sessions.
  require("plugins.colorizer"), -- Highlights color codes in files.
  require("plugins.colortheme"), -- Sets the color scheme for the editor.
  require("plugins.comment"), -- Simplifies code commenting.
  require("plugins.cursorline"), -- Highlights the current cursor line.
  require("plugins.gitsigns"), -- Shows Git changes in the gutter.
  require("plugins.indent"), -- Displays indentation guides.
  require("plugins.lualine"), -- Statusline enhancement.
  require("plugins.multicursors"), -- Enables multiple cursors for editing.
  require("plugins.neoterm"), -- Manages terminal buffers.
  require("plugins.oil"), -- File explorer integration.
  require("plugins.todo-comments"), -- Highlights codes, comments etc
  require("plugins.which-key"), -- Displays available keybindings.
  require("plugins.todo"), -- Todo.
  require("plugins.yazi"), -- Yazi.
  -- require("plugins.lazygit"), -- Lazygit.
  require("plugins.diff"), -- Better diff (than gitsigns).
  require("plugins.surround"), -- Surround.
  require("plugins.flash-jump"), -- Jump quickly to text.
  -- require("plugins.fold"), -- Modern code folding.
  require("plugins.snacks"), -- QoL
}

-- Conditionally add if hostname is "arch"
if hostname == "arch" then
  table.insert(plugins, require("plugins.harpoon")) -- Quickly switch b/w multiple files.
  table.insert(plugins, require("plugins.telescope")) -- Fuzzy finder and picker.
  table.insert(plugins, require("plugins.lsp")) -- Language Server Protocol.
  table.insert(plugins, require("plugins.treesitter")) -- Better syntax highlighting and code understanding.
  table.insert(plugins, require("plugins.autocompletion")) -- Autocompletion support.
  table.insert(plugins, require("plugins.none-ls-formatter")) -- Code formatting.
  table.insert(plugins, require("plugins.screenshot")) -- Screenshot code snippet.
  table.insert(plugins, require("plugins.markdown")) -- Markdown render.
end

-- Load all plugins at once
require("lazy").setup(plugins)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

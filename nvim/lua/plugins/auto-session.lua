return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
    { "<leader>sf", "<cmd>SessionSearch<CR>", desc = "Session search" },
    { "<leader>ss", "<cmd>SessionSave<CR>", desc = "Save session" },
    { "<leader>sas", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
    { "<leader>sr", "<cmd>SessionRestore<CR>", desc = "Session Restore" },
  },
  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    -- log_level = 'debug',
  },
}

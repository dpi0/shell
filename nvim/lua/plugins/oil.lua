-- return {
--     'stevearc/oil.nvim',
--     ---@module 'oil'
--     ---@type oil.SetupOpts
--     opts = {
--         delete_to_trash = true,
--     },
--     -- Optional dependencies
--     dependencies = { { "echasnovski/mini.icons", opts = {} } },
--     -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
--     -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
--     lazy = false,
-- }

return {
  "stevearc/oil.nvim",
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        natural_order = true,
        is_always_hidden = function(name, _)
          return name == ".." or name == ".git"
        end,
      },
      float = {
        padding = 2,
        max_width = 90,
        max_height = 0,
      },
      win_options = {
        wrap = true,
        winblend = 0,
      },
      keymaps = {
        ["<C-c>"] = false,
        ["q"] = "actions.close",
      },
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "OilActionsPost",
      callback = function(event)
        if event.data.actions.type == "move" then
          Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
        end
      end,
    })
  end,
}

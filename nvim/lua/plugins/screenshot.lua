return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  main = "nvim-silicon",
  config = function()
    local home = os.getenv("HOME") or vim.env.HOME
    require("nvim-silicon").setup({
      disable_defaults = false,
      -- turn on debug messages
      debug = false,
      -- rest of the config goes here...
      font = "JetBrainsMono Nerd Font",
      -- theme = "Monokai Extended",
      --  get the list of themes using `silicon --list-themes`
      theme = "gruvbox-dark",
      pad_horiz = 10,
      pad_vert = 10,
      background = "#54546D",
      -- may bug out on WSL2
      to_clipboard = true,
      window_title = function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
      end,
      output = function()
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
        return home
          .. "/Screenshots/"
          .. filename
          .. " ("
          .. os.date("%H-%M-%S")
          .. ") ("
          .. os.date("%d-%b")
          .. ").png"
      end,
    })
    -- vim.keymap.set("v", "<leader>z", function()
    --   require("nvim-silicon").file()
    -- end, { desc = "Save code screenshot as file" })
    -- vim.keymap.set("v", "<leader>sc", function()
    --   require("nvim-silicon").clip()
    -- end, { desc = "Copy code screenshot to clipboard" })
    -- vim.keymap.set("v", "<leader>ss", function()
    --   require("nvim-silicon").shoot()
    -- end, { desc = "Create code screenshot" })
  end,
}

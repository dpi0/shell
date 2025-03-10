return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  config = function(_, opts)
    -- require("ufo").setup({
    --   provider_selector = function(bufnr, filetype, buftype)
    --     return { "treesitter", "indent" }
    --   end,
    -- })
    vim.opt.foldlevelstart = 99
    require("ufo").setup(opts)
  end,
}

return {
  "ackeraa/todo.nvim",
  config = function()
    local home = os.getenv("HOME")
    require("todo").setup({
      opts = {
        file_path = home .. "/todo.txt",
      },
    })
  end,
}

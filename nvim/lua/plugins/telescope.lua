return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",

  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope-ui-select.nvim",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        -- path_display = { "smart" },
        mappings = {
          i = {
            ["<A-k>"] = actions.move_selection_previous, -- move to prev result
            ["<A-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<esc>"] = actions.close,
          },
        },
      },
      pickers = {
        live_grep = {
          file_ignore_patterns = {
            "node_modules",
            ".venv",
            ".git/objects",
            ".cargo",
            ".cache",
            ".local",
            ".rustup",
            ".mozilla",
            ".continue",
            "vscode",
          },
          additional_args = function(_)
            return { "--hidden" }
          end,
        },
        find_files = {
          file_ignore_patterns = {
            "node_modules",
            ".git/objects",
            ".venv",
            ".cargo",
            ".cache",
            ".local",
            ".rustup",
            ".mozilla",
            ".continue",
            "vscode",
          },
          hidden = true,
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    -- Enable Telescope extensions if they are installed
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")

    local bind = vim.keymap -- for conciseness
    local builtin = require("telescope.builtin")
    local previewers = require("telescope.previewers")
    -- local themes = require("telescope.themes")
    local action_state = require("telescope.actions.state")

    local delta = previewers.new_termopen_previewer({
      get_command = function(entry)
        if entry.status == "??" or "A " then
          return { "git", "diff", entry.value }
        end

        return { "git", "diff", entry.value .. "^!" }
      end,
    })

    vim.keymap.set("n", "<Leader>gs", function()
      builtin.git_status({ previewer = delta, layout_strategy = "vertical" })
    end, { desc = "Telescope git status" })

    -- bind.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    bind.set("n", "<A-f>", builtin.find_files, { desc = "Fuzzy find files in cwd" })

    -- bind.set(
    -- 	"n",
    -- 	"<A-f>",
    -- 	':lua require"telescope.builtin".find_files({ hidden = true })<CR>',
    -- 	{ noremap = true, silent = true }
    -- )

    bind.set("n", "<leader>f.", builtin.oldfiles, { desc = "Fuzzy find recent files" })
    -- bind.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    bind.set("n", "<A-g>", builtin.live_grep, { desc = "Find string in cwd" })
    bind.set("n", "<leader>fc", builtin.grep_string, { desc = "Find string under cursor in cwd" })
    bind.set("n", "<A-S-f>", builtin.grep_string, { desc = "Find string under cursor in cwd" })
    bind.set("n", "<leader><leader>", builtin.buffers, { desc = "Find existing buffers" })
    -- bind.set("n", "<A-s>", builtin.buffers, { desc = "Find existing buffers" })

    vim.keymap.set("n", "<space>fb", ":Telescope file_browser<CR>")

    -- open file_browser with the path of the current buffer
    vim.keymap.set("n", "<space>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")

    vim.keymap.set("n", "<C-w>", function()
      local delete_buf = function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end

      delete_buf()
    end)
    bind.set(
      "n",
      "<leader>cg",
      '<cmd>lua require("telescope.builtin").live_grep({grep_open_files=true})<CR>',
      { desc = "Grep all current buffers" }
    )
    bind.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

    vim.keymap.set("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "Fuzzily search in current buffer" })

    -- Searching your Neovim configuration files
    vim.keymap.set("n", "<leader>fn", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "Find Neovim files" })

    -- Search in /data/
    vim.keymap.set("n", "<leader>fd", function()
      builtin.find_files({ cwd = "/data/" })
    end, { desc = "Find files in /data/" })

    -- Search in /
    vim.keymap.set("n", "<leader>fr", function()
      builtin.find_files({ cwd = "/" })
    end, { desc = "Find files in /" })

    -- Search in /home/dpi0
    vim.keymap.set("n", "<leader>fh", function()
      builtin.find_files({ cwd = "/home/dpi0/" })
    end, { desc = "Find files in /home/dpi0/" })
  end,
}

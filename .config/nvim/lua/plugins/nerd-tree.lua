return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- Optional, für Datei-Icons
  },
  config = function()
    require("nvim-tree").setup({
      sort_by = "case_sensitive",
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    })
  end,
  -- Optional: Keys für nvim-tree
  keys = {
    { "<leader>n", ":NvimTreeToggle<CR>", desc = "Toggle NvimTree", noremap = true, silent = true },
  },
}

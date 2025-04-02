-- Dateimanager Konfiguration
--## 2025-04-02
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
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- Standard-Mappings
        vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))

        -- Öffne in Tab mit t
        vim.keymap.set('n', 't', api.node.open.tab, opts('Open in New Tab'))
      end,
    })
  end,
  -- Optional: Keys für nvim-tree
  keys = {
    { "<leader>n", ":NvimTreeToggle<CR>", desc = "Toggle NvimTree", noremap = true, silent = true },
  },
}

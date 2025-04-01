return {
  -- lualine: schnelle, leichtgewichtige und hoch konfigurierbare Statusleiste
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "pywal", -- Passt zu deinem Pywal-Theme
        -- nf pl divider
        -- component_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
        --  nf ple circle
        -- component_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        ignore_focus = {},
        disabled_filetypes = {},
        always_divide_middle = true,
        always_show_tabline = true,
        transparent = true, -- Hier wird die Transparenz aktiviert
        globalstatus = true, -- Eine globale Statuszeile für alle Fenster
      refresh = {
        statusline = 100,
        tabline = 100,
        winbar = 100,
        }
      },
      sections = {
        lualine_a = {{ "mode", separator = { left = "", right = "" }, right_padding = 2 }},
        lualine_b = {{ "branch", icon = "" }, "diff", "diagnostics" },
        lualine_c = {{ "filename", path = 1 }}, -- 1 = relative Pfade
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = {{ "location", separator = { left = "", right = "" }, left_padding = 2 }}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      extensions = { "nvim-tree" } -- Integration mit nvim-tree
    })
  end,
}

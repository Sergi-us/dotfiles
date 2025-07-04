return {
  -- lualine: schnelle, leichtgewichtige und hoch konfigurierbare Statusleiste
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
        options = {
            icons_enabled = true,
            theme = function()
            local current_theme = vim.g.colors_name
            if current_theme == "pywal" then
            return "pywal"  -- Oder "pywal-nvim" falls das existiert
            else
            return "auto"
            end
        end,
        -- nf pl divider
        -- component_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
        --  nf ple circle
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        -- component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        ignore_focus = {},
        disabled_filetypes = {},
        always_divide_middle = true,
        always_show_tabline = false,
        transparent = true, -- Hier wird die Transparenz aktiviert
        globalstatus = true, -- Eine globale Statuszeile für alle Fenster
      refresh = {
        statusline = 100,
        tabline = 100,
        winbar = 100,
        }
      },
      sections = {
        lualine_a = {{ "mode", separator = { left = "", right = "" }, right_padding = 2 }},
        lualine_b = {{ "branch", icon = "" }, { "diff", icon = "" }, "diagnostics" },
        lualine_c = {{ "filename", path = 1 }}, -- 1 = relative Pfade
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = {{ "location", separator = { left = "", right = "" }, left_padding = 2 }}
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
		vim.cmd([[
  autocmd ColorScheme * lua require('lualine').setup()
]])
  end,
}

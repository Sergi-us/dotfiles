-- toggleterm
-- ## 2025-07-13 SARBS
return {
    'akinsho/toggleterm.nvim',
    config = function()
        require("toggleterm").setup{
            size = 10,
            open_mapping = nil,  -- Keine automatischen Mappings
            direction = 'horizontal',
            shade_terminals = false,  -- Wichtig für deine ZSH-Themes
            -- Performance-Optimierungen
            persist_size = false,
            persist_mode = false,
            -- Shell direkt starten ohne extra Checks
            shell = vim.o.shell,
            -- Weniger Features = schneller
            auto_scroll = false,
            start_in_insert = true,
        }
    end
}

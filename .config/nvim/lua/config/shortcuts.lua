-- Shortcut Integration
-- Diese kann in eine separate Datei wie shortcuts.lua kommen
vim.cmd([[
if filereadable(expand('~/.config/nvim/shortcuts.vim'))
    source ~/.config/nvim/shortcuts.vim
endif
]])

-- Oder als Lua Alternative (benötigt Anpassung):
-- local shortcut_file = vim.fn.expand('~/.config/nvim/shortcuts.lua')
-- if vim.fn.filereadable(shortcut_file) == 1 then
--     dofile(shortcut_file)
-- end

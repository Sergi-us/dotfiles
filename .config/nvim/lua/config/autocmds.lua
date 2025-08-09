-- lua/config/autocmds.lua
-- ## 2025-04-01 SARBS
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Gruppe für Highlighting-Prioritäten (NEU)
local highlight_group = augroup("HighlightPriority", { clear = true })

-- Cursor zur letzten Position in der Datei setzen
autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Trim Whitespace beim Speichern
autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Erkennt Dateiänderungen außerhalb von Neovim automatisch
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if not vim.api.nvim_buf_get_option(0, "modified") then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight bei Yank (NEU)
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
})

-- dwmblocks nach änderungen aktualisieren
vim.cmd([[
  autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }
]])

-- ST auto-compile
vim.cmd([[
  autocmd BufWritePost ~/.local/src/st/config.h !cd ~/.local/src/st/; sudo make install
]])

-- DWM auto-compile (mit Neustart)
vim.cmd([[
  autocmd BufWritePost ~/.local/src/dwm/config.h !cd ~/.local/src/dwm/; sudo make install
]])

-- DMENU auto-compile
vim.cmd([[
  autocmd BufWritePost ~/.local/src/dmenu/config.h !cd ~/.local/src/dmenu/; sudo make install
]])

-- aktualisiert shortcust nach dem ändern von bm-files und bm-dirs
vim.cmd([[
  autocmd BufWritePost bm-files,bm-dirs !shortcuts
]])

-- aktualisiert auflößung nach
vim.cmd([[
  autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
]])

-- DPI Synchronisation zwischen xprofile und GTK3 settings.ini
-- Berechnet automatisch gtk-xft-dpi = xrandr_dpi * 1024
vim.api.nvim_create_autocmd("BufWritePost", {
    -- Nur die aktiven Config-Dateien, nicht die in Dotfiles
    pattern = {
        vim.fn.expand("~/.xprofile"),
        vim.fn.expand("~/.config/x11/xprofile"),
    },
    callback = function()
        -- Extrahiere DPI-Wert aus xrandr --dpi XXX Zeile
        local dpi = tonumber(vim.fn.system("grep 'xrandr --dpi' " .. vim.fn.expand("%:p") .. " | grep -o '[0-9]*'"))

        -- Nur weitermachen wenn gültiger DPI-Wert gefunden
        if dpi and dpi > 0 then
            -- Update GTK3 settings.ini mit berechnetem Wert (DPI * 1024) + Kommentar
            vim.fn.system(string.format(
                "sed -i 's/^gtk-xft-dpi=.*/gtk-xft-dpi=%d  # Auto-generiert: %d * 1024 (xprofile DPI)/' ~/.config/gtk-3.0/settings.ini",
                dpi * 1024, dpi
            ))
            vim.notify("DPI synced: " .. dpi .. " → GTK3: " .. (dpi * 1024))
        end
    end
})

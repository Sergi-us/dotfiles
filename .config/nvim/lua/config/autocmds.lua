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

autocmd("BufWritePre", {
  pattern = { "*" },
  callback = function()
    -- Skip für Markdown-Dateien
    local filename = vim.fn.expand("%")
    if filename:match("%.md$") or filename:match("%.markdown$") then
      return
    end

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

-- DPI Synchronisation zwischen xprofile, GTK3 und Rofi
-- Liest MASTER_DPI Variable statt direkt xrandr --dpi
-- Liest xrandr --dpi Wert und synchronisiert ihn
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = {
        vim.fn.expand("~/.xprofile"),
        vim.fn.expand("~/.config/x11/xprofile"),
    },
    callback = function()
        local file_content = vim.fn.readfile(vim.fn.expand("%:p"))
        local master_dpi = nil
        local xrandr_dpi = nil

        for _, line in ipairs(file_content) do
            -- MASTER_DPI für GTK3 (nur wenn Zeile mit MASTER_DPI beginnt)
            if not master_dpi then
                master_dpi = tonumber(line:match("^MASTER_DPI=(%d+)"))
            end
            -- xrandr --dpi für Rofi (nur wenn Zeile "xrandr --dpi" enthält)
            if not xrandr_dpi and line:match("^xrandr%s+%-%-dpi%s+") then
                xrandr_dpi = tonumber(line:match("xrandr%s+%-%-dpi%s+(%d+)"))
            end
        end

        -- GTK3 Update mit MASTER_DPI (falls vorhanden)
        if master_dpi and master_dpi > 0 then
            vim.fn.system(string.format(
                "sed -i 's/^gtk-xft-dpi=.*/gtk-xft-dpi=%d  # Auto-generiert: %d * 1024 (MASTER_DPI)/' ~/.config/gtk-3.0/settings.ini",
                master_dpi * 1024, master_dpi
            ))
        end

        -- Rofi Update mit xrandr --dpi (falls vorhanden)
        if xrandr_dpi and xrandr_dpi > 0 then
            local rofi_config = vim.fn.expand("~/.config/rofi/config.rasi")
            if vim.fn.filereadable(rofi_config) == 1 then
                -- Erst alles bis zum Semikolon ersetzen, alte Kommentare entfernen
                vim.fn.system(string.format(
                    "sed -i 's/\\s*dpi:.*$/    dpi: %d;  \\/\\* Auto-sync von xrandr --dpi \\*\\//' %s",
                    xrandr_dpi, rofi_config
                ))
            end
        end

        -- Notify mit beiden Werten
        if master_dpi or xrandr_dpi then
            local msg = "DPI synced: "
            if master_dpi then msg = msg .. string.format("GTK3: %d ", master_dpi * 1024) end
            if xrandr_dpi then msg = msg .. string.format("Rofi: %d", xrandr_dpi) end
            vim.notify(msg)
        end
    end
})

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
-- TODO TESTVERSION
local dpi_sync_group = vim.api.nvim_create_augroup("DPISync", { clear = true })

-- Funktion zum Updaten der GTK3 settings.ini
local function update_gtk3_dpi(dpi_value)
    local gtk3_settings = vim.fn.expand("~/.config/gtk-3.0/settings.ini")

    -- Prüfe ob die Datei existiert
    if vim.fn.filereadable(gtk3_settings) == 0 then
        vim.notify("GTK3 settings.ini nicht gefunden!", vim.log.levels.WARN)
        return
    end

    -- Berechne den GTK3 DPI Wert (DPI * 1024)
    local gtk_dpi = dpi_value * 1024

    -- Lese die Datei
    local lines = vim.fn.readfile(gtk3_settings)
    local updated = false

    -- Suche und ersetze die gtk-xft-dpi Zeile
    for i, line in ipairs(lines) do
        if line:match("^gtk%-xft%-dpi=") then
            lines[i] = string.format("gtk-xft-dpi=%d  # Das ist %d * 1024 (GTK3's komische DPI-Berechnung)",
                                    gtk_dpi, dpi_value)
            updated = true
            break
        end
    end

    -- Falls die Zeile nicht existiert, füge sie nach [Settings] hinzu
    if not updated then
        for i, line in ipairs(lines) do
            if line:match("^%[Settings%]") then
                table.insert(lines, i + 1, string.format("gtk-xft-dpi=%d  # Das ist %d * 1024 (GTK3's komische DPI-Berechnung)",
                                                        gtk_dpi, dpi_value))
                updated = true
                break
            end
        end
    end

    -- Schreibe die Datei zurück
    if updated then
        vim.fn.writefile(lines, gtk3_settings)
        vim.notify(string.format("GTK3 DPI updated: %d (xrandr) → %d (gtk)", dpi_value, gtk_dpi), vim.log.levels.INFO)
    end
end

-- Autocommand für xprofile Änderungen
vim.api.nvim_create_autocmd({"BufWritePost"}, {
    group = dpi_sync_group,
    pattern = {"**/x11/xprofile", "**/.xprofile"},
    callback = function()
        local filename = vim.fn.expand("%:p")
        local lines = vim.fn.readfile(filename)

        -- Suche nach der xrandr --dpi Zeile
        for _, line in ipairs(lines) do
            -- Matche verschiedene Formate: "xrandr --dpi 192" oder "xrandr --dpi=192"
            local dpi = line:match("^%s*xrandr%s+%-%-dpi%s+(%d+)")
            if not dpi then
                dpi = line:match("^%s*xrandr%s+%-%-dpi=(%d+)")
            end

            if dpi then
                dpi = tonumber(dpi)
                if dpi and dpi > 0 and dpi < 1000 then  -- Sanity check
                    update_gtk3_dpi(dpi)

                    -- Optional: Zeige Info über die Änderung
                    vim.defer_fn(function()
                        vim.notify(string.format(
                            "DPI Sync: xprofile (%d) → GTK3 settings.ini (%d)",
                            dpi, dpi * 1024
                        ), vim.log.levels.INFO)
                    end, 100)
                end
                break
            end
        end
    end,
    desc = "Syncronisiere DPI von xprofile to GTK3 settings.ini"
})

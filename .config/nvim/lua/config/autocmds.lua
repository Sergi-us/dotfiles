-- lua/config/autocmds.lua
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ## 2025-04-01 SARBS

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

-- dwmblocks-async nach änderungen aktualisieren
vim.cmd([[
  autocmd BufWritePost ~/.local/src/dwmblocks-async/config.h !cd ~/.local/src/dwmblocks-async/; sudo make install && { killall -q dwmblocks; setsid dwmblocks & }
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

-- TABBED auto-compile
vim.cmd([[
  autocmd BufWritePost ~/.local/src/tabbed/config.h !cd ~/.local/src/tabbed/; sudo make install
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
-- DPI: MASTER_DPI aus xprofile lesen und auf GTK3 + Rofi anwenden
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = {
    vim.fn.expand("~/.xprofile"),
    vim.fn.expand("~/.config/x11/xprofile"),
    vim.fn.expand("~/.config/xprofile"),
  },
  callback = function()
    local p = vim.fn.expand("%:p")
    local lines = vim.fn.readfile(p)
    local master

    for _, L in ipairs(lines) do
      master = master or tonumber(L:match("^%s*MASTER_DPI%s*=%s*(%d+)%s*$"))
    end
    if not master or master <= 0 then
      vim.notify("MASTER_DPI nicht gefunden.", vim.log.levels.WARN)
      return
    end

    -- GTK3 settings.ini pfad
    local gtk_ini = vim.fn.expand("~/.config/gtk-3.0/settings.ini")
    -- falls Datei fehlt: leere anlegen
    if vim.fn.filereadable(gtk_ini) == 0 then
      vim.fn.mkdir(vim.fn.fnamemodify(gtk_ini, ":h"), "p")
      vim.fn.writefile({ "[Settings]" }, gtk_ini)
    end
    -- Zeilen laden
    local gtk = vim.fn.readfile(gtk_ini)
    local found = false
    for i, L in ipairs(gtk) do
      if L:match("^%s*gtk%-xft%-dpi%s*=") then
        gtk[i] = string.format("gtk-xft-dpi=%d", master * 1024)
        found = true
        break
      end
    end
    if not found then
      table.insert(gtk, "gtk-xft-dpi=" .. (master * 1024))
    end
    vim.fn.writefile(gtk, gtk_ini)

    -- Rofi config.rasi pfad
    local rofi = vim.fn.expand("~/.config/rofi/config.rasi")
    if vim.fn.filereadable(rofi) == 1 then
      local r = vim.fn.readfile(rofi)
      local rfound = false
      for i, L in ipairs(r) do
        if L:match("%s*dpi:%s*") then
          r[i] = string.format("    dpi: %d;", master)
          rfound = true
          break
        end
      end
      if not rfound then
        -- einfache Anfüge-Variante, greift global
        table.insert(r, "dpi: " .. master .. ";")
      end
      vim.fn.writefile(r, rofi)
    end

    vim.notify(("DPI synced: MASTER_DPI=%d  (GTK3=%d, Rofi=%d)"):format(master, master*1024, master))
  end,
})

-- calcurse Markdown
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "/tmp/calcurse*", vim.fn.expand("~/.calcurse/notes/*") },
  callback = function() vim.bo.filetype = "markdown" end,
})

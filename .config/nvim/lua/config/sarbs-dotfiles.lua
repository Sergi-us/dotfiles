-- lua/config/sarbs-dotfiles.lua
-- ## 2026-09-20 SARBS
--
-- Öffentlich/privat Overlay für SARBS-Dotfiles.
-- Öffentlich:  ~/.local/src/dotfiles
-- Privat:     ~/.local/src/dotfiles-privat (wird per dotfiles-sarbs -d überlagert)
--
-- Ablaufplan:
--   1. :ZuPrivDot  -> aktuelle Datei (Buffer-Stand) nach dotfiles-privat spiegeln
--   2. :ZuPrivDeploy -> dotfiles-sarbs Entwickler-Modus (-d -f) ausführen
--
-- === ZuPrivDot ===
-- Kopiert die gerade geöffnete Datei (mitsamt relativem Verzeichnis ab $HOME)
-- nach ~/.local/src/dotfiles-privat/<relpfad> und wechselt in die neue Datei.
-- Es wird immer der aktuelle Buffer-Stand übernommen (kein :w nötig).
-- Die Original-Datei auf der Platte bleibt unverändert (kein Speichern dort).
-- Existiert das Ziel bereits, fragt Neovim vor dem Überschreiben nach.
--
-- === ZuPrivDeploy ===
-- Führt den Entwickler-Modus von dotfiles-sarbs (öffentlich + privat nach $HOME)
-- aus. Reine manuelle Funktion, kein Auto-Deploy.

local M = {}

-- === Pfad-Basis ===
-- Nutzerunabhängig über $HOME aufgelöst (kein /home/<name> hart verdrahtet).
local function home_dir()
  return vim.fn.expand("~")
end

local function privat_basis()
  return home_dir() .. "/.local/src/dotfiles-privat"
end

local function oeffentlich_basis()
  return home_dir() .. "/.local/src/dotfiles"
end

local function beginnt_mit(pfad, praefix)
  return pfad == praefix or pfad:sub(1, #praefix + 1) == praefix .. "/"
end

-- === ZuPrivDot ===
-- Spiegelt die aktuelle Datei nach dotfiles-privat und wechselt dorthin.
function M.zu_privat()
  -- Nur normale Datei-Buffer (kein Terminal, kein [No Name], kein Verzeichnis)
  if vim.bo.buftype ~= "" then
    vim.notify("ZuPrivDot: Spezialbuffer (buftype=" .. vim.bo.buftype .. ") wird nicht kopiert.", vim.log.levels.ERROR)
    return
  end

  local quelle = vim.api.nvim_buf_get_name(0)
  if quelle == "" then
    vim.notify("ZuPrivDot: Buffer hat keine Datei ([No Name]). Erst speichern.", vim.log.levels.ERROR)
    return
  end
  if vim.fn.isdirectory(quelle) == 1 then
    vim.notify("ZuPrivDot: Verzeichnisse werden nicht kopiert.", vim.log.levels.ERROR)
    return
  end

  -- Symlinks bereinigen, damit der Relativpfad stimmt
  quelle = vim.fn.resolve(quelle)

  local home = home_dir()
  if not beginnt_mit(quelle, home) then
    vim.notify("ZuPrivDot: Datei liegt nicht unter $HOME, Abbruch.", vim.log.levels.ERROR)
    return
  end

  local privat = privat_basis()
  if beginnt_mit(quelle, privat) then
    vim.notify("ZuPrivDot: Datei ist bereits in dotfiles-privat.", vim.log.levels.WARN)
    return
  end

  -- Relativpfad ab $HOME (nutzerunabhängig)
  local rel = quelle:sub(#home + 2)
  local ziel = privat .. "/" .. rel

  -- Ziel existiert bereits -> Nutzerkonfiguration vorhanden -> nachfragen
  if vim.fn.filereadable(ziel) == 1 then
    local antwort = vim.fn.confirm(
      "Nutzerkonfiguration existiert bereits, überschreiben?\n" .. ziel,
      "&Ja\n&Nein",
      2
    )
    if antwort ~= 1 then
      vim.notify("ZuPrivDot: Abgebrochen, Ziel bleibt unverändert.", vim.log.levels.INFO)
      return
    end
  end

  -- Zielverzeichnis anlegen
  local zieldir = vim.fn.fnamemodify(ziel, ":h")
  if vim.fn.mkdir(zieldir, "p") == 0 and vim.fn.isdirectory(zieldir) == 0 then
    vim.notify("ZuPrivDot: Verzeichnis konnte nicht erstellt werden:\n" .. zieldir, vim.log.levels.ERROR)
    return
  end

  -- Buffer-Stand (inkl. ungespeicherter Änderungen) ins Ziel schreiben.
  -- Das Original auf der Platte wird dabei nie angefasst.
  local zeilen = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  if vim.fn.writefile(zeilen, ziel) ~= 0 then
    vim.notify("ZuPrivDot: Schreiben nach\n" .. ziel .. "\nfehlgeschlagen.", vim.log.levels.ERROR)
    return
  end

  -- Ausführ-Bit vom Original übernehmen (z.B. Skripte in ~/.local/bin)
  pcall(vim.fn.setfperm, ziel, vim.fn.getfperm(quelle))

  -- In die private Kopie wechseln. edit! verwirft den alten Buffer-Inhalt
  -- (liegt ja jetzt im Ziel); die Original-Datei auf der Platte bleibt
  -- dadurch unverändert und ungespeichert.
  vim.cmd("keepalt edit! " .. vim.fn.fnameescape(ziel))
  vim.notify("ZuPrivDot: " .. rel .. " -> dotfiles-privat", vim.log.levels.INFO)
end

-- === ZuPrivDeploy ===
-- Führt dotfiles-sarbs im Entwickler-Modus headless aus (öffentlich + privat).
-- Das Skript ermittelt die beiden Dotfiles-Verzeichnisse selbständig;
-- als Arbeitsverzeichnis wird best-effort das öffentliche Repo genutzt.
function M.deploy()
  if vim.fn.executable("dotfiles-sarbs") ~= 1 then
    vim.notify("ZuPrivDeploy: dotfiles-sarbs nicht im PATH.", vim.log.levels.ERROR)
    return
  end

  local cwd = nil
  if vim.fn.isdirectory(oeffentlich_basis()) == 1 then
    cwd = oeffentlich_basis()
  end

  local ausgabe = {}
  vim.fn.jobstart({ "dotfiles-sarbs", "-d", "-f" }, {
    cwd = cwd,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, daten)
      for _, zeile in ipairs(daten) do
        if zeile ~= "" then
          table.insert(ausgabe, zeile)
        end
      end
    end,
    on_stderr = function(_, daten)
      for _, zeile in ipairs(daten) do
        if zeile ~= "" then
          table.insert(ausgabe, zeile)
        end
      end
    end,
    on_exit = function(_, code)
      -- Nur die letzten Zeilen zeigen (rsync ist gesprächig)
      local schwanz = {}
      local start = math.max(1, #ausgabe - 9)
      for i = start, #ausgabe do
        table.insert(schwanz, ausgabe[i])
      end
      local text = table.concat(schwanz, "\n")
      if code == 0 then
        vim.notify("ZuPrivDeploy: OK\n" .. text, vim.log.levels.INFO)
      else
        vim.notify("ZuPrivDeploy: Fehler (Code " .. code .. ")\n" .. text, vim.log.levels.ERROR)
      end
    end,
  })
  vim.notify("ZuPrivDeploy: dotfiles-sarbs -d -f gestartet ...", vim.log.levels.INFO)
end

-- === Commands ===
-- Mit :Zu<Tab> aufrufbar, kein Keymap (Nutzer-Wunsch).
vim.api.nvim_create_user_command("ZuPrivDot", function()
  M.zu_privat()
end, { nargs = 0, desc = "Aktuelle Datei (Buffer-Stand) nach dotfiles-privat spiegeln und dorthin wechseln" })

vim.api.nvim_create_user_command("ZuPrivDeploy", function()
  M.deploy()
end, { nargs = 0, desc = "dotfiles-sarbs Entwickler-Modus (-d -f) ausführen" })

return M

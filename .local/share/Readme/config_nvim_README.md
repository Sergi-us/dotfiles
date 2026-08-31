# SARBS NeoVim Konfiguration 🚀

Eine minimalistische, aber durchdachte NeoVim-Konfiguration mit Fokus auf Schreiben, Theme-Management und Transparenz.

## 🎯 Konzept

Diese Konfiguration basiert auf dem Prinzip der **modularen Trennung**:
- Jede Funktionalität lebt in ihrem eigenen Modul
- Zentrale visuelle Kontrolle durch `sarbs.lua`
- Keine Konflikte zwischen Themes, Transparenz und Zen-Mode
- Einfache, aber mächtige Bedienung

## 📁 Struktur

```
~/.config/nvim/
├── init.lua					# Hauptkonfiguration & Lazy.nvim Bootstrap
├── lua/
│   ├── config/
│   │   ├── sarbs.lua			# 🎨 Zentrale visuelle Steuerung
│   │   ├── options.lua			# ⚙️  Editor-Einstellungen
│   │   └── keymaps.lua			# ⌨️  Tastenkombinationen
│   └── plugins/
│       ├── themes.lua			# 🎭 Theme-Manager
│       ├── zen-mode.lua		# 🧘 Ablenkungsfreies Schreiben
│       └── lualine.lua			# 📊 Statusleiste
```

## 🔑 Kernkonzepte

### 1. Zentrale Visuelle Steuerung (`sarbs.lua`)

Das Herzstück der Konfiguration. Verwaltet:
- **Transparenz-Toggle**: Terminal-Transparenz durchscheinen lassen
- **Theme-Integration**: Arbeitet nahtlos mit dem Theme-Manager
- **Zen-Mode Support**: Spezielle Einstellungen für fokussiertes Schreiben

```lua
-- Drei Hauptfunktionen:
M.apply_transparency()    -- Transparenz anwenden
M.set_theme(name)        -- Theme wechseln mit Transparenz-Support
M.toggle_transparency()  -- Transparenz ein/aus
```

### 2. Theme-Manager (`themes.lua`)

Vereinfachtes Theme-System ohne überladene Picker:
- **5 handverlesene Themes**: pywal, gruvbox, tokyonight, catppuccin, kanagawa
- **Persistenz**: Merkt sich das letzte Theme
- **Cycle-Funktion**: Schnell durch Themes wechseln

### 3. Zen-Mode Integration

Speziell für ablenkungsfreiess Schreiben:
- Blendet alle UI-Elemente aus
- Zentriert den Text
- Arbeitet mit der Transparenz-Einstellung

## ⌨️ Tastenkombinationen

| Taste        | Funktion           | Beschreibung                  |
|--------------|--------------------|-------------------------------|
| `<leader>tc` | Theme Cycle        | Wechselt zum nächsten Theme   |
| `<leader>ü`  | Toggle Transparenz | Transparenz ein/aus           |
| `<leader>z`  | Zen Mode           | Ablenkungsfreiei Schreibmodus |

## 🎨 Themes

### pywal
- Nutzt die Farben deines Terminals
- Perfekt für System-Integration
- Automatische Anpassung an Wallpaper

### gruvbox
- Warme, retro-inspirierte Farben
- Sehr gut für lange Coding-Sessions
- Hervorragende Lesbarkeit

### tokyonight
- Modernes, kühles Farbschema
- Beliebt in der Community
- Mehrere Varianten verfügbar

### catppuccin
- Pastellfarben, sanft für die Augen
- Sehr durchdachtes Farbsystem
- Große Community

### kanagawa
- Inspiriert von japanischen Gemälden
- Ausgewogene, beruhigende Farben
- Exzellenter Kontrast

## 🔧 Installation

1. **Backup deiner aktuellen Konfiguration**:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone diese Konfiguration**:
   ```bash
   git clone <dein-repo> ~/.config/nvim
   ```

3. **Starte NeoVim**:
   ```bash
   nvim
   ```
   Lazy.nvim installiert automatisch alle Plugins beim ersten Start.

## 💡 Tipps & Tricks

### Transparenz

Die Transparenz funktioniert nur, wenn dein Terminal (wie st) bereits transparent ist. Die Konfiguration setzt dann den NeoVim-Hintergrund auf "NONE", damit die Terminal-Transparenz durchscheint.

### Theme-Wechsel

- **Schnell wechseln**: `<leader>tc`
- **Gezielt setzen**: `:ThemeSet gruvbox`
- **Aktuelles Theme**: Wird in `~/.local/share/nvim/last_theme.txt` gespeichert

### Zen-Mode Workflow

1. Text öffnen
2. `<leader>z` für Zen-Mode
3. Optional: `<leader>ü` für Transparenz aus (bessere Lesbarkeit)
4. Schreiben!
5. `<leader>z` zum Beenden

## 🐛 Fehlerbehebung

### "Theme nicht gefunden"
- Stelle sicher, dass alle Plugins installiert sind
- Führe `:Lazy sync` aus

### Transparenz funktioniert nicht
- Prüfe ob dein Terminal transparent ist
- Teste manuell: `:lua require("config.sarbs").apply_transparency()`

### Lualine zeigt falsches Theme
- Das ist ein bekanntes Problem mit pywal
- Workaround: Theme neu laden mit `<leader>tc`

## 🚀 Erweiterungen

Diese Basis-Konfiguration kann einfach erweitert werden:

1. **Neue Plugins**: Einfach in `lua/plugins/` ablegen
2. **Neue Themes**: In `themes.lua` zur Liste hinzufügen
3. **Keymaps**: In `config/keymaps.lua` ergänzen

## 📺 Video-Tutorial

[Link zu deinem YouTube-Video]

## 🤝 Credits

- Erstellt mit ❤️ von SARBS
- Basiert auf Neovim + Lazy.nvim
- Inspiriert von der Community

---

**Happy Coding!** 🎉

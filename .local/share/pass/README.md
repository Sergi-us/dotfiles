# Zwei-Faktor-Authentifizierung mit `pass`, `pass-otp` und `rofi-pass`

## 📦 Voraussetzungen
- [`pass`](https://www.passwordstore.org/) ist eingerichtet und funktioniert.
- [`pass-otp`](https://github.com/tadfisher/pass-otp) ist installiert  
  → unter Arch Linux: `sudo pacman -S pass-otp`
- [`rofi-pass`](https://github.com/carnager/rofi-pass) ist installiert (AUR).

---

## 🔑 OTP / TOTP Grundlagen
- **OTP** = One Time Password (generischer Begriff)  
- **TOTP** = Time-based One Time Password (Standard, alle 30 Sekunden ein neuer Code)  
- Dienste (GitHub, Mastodon, Google, …) geben einen **32-stelligen Base32-Secret** oder einen QR-Code aus.  
- Daraus wird ein `otpauth://`-URI gebaut, den `pass-otp` versteht.

---

## ➕ Einen neuen TOTP-Eintrag anlegen

### Methode 1: Automatisch (wenn QR oder Secret akzeptiert wird)
```sh
pass otp insert service/account
```
→ Secret eingeben, `pass-otp` erstellt automatisch den URI.

### Methode 2: Manuell URI einfügen
```sh
pass edit service/account
```

Datei-Inhalt z. B.:
```text
MeinSuperPasswort
otpauth://totp/GitHub:meinuser?secret=JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP&issuer=GitHub&digits=6&period=30
```

### Aufbau einer `otpauth://` URI
```
otpauth://totp/<LABEL>?secret=<SECRET>&issuer=<ISSUER>&digits=6&period=30
```

- `<LABEL>`: Pflichtfeld, meist `Service:User`
- `secret`: dein 32-stelliger Key
- `issuer`: Name des Dienstes (für Übersicht)
- `digits`: Länge des Codes (Standard = 6)
- `period`: Lebensdauer in Sekunden (Standard = 30)

---

## 🔍 Codes abrufen
```sh
pass otp service/account
```

- gibt 6-stelligen Code zurück  
- erneuert sich alle 30 Sekunden

---

## 🎛 Nutzung mit `rofi-pass`
- `rofi-pass` erkennt `otpauth://` automatisch.
- Im Menü: Eintrag auswählen → `:otp` erzeugt den aktuellen Code.
- Code kann kopiert oder direkt ins aktive Fenster eingefügt werden.

---

## ⌨️ Autotype in `rofi-pass`

Autotype erlaubt dir, ganze Login-Sequenzen automatisch ins aktive Fenster einzufügen.

### Beispiel im Passwort-Eintrag:
```text
MeinSuperPasswort
user: meinuser
otpauth://totp/GitHub:meinuser?secret=ABC123...
autotype: user :tab pass :tab :otp
```

- `user` → fügt den User ein (Zeile mit `user:`)  
- `pass` → fügt das Passwort ein (erste Zeile)  
- `:tab` → simuliert einen Tabulator  
- `:otp` → fügt den aktuellen TOTP-Code ein  

👉 Ablauf: `meinuser<Tab>MeinSuperPasswort<Tab>123456`

Damit kannst du komplette Logins (User + PW + 2FA) automatisieren.

---

## 📷 QR-Codes importieren

Viele Dienste geben dir einen QR-Code statt eines Klartext-Secrets.  
Mit `zbarimg` kannst du den QR-Code direkt auslesen und in `pass-otp` importieren.

### Installation (Arch Linux)
```sh
sudo pacman -S zbar
```

### QR-Code auslesen
```sh
zbarimg qrcode.png
```

Beispielausgabe:
```
QR-Code:otpauth://totp/GitHub:meinuser?secret=JBSWY3DPEHPK3PXP&issuer=GitHub
```

### Direkt in pass importieren
```sh
zbarimg qrcode.png | cut -d: -f2- | pass otp insert github/meinuser
```

→ liest den QR-Code aus und speichert ihn direkt in `pass`.

---

## 💡 Tipps & Tricks
- **Mehrere Konten pro Dienst** → Label klar benennen (`GitHub:privat`, `GitHub:arbeit`)  
- **Backup**: Seeds sind deine "zweiten Schlüssel" → sichere `pass`-Repo wie deine Passwörter  
- **Manuelle OTP-Generierung**:  
  ```sh
  oathtool --totp -b "SECRET"
  ```

---

## ✅ Kurzablauf
1. Secret oder QR-Code vom Dienst holen  
2. `otpauth://` URI bauen oder `pass otp insert` nutzen  
3. In `pass`-Eintrag speichern  
4. Mit `pass otp` oder `rofi-pass` Codes abrufen  
5. Optional: Autotype konfigurieren für vollautomatisches Login  

---

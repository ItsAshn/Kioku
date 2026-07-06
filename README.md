# KIOKU

> **Know where your hours go.** KIOKU automatically monitors which applications you use and for how long — no manual timers, no input required.

![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-blue)
![Electron](https://img.shields.io/badge/Electron-v33-47848F?logo=electron)
![React](https://img.shields.io/badge/React-v18-61DAFB?logo=react)
![TypeScript](https://img.shields.io/badge/TypeScript-v5-3178C6?logo=typescript)

---

## What It Does

KIOKU runs quietly in your system tray and tracks focused application you use.

- **Active time** — the app has your focus (window in foreground)

All data is stored locally in a SQLite database. Nothing is sent to any server.

## Features

- **Automatic tracking** — polls every 5 seconds with no user input required
- **Dashboard** — view daily, weekly, monthly, or custom time range summaries with bar charts
- **Gallery** — browse all tracked apps and groups, edit metadata, set custom icons
- **App groups** — organize apps into categories (Browsers, Games, Dev Tools, etc.) with pattern-based auto-grouping
- **Blacklist / Whitelist modes** — track everything by default, or only what you explicitly allow
- **Steam import** — pull your Steam game library in one click
- **Data export & import** — full JSON backup and restore
- **Auto-updates** — checks for new releases on launch via GitHub

## Screenshots

**Gallery** — every tracked app and game shown as a card with cover art. From here you can rename entries, assign custom artwork, and organize apps into groups.

![Gallery page showing a grid of tracked games with cover art](docs/screenshots/Gallery.png)

**Dashboard heatmap** — a calendar-style heatmap showing daily usage intensity over time, part of the main Dashboard view.

![Dashboard heatmap showing daily usage patterns over several months](docs/screenshots/Heatmap.png)

---

Grab the build for your platform from the [Releases](https://github.com/ItsAshn/Kioku/releases) page. KIOKU installs per-user (no admin required), starts tracking immediately, and lives in your system tray.

| Platform | Download | In-app auto-update |
|----------|----------|--------------------|
| Windows | `.exe` (NSIS installer) | ✅ Yes |
| macOS | `.dmg` (Apple Silicon + Intel) | ⚠️ Requires code signing (not yet available) |
| Linux | `.AppImage` (recommended), `.deb`, `.tar.gz` | ✅ AppImage only |

### Quick install (one-liner)

These scripts fetch the latest release, install it, and handle the unsigned-app warnings for you (macOS quarantine / Windows Mark-of-the-Web).

**Windows** — PowerShell:

```powershell
irm https://raw.githubusercontent.com/ItsAshn/Kioku/main/scripts/install-windows.ps1 | iex
```

**macOS** — Terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/ItsAshn/Kioku/main/scripts/install-macos.sh | bash
```

**Linux** — Terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/ItsAshn/Kioku/main/scripts/install-linux.sh | bash
```

> Prefer to see what you're running first? The scripts live in [`scripts/`](scripts/). Manual per-platform instructions are below.

### Windows

Download and run the `.exe`.

**Data location**: `%APPDATA%\KIOKU\`

#### Windows SmartScreen Warning

Because the installer is currently unsigned, Windows SmartScreen may show a *"Windows protected your PC"* dialog. This is expected. To proceed:

1. Click **More info**
2. Click **Run anyway**

The application is safe. This warning appears for any installer without a paid code-signing certificate.

### macOS

The [quick-install script](#quick-install-one-liner) is the easiest route — it installs the app and removes the quarantine flag so Gatekeeper won't block it.

To install manually instead, download the `.dmg` for your chip (Apple Silicon `arm64` or Intel `x64`), open it, and drag **KIOKU** to your Applications folder.

Because the app is currently unsigned/un-notarized, macOS Gatekeeper will block the first launch of a manually-downloaded build with an *"KIOKU can't be opened because Apple cannot check it for malicious software"* message. To proceed:

1. Right-click (or Control-click) **KIOKU** in Applications and choose **Open**, then confirm **Open** in the dialog — or
2. Go to **System Settings → Privacy & Security**, scroll to the blocked-app notice, and click **Open Anyway**.

**Screen Recording permission**: KIOKU reads the title of your active window to identify what you're using. On first run, macOS prompts for **Screen Recording** permission (**System Settings → Privacy & Security → Screen Recording**). Grant it and restart the app, otherwise tracking will only see process names, not window titles.

**Auto-updates** are not yet available on macOS — they require an Apple Developer code-signing certificate. Check the Releases page for new versions.

**Data location**: `~/Library/Application Support/KIOKU/`

### Linux

**AppImage (Recommended for auto-updates):**
Download from [Releases](https://github.com/ItsAshn/Kioku/releases). In-app updates work automatically.

```bash
chmod +x kioku-*.AppImage
./kioku-*.AppImage
```

**Other formats:** `.deb` and `.tar.gz` are also available from [Releases](https://github.com/ItsAshn/Kioku/releases), but do not support in-app auto-updates.

| Format | In-app auto-update | Update method |
|--------|-------------------|---------------|
| AppImage | ✅ Yes | Automatic via GitHub |
| .deb / tar.gz | ❌ No | Manual download |

**Data location:** `~/.config/KIOKU/`

---

## Development

### Prerequisites

- Node.js 20+
- npm

### Setup

```bash
git clone https://github.com/ItsAshn/Kioku.git
cd Kioku
npm install
```

### Run in Development

```bash
npm run dev
```

Starts Electron with hot reload for the renderer process.

### Build

```bash
npm run build      # Build JS/CSS bundles only
npm run package    # Build + package an installer for the current OS
                   #   Windows → .exe · macOS → .dmg/.zip · Linux → .AppImage/.deb/.tar.gz
```

## Privacy

KIOKU reads the names and executable paths of running processes, and the title of your active window, every 5 seconds. This data is used solely to build your local usage history.

- **All data is stored locally** in `%APPDATA%\KIOKU\data.db` (Windows), `~/Library/Application Support/KIOKU/data.db` (macOS), or `~/.config/KIOKU/data.db` (Linux).
- **No data is transmitted** to any external server except automatic update checks against GitHub Releases.
- The app does **not** record keystrokes, clipboard content, screenshots, or any other personal data.

---

## License

Copyright (c) 2025 ItsAshn. All Rights Reserved.

This software is proprietary. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for third-party open-source component licenses.

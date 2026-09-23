<div align="center">

# wtweaks

<img src="playbook.png" width="128" alt="wtweaks icon">

![version](https://img.shields.io/badge/version-beta-blue)
![AME Wizard](https://img.shields.io/badge/AME_Wizard-playbook-7D3C98)
![Windows](https://img.shields.io/badge/Windows-10_22H2-0078D6?logo=windows&logoColor=white)

</div>

> The best tweaks, without going overboard.

An [AME Wizard](https://amelabs.net) playbook — hand-picked tweaks for QoL, debloat and system hardening in two variants, full and lite. Just apply and enjoy.

## 📚 Important Documentation

- [Variants](#-variants) — Full vs Lite
- [Installation](#-installation) — requirements and steps
- [What's included](#-whats-included) — grouped tweak list ([full list in TWEAKS.md](TWEAKS.md))
- [Implementation notes](#-implementation-notes)
- [Build from source](#️-build-from-source)

## 🤔 What is wtweaks?

wtweaks is an open-source [AME Wizard](https://amelabs.net) playbook that applies hand-picked Windows tweaks without going overboard: Explorer and Start menu QoL, debloat, privacy and system hardening, plus wallpapers with dark mode.

It ships in two variants — Full and Lite. No custom ISO, no activation tricks, just apply and enjoy.

## 👀 Why wtweaks?

### ✅ Usability first

wtweaks configures the interface to make Windows easier to use: a clean This PC and sidebar, a quiet Start menu, visible files, instant menus and sensible Explorer defaults — details in [TWEAKS.md](TWEAKS.md).

### 🔒 Private without breaking things

Telemetry-adjacent noise is turned off via group policies and preferences — Bing/web search, Content Delivery (suggested apps, tips, ads), background apps, Store auto-updates, network discoverability prompts — while keeping Windows Update, SmartScreen and core features functional and toggleable.

### 📈 Lightweight, no placebo

No tweaks for a placebo effect or marginal gains. Lite is QoL and light debloat only. Full adds the heavier stuff on top: UWP/Edge/OneDrive debloat via an AllUsers removal engine, minimal search indexing, custom power scheme, Fast Startup off, mitigations off, services tuning and updates pause — each documented below. VC++ runtimes and theme stay checkbox-optional.

### 🛡️ Security is a choice

Unlike most tweakers, wtweaks does not force security off. Defender removal is an explicit option on the options page: it installs the NoDefender CBS package (TrustedInstaller, cert-checked) and hides the now-unused Security pages, or cleanly uninstalls the package back when Defender stays enabled. CPU mitigations follow the Full variant only, and Lite touches no security at all.

### 🔍 Open Source and Transparent

wtweaks is straightforward to audit thanks to AME Wizard. Playbooks are renamed **.zip** archives with the password `malte`, and consist primarily of plain text (`playbook.conf`, `Configuration/*.yml`). The `Executables/` are readable scripts: a Win11Debloat-inspired AllUsers AppX remover, a Start-menu cleanup, and the trimmed CBS installer used only for the NoDefender package.

As wtweaks doesn't redistribute a modified Windows ISO, it complies with the Microsoft Windows Usage Terms. In addition, wtweaks does not alter activation in Windows.

## 📦 Variants

| | Full (`wtweaks_0.1.0.apbx`) | Lite (`wtweaks_0.1.0-lite.apbx`) |
|---|---|---|
| Explorer / Start QoL | ✅ | ✅ (subset) |
| Light debloat & privacy (Bing, Content Delivery, Game Bar, indexing, updates notify) | ✅ | ✅ |
| Heavy debloat (UWP, Edge, OneDrive, optional browser / VC++ runtimes) | ✅ | ❌ |
| System hardening (mitigations off, Fast Startup off, services, svchost split off, updates paused to 2077, power scheme, Defender option) | ✅ | ❌ |
| Options pages (Defender, browser choice, VC++ and theme checkboxes) | ✅ | ❌ |
| Reboot needed | yes, for mitigations / Fast Startup / services | no |

Lite is the QoL subset with no hardening and no options pages — the exact per-task breakdown for both variants is in [TWEAKS.md](TWEAKS.md).

## 🚀 Installation

1. Download [AME Wizard](https://amelabs.net). Requirements: **Windows 10 22H2** (other builds are refused) and internet — the Full variant downloads a browser, vcredists and PSReadLine while applying.
2. Drag `wtweaks_0.1.0.apbx` (or the `-lite` one) into it. Full only: optionally pick Firefox or Chrome on the options page, Enable / Disable Defender, and tick / untick Visual C++ Runtimes and the dark theme.
3. Done — Explorer restarts itself.
   - Lite: no reboot needed.
   - Full: reboot needed for mitigations, Fast Startup and services to fully apply (everything else works immediately).

> ⚠️ Nothing this playbook does can be undone from within itself — there is no revert, no toggle-back, no uninstaller. If anything breaks or you change your mind, your only way back is a restore point, a VM snapshot, or a fresh Windows install. Set one of those up before applying. Use on a fresh install.

## 🧰 What's included

Grouped summary — the full per-task list (50 Full / 25 Lite) lives in [TWEAKS.md](TWEAKS.md).

| Category | In short | Lite |
|---|---|---|
| Explorer & Start | Clean This PC, sidebar and Start, visible files and extensions, quiet Open With dialog, sensible Explorer defaults | subset |
| Debloat | UWP/Edge/OneDrive removal + deprovision, cleared Start tiles, optional browser and runtimes | ❌ |
| Privacy & Updates | No web search or ads, notify-style updates, release pinned, updates paused to 2077 | subset |
| Performance & Hardware | Minimal indexing, 1:1 mouse, instant menus, Game Bar off, unsplit svchost, custom power scheme, mitigations off, tuned services | subset |
| Look & Feel | Optional dark theme and lockscreen, sharp logon background, wtweaks branding, fresh PSReadLine | subset |
| Security option | Defender removal via CBS package (optional) | ❌ |

## 🔧 Implementation notes

Notes on how specific tweaks behave:

- **No option screens for removals.** Edge, OneDrive and Snipping Tool are always removed and the Start layout is always cleared; only browser, Defender, VC++ runtimes and theme are optional.
- **No taskbar pins.** Existing taskbar pins are left alone.
- **Open With tweak.** Hides the "Look for an app in the Microsoft Store" entry in the Open With dialog for unknown extensions.
- **UWP removal engine.** ~35 preinstalled AppX families removed by wtweaks' own `Remove-UwpApps.ps1` (Win11Debloat-inspired, MIT): one inventory pass, per-app jobs with timeouts, AllUsers plus provisioned packages.
- **Start menu cleanup limited to tiles.** Applies only the empty tile layout and drops the tilegrid database — app-list cleanup is redundant after the AllUsers removal above.
- **Home pins: videos only.** After recent-files cleanup hides them, only Videos is pinned back.
- **Folder discovery.** The documented disable value `NotSpecified` is set directly for `FolderType`.
- **Defender removal via CBS package, trimmed.** Disable installs the NoDefender package via a trimmed `packageInstall.ps1` (TrustedInstaller, cert-checked, no Safe Mode fallback or UI prompts); Enable uninstalls it back. Unused Security pages (Family, Device health, Account protection) are hidden alongside via `UILockdown`.
- **Pause dates.** End `2077-01-01` (start `2026-09-19`), `FlightSettingsMaxPauseDays = 18400`.
- **Power scheme.** Ultimate Performance base with CPU min 15% and display off after 15 min, Fast Startup off.
- **Browser choice.** Only Firefox and Chrome; Firefox is the default.

## 🛠️ Build from source

Open this folder in VS Code and press `F5` (Run and Debug → `Build Playbook (.apbx)`, needs the [PowerShell extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)), or run the default build task (`Ctrl+Shift+B`). Both `.apbx` archives are packed with 7-Zip, password `malte`.

## 🤍 Credits

- [Atlas OS](https://github.com/Atlas-OS/Atlas) (tweaks taken from `0.4.1`) — Explorer/Start/search tweaks, UWP/Edge/OneDrive/browser/vcredist installs, Game Bar, power scheme, mitigations, NoDefender package, updates handling, mouse, indexing, wallpapers and theme values
- [ReviOS playbook](https://github.com/meetrevision/playbook) — services configuration, updates pause mechanism
- [Win11Debloat](https://github.com/Raphire/Win11Debloat) (MIT) — removal engine inspiration for `Remove-UwpApps.ps1`
- [Ameliorated](https://amelabs.net) — AME Wizard

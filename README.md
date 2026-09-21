<div align="center">

# wtweaks

<img src="playbook.png" width="128" alt="wtweaks icon">

![version](https://img.shields.io/badge/version-beta-blue)
![AME Wizard](https://img.shields.io/badge/AME_Wizard-playbook-7D3C98)
![Windows](https://img.shields.io/badge/Windows-10_22H2-0078D6?logo=windows&logoColor=white)

![Atlas OS](https://img.shields.io/badge/Atlas_OS-87%25-1A91FF)
![ReviOS](https://img.shields.io/badge/ReviOS-5%25-E74C3C)
![wtweaks](https://img.shields.io/badge/wtweaks-8%25-2ECC71)

</div>

> The best tweaks, without going overboard.

An [AME Wizard](https://amelabs.net) playbook — hand-picked tweaks from **Atlas OS**, the **ReviOS playbook** and original wtweaks tweaks: QoL, debloat and system hardening in two variants, full and lite. Just apply and enjoy.

## 📚 Important Documentation

- [Variants](#-variants) — Full vs Lite
- [Installation](#-installation) — requirements and steps
- [What's included](#-whats-included) — grouped tweak list ([full list in TWEAKS.md](TWEAKS.md))
- [Differences from upstream](#-differences-from-upstream) — where wtweaks deviates from Atlas OS and ReviOS
- [Build from source](#️-build-from-source)

## 🤔 What is wtweaks?

wtweaks is an open-source [AME Wizard](https://amelabs.net) playbook that applies hand-picked Windows tweaks without going overboard: Explorer and Start menu QoL, debloat, privacy and system hardening, plus Atlas wallpapers with dark mode.

It ports hand-picked tweaks from **Atlas OS (0.4.1)** and the **ReviOS playbook**, plus a few original wtweaks tweaks, in two variants — Full and Lite. No custom ISO, no activation tricks, just apply and enjoy.

## 👀 Why wtweaks?

### ✅ Usability first

wtweaks configures the interface to make Windows easier to use: a clean This PC and sidebar, a quiet Start menu, visible files, instant menus and sensible Explorer defaults — details in [TWEAKS.md](TWEAKS.md).

### 🔒 Private without breaking things

Telemetry-adjacent noise is turned off via group policies and preferences — Bing/web search, Content Delivery (suggested apps, tips, ads), background apps, Store auto-updates, network discoverability prompts — while keeping Windows Update, SmartScreen and core features functional and toggleable.

### 📈 Lightweight, no placebo

No tweaks for a placebo effect or marginal gains. Lite is QoL and light debloat only. Full adds the heavier stuff on top: UWP/Edge/OneDrive debloat via an AllUsers removal engine, minimal search indexing, Atlas power scheme, Fast Startup off, mitigations off, services tuning and updates pause — each ported 1:1 from upstream unless noted below. VC++ runtimes stay checkbox-optional.

### 🛡️ Security is a choice

Unlike most tweakers, wtweaks does not force security off. Defender removal is an explicit option on the options page: it installs the Atlas NoDefender CBS package (TrustedInstaller, cert-checked) and hides the now-unused Security pages, or cleanly uninstalls the package back when Defender stays enabled. CPU mitigations follow the Full variant only, and Lite touches no security at all.

### 🔍 Open Source and Transparent

Like Atlas, wtweaks is straightforward to audit thanks to AME Wizard. Playbooks are renamed **.zip** archives with the password `malte`, and consist primarily of plain text (`playbook.conf`, `Configuration/*.yml`). The `Executables/` are readable scripts: a Win11Debloat-inspired AllUsers AppX remover, a trimmed Atlas Start-menu cleanup, and the trimmed Atlas CBS installer used only for the NoDefender package.

As wtweaks doesn't redistribute a modified Windows ISO, it complies with the Microsoft Windows Usage Terms. In addition, wtweaks does not alter activation in Windows.

## 📦 Variants

| | Full (`wtweaks_0.1.0.apbx`) | Lite (`wtweaks_0.1.0-lite.apbx`) |
|---|---|---|
| Explorer / Start QoL | ✅ | ✅ (subset) |
| Light debloat & privacy (Bing, Content Delivery, Game Bar, indexing, updates notify) | ✅ | ✅ |
| Heavy debloat (UWP, Edge, OneDrive, taskbar pins, optional browser / VC++ runtimes) | ✅ | ❌ |
| System hardening (mitigations off, Fast Startup off, services, updates paused to 2077, power scheme, Defender option) | ✅ | ❌ |
| Options pages (Defender, browser choice, VC++ checkbox) | ✅ | ❌ |
| Reboot needed | yes, for mitigations / Fast Startup / services | no |

Lite is the QoL subset with no hardening and no options pages — the exact per-task breakdown for both variants is in [TWEAKS.md](TWEAKS.md).

## 🚀 Installation

1. Download [AME Wizard](https://amelabs.net). Requirements: **Windows 10 22H2** (other builds are refused) and internet — the Full variant downloads a browser, vcredists and PSReadLine while applying.
2. Drag `wtweaks_0.1.0.apbx` (or the `-lite` one) into it. Full only: optionally pick Firefox or Chrome on the options page, Enable / Disable Defender, and tick / untick Visual C++ Runtimes.
3. Done — Explorer restarts itself.
   - Lite: no reboot needed.
   - Full: reboot needed for mitigations, Fast Startup and services to fully apply (everything else works immediately).

> ⚠️ Nothing this playbook does can be undone from within itself — there is no revert, no toggle-back, no uninstaller. If anything breaks or you change your mind, your only way back is a restore point, a VM snapshot, or a fresh Windows install. Set one of those up before applying. Use on a fresh install.

## 🧰 What's included

Grouped summary — the full per-task list (49 Full / 25 Lite) lives in [TWEAKS.md](TWEAKS.md).

| Category | In short | Source | Lite |
|---|---|---|---|
| Explorer & Start | Clean This PC, sidebar and Start, visible files and extensions, sensible Explorer defaults | Atlas OS | subset |
| Debloat | UWP/Edge/OneDrive removal + deprovision, cleared Start tiles, optional browser and runtimes, taskbar pins | Atlas OS | ❌ |
| Privacy & Updates | No web search or ads, notify-style updates, release pinned, updates paused to 2077 | Atlas OS + ReviOS | subset |
| Performance & Hardware | Minimal indexing, 1:1 mouse, instant menus, Game Bar off, Atlas power scheme, mitigations off, tuned services | Atlas OS + ReviOS | subset |
| Look & Feel | Atlas dark theme and lockscreen, sharp logon background, wtweaks branding, fresh PSReadLine | Atlas OS + wtweaks | subset |
| Security option | Defender removal via the Atlas CBS package (optional) | Atlas OS | ❌ |

## 🔧 Differences from upstream

Tweaks are ported 1:1 unless noted here:

- **No option screens for removals.** Atlas and ReviOS gate removals behind choices (`uninstall-edge`, `remove-snipping-tool`, …). Here Edge, OneDrive and Snipping Tool are always removed and the Start layout is always cleared; only browser, Defender and VC++ runtimes are optional.
- **UWP removal engine.** Atlas list plus Yandex Music, but removed by wtweaks' own `Remove-UwpApps.ps1` (Win11Debloat-inspired, MIT): one inventory pass, per-app jobs with timeouts, AllUsers plus provisioned packages — faster than one `!appx` call per package.
- **Start menu cleanup trimmed to tiles.** The Atlas `STARTMENU.ps1` port applies only the empty tile layout and drops the tilegrid database — app-list cleanup is redundant after the AllUsers removal above.
- **Home pins: videos only.** After recent-files cleanup hides them, Atlas re-pins Music and Videos; here only Videos is pinned back.
- **Folder discovery: NotSpecified instead of delete.** Atlas deletes `FolderType` via `.reg` (its direct write stays commented out over an AME hives issue); here the documented disable value is set directly.
- **Defender removal is the Atlas CBS package, trimmed.** Disable installs the Atlas NoDefender package via a trimmed `packageInstall.ps1` port (TrustedInstaller, cert-checked, no Safe Mode fallback or UI prompts); Enable uninstalls it back. Unused Security pages (Family, Device health, Account protection) are hidden alongside via `UILockdown`.
- **Pause dates.** End `2077-01-01` (start `2026-09-19`), `FlightSettingsMaxPauseDays = 18400` — instead of ReviOS' `2038-01-19` / `5269`.
- **Power scheme softening.** On top of the untouched Atlas `DisablePowerSaving.ps1`: CPU min 15% instead of 100%, display off after 15 min instead of never.
- **Browser choice.** Image tiles like Atlas, but only Firefox and Chrome; Firefox is the default, no Chrome warning.

## 🛠️ Build from source

Open this folder in VS Code and press `F5` (Run and Debug → `Build Playbook (.apbx)`, needs the [PowerShell extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)), or run the default build task (`Ctrl+Shift+B`). Both `.apbx` archives are packed with 7-Zip, password `malte`.

## 💙 Credits

- [Atlas OS](https://github.com/Atlas-OS/Atlas) (tweaks taken from `0.4.1`) — Explorer/Start/search tweaks, UWP/Edge/OneDrive/browser/vcredist installs, Game Bar, power scheme, mitigations, NoDefender package, updates handling, mouse, indexing, wallpapers and theme values
- [ReviOS playbook](https://github.com/meetrevision/playbook) — services configuration, updates pause mechanism
- [Win11Debloat](https://github.com/Raphire/Win11Debloat) (MIT) — removal engine inspiration for `Remove-UwpApps.ps1`
- [Ameliorated](https://amelabs.net) — AME Wizard

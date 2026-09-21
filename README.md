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

wtweaks configures many aspects of the interface to make Windows easier to use: This PC as the Explorer home, no sidebar clutter or drive duplicates, clean Start menu without recommendations and ads, instant menus, verbose transfer details, debloated Send-To, no Aero Shake or lockscreen blur surprises.

### 🔒 Private without breaking things

Telemetry-adjacent noise is turned off via group policies and preferences — Bing/web search, Content Delivery (suggested apps, tips, ads), background apps, Store auto-updates, network discoverability prompts — while keeping Windows Update, SmartScreen and core features functional and toggleable.

### 📈 Lightweight, no placebo

No tweaks for a placebo effect or marginal gains. Lite is QoL and light debloat only. Full adds the heavier stuff on top: UWP/Edge/OneDrive debloat, minimal search indexing, Atlas power scheme, Fast Startup off, mitigations off, services tuning and updates pause — each ported 1:1 from upstream unless noted below.

### 🛡️ Security is a choice

Unlike most tweakers, wtweaks does not force security off. Defender disable is an explicit option on the options page (policies + services, no component removal), CPU mitigations and UAC behavior follow the Full variant only, and Lite touches no security at all.

### 🔍 Open Source and Transparent

Like Atlas, wtweaks is straightforward to audit thanks to AME Wizard. Playbooks are renamed **.zip** archives with the password `malte`, and consist primarily of plain text (`playbook.conf`, `Configuration/*.yml`). The few binaries in `Executables/` are scripts and Atlas utilities you can read before applying.

As wtweaks doesn't redistribute a modified Windows ISO, it complies with the Microsoft Windows Usage Terms. In addition, wtweaks does not alter activation in Windows.

## 📦 Variants

| | Full (`wtweaks_0.1.0.apbx`) | Lite (`wtweaks_0.1.0-lite.apbx`) |
|---|---|---|
| Explorer / Start QoL | ✅ | ✅ |
| Light debloat & privacy (Bing, Content Delivery, Game Bar, indexing, updates notify) | ✅ | ✅ |
| Heavy debloat (UWP, Edge, OneDrive, browser/vcredist install) | ✅ | ❌ |
| System hardening (mitigations off, Fast Startup off, services, updates paused to 2077, power scheme, Defender option) | ✅ | ❌ |
| Options pages (Defender, browser choice) | ✅ | ❌ |
| Reboot needed | yes, for mitigations / Fast Startup / services | no |

Lite is exactly the QoL subset: clean This PC and sidebar, Quick Access and Start cleanup, Game Bar off, Start-menu-only indexing, no recommendations / Shake / discoverability prompt / Bing / Content Delivery, notify-style updates with Delivery Optimization off, transfer details + Send-To cleanup, 1:1 mouse, instant menus with no startup delay and fast shutdown, no lockscreen blur, wtweaks lite OEM branding, updated PSReadLine.

## 🚀 Installation

1. Download [AME Wizard](https://amelabs.net). Requirements: **Windows 10 22H2** (other builds are refused) and internet — the Full variant downloads a browser, vcredists and PSReadLine while applying.
2. Drag `wtweaks_0.1.0.apbx` (or the `-lite` one) into it. Full only: optionally pick Firefox or Chrome on the options page, and Enable / Disable Defender.
3. Done — Explorer restarts itself.
   - Lite: no reboot needed.
   - Full: reboot needed for mitigations, Fast Startup and services to fully apply (everything else works immediately).

> ⚠️ Nothing this playbook does can be undone from within itself — there is no revert, no toggle-back, no uninstaller. If anything breaks or you change your mind, your only way back is a restore point, a VM snapshot, or a fresh Windows install. Set one of those up before applying. Use on a fresh install.

## 🧰 What's included

Grouped summary — see [TWEAKS.md](TWEAKS.md) for the full per-task list (41 Full / 25 Lite). Full includes everything below, Lite includes only rows marked Lite.

| Category | Tweaks | Source | Lite |
|---|---|---|---|
| Explorer & Start | Hide 7 folders from This PC, open to This PC, no sidebar drive duplicates, no Network item, no recent/frequent + jump lists, no "Recently added", no recommendations, transfer details on, debloated Send-To | Atlas OS | ✅ |
| Debloat | ~35 UWP families removed + deprovisioned, Edge removed, OneDrive removed, optional Firefox/Chrome install, Visual C++ Runtimes 2005–2022, background apps off, Store auto-updates off | Atlas OS | ❌ |
| Privacy & Updates | Bing/web search off, Content Delivery off, release pinned (no feature upgrades), auto-download off + Delivery Optimization off, updates paused until `2077-01-01` | Atlas OS + ReviOS | partially* |
| Performance & Hardware | Start-menu-only indexing, 1:1 mouse, instant menus + no startup delay + fast shutdown, Game Bar off, Aero Shake off, Atlas power scheme (CPU min 15%, display off after 15 min), Fast Startup off, mitigations off, 16 services tuned | Atlas OS + ReviOS | partially* |
| Look & Feel | Atlas dark wallpaper + lockscreen, dark mode, `#4A51A8` accent, no lockscreen blur, wtweaks OEM branding, updated PSReadLine, Explorer restart to apply | Atlas OS + wtweaks | partially* |
| Security option | Defender off via policies + services (optional, Full only) | Atlas OS + ReviOS | ❌ |

\* Lite includes Game Bar off, Start-only indexing, mouse/menus/shutdown speedups, recommendations/Shake/discoverability/Bing/Content Delivery off, notify-style updates, no lockscreen blur, lite OEM branding and PSReadLine — but not the power scheme, mitigations, services, pause or Defender option.

## 🔧 Differences from upstream

Tweaks are ported 1:1 unless noted here:

- **No option screens.** Atlas and ReviOS gate removals behind choices (`uninstall-edge`, `remove-snipping-tool`, …). Here Edge, OneDrive and Snipping Tool are always removed; only browser install and Defender are optional.
- **Defender disable is policy-level, combined.** Atlas removes Defender components via DISM CABs and ReviOS via its own WinSxS package; here policies come from both playbooks' approach, plus ReviOS extras (wscsvc, SmartScreen, scheduled tasks, PUA) — no component removal. Full Atlas-style CAB removal is not portable here: the packages are huge, tied to specific Windows builds, and need Atlas packaging infrastructure.
- **Pause dates.** ReviOS uses end `2038-01-19T03:14:07Z`, `FlightSettingsMaxPauseDays = 5269`, start `2023-08-17T12:47:51Z`. Here: end `2077-01-01T00:00:00Z`, `FlightSettingsMaxPauseDays = 18400`, start `2026-09-19T00:00:00Z`.
- **Power scheme softening.** On top of the untouched Atlas `DisablePowerSaving.ps1`: CPU min 15% instead of 100%, display off after 15 min instead of never.
- **Browser choice.** Image tiles like Atlas, but only Firefox and Chrome; Firefox is the default, no Chrome warning.

## 🛠️ Build from source

Open this folder in VS Code and press `F5` (Run and Debug → `Build Playbook (.apbx)`, needs the [PowerShell extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)), or run the default build task (`Ctrl+Shift+B`). Both `.apbx` archives are packed with 7-Zip, password `malte`.

## 💙 Credits

- [Atlas OS](https://github.com/Atlas-OS/Atlas) (tweaks taken from `0.4.1`) — Explorer/Start/search tweaks, UWP/Edge/OneDrive/browser/vcredist installs, Game Bar, power scheme, mitigations, updates handling, mouse, indexing, wallpapers and theme values
- [ReviOS playbook](https://github.com/meetrevision/playbook) — services configuration, updates pause mechanism
- [Ameliorated](https://amelabs.net) — AME Wizard

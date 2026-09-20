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

An [AME Wizard](https://amelabs.net) playbook — 33 tweaks from **Atlas OS 0.4.1**, 2 from the **ReviOS playbook** and 3 original wtweaks tweaks: QoL, debloat and system hardening in two variants, full and lite. Just apply and enjoy.

## Variants

**Full** (`wtweaks_0.1.0.apbx`) — everything listed in [What's inside](#whats-inside) below.

**Lite** (`wtweaks_0.1.0-lite.apbx`) — QoL and light debloat, no system hardening:
- Hide folders from This PC
- Explorer opens to This PC
- No duplicate removable drives (only in This PC)
- No Network item in the sidebar
- Hide recent/frequent in Quick Access
- Hide "Recently added" in Start
- Xbox Game Bar off
- Minimal search indexing (Start Menu only)
- Start recommendations off (tips, shortcuts, new apps)
- Aero Shake off
- No network discoverability prompt
- Bing/web search off
- Content Delivery off (suggested apps, tips, ads)
- WU auto-download off (notify instead), Delivery Optimization off
- Transfer details always on, Send-To debloated
- Mouse acceleration off
- Instant menus, no startup delay, fast shutdown
- Lockscreen blur off
- OEM branded as wtweaks lite
- PSReadLine updated

## What's inside

| Tweak | Source |
|---|---|
| `ThisPCPolicy = Hide` for 7 folders (Desktop, Documents, Downloads, Music, Pictures, Videos, 3D Objects) | Atlas OS |
| Explorer opens to This PC (`LaunchTo = 1`) | Atlas OS |
| Removable drives shown only in This PC (no sidebar duplicates) | Atlas OS |
| No Network item in the sidebar (`IsPinnedToNameSpaceTree = 0`) | Atlas OS |
| `ShowFrequent/ShowRecent = 0`, no recent docs history, no remote jump lists | Atlas OS |
| `HideRecentlyAddedApps = 1` in Start menu | Atlas OS |
| ~35 UWP families removed via `!appx` + deprovisioned against reinstall | Atlas OS |
| Edge via `RemoveEdge.ps1` + AppX + deprovision keys | Atlas OS |
| Browser install (Firefox/Chrome choice, optional) | Atlas OS |
| Visual C++ Runtimes 2005-2022 x86/x64 | Atlas OS |
| OneDrive via `ONED.cmd` | Atlas OS |
| Windows release pinned (`TargetReleaseVersion`, no feature upgrades) | Atlas OS |
| WU auto-download off (`AUOptions = 2`), Delivery Optimization off (`DODownloadMode = 0`) | Atlas OS |
| Transfer details on (`EnthusiastMode`), Send-To without Documents/Mail/Fax/Bluetooth | Atlas OS |
| Background apps off (`GlobalUserDisabled = 1`) | Atlas OS |
| Search index: Start Menu only, no user folders | Atlas OS |
| Mouse acceleration off (1:1 movement) | Atlas OS |
| Instant menus, no startup delay, fast shutdown | Atlas OS |
| Store app auto-updates off | Atlas OS |
| Game Bar overlay off (`AppCaptureEnabled`, `AllowGameDVR`…) | Atlas OS |
| Start recommendations off (`Start_IrisRecommendations`, `Start_AccountNotifications`) | Atlas OS |
| Aero Shake off (`DisallowShaking = 1`) | Atlas OS |
| No network discoverability prompt (`NewNetworkWindowOff`) | Atlas OS |
| Bing/web search off (`BingSearchEnabled`, `DisableWebSearch`, no cloud search/location) | Atlas OS |
| Content Delivery off (no suggested apps like Candy Crush, no tips/ads/suggestions) | Atlas OS |
| `atlas-v0.4.x-dark.png` wallpaper + lockscreen, dark mode, `#4A51A8` accent | Atlas OS |
| Atlas Power Scheme (Ultimate Performance clone) | Atlas OS |
| Fast Startup off (`HiberbootEnabled = 0`) | Atlas OS |
| Mitigations off (Spectre/Meltdown, SEHOP, CFG, DEP) | Atlas OS |
| Defender off via policies + services (optional) | Atlas OS + ReviOS |
| Explorer restart to apply everything immediately | Atlas OS |
| 16 services disabled/manual/auto (dam, DiagTrack, WerSvc, UCPD…) | ReviOS |
| Windows Updates paused until `2077-01-01` | ReviOS |
| PSReadLine updated (fixes outdated Win10 module) | wtweaks |
| Lockscreen blur off | wtweaks |
| OEM branded as wtweaks | wtweaks |

## Deviations from upstream

Tweaks are ported 1:1 unless noted here:
- **No option screens.** Atlas and ReviOS gate removals behind choices (`uninstall-edge`, `remove-snipping-tool`, …). Here Edge, OneDrive and Snipping Tool are always removed; only browser install and Defender are optional.
- **Defender disable is policy-level, combined.** Atlas removes Defender components via DISM CABs and ReviOS via its own WinSxS package; here policies come from both playbooks' approach, plus ReviOS extras (wscsvc, SmartScreen, scheduled tasks, PUA) — no component removal. Full Atlas-style CAB removal is not portable here: the packages are huge, tied to specific Windows builds, and need Atlas packaging infrastructure.
- **Pause dates.** ReviOS uses end `2038-01-19T03:14:07Z`, `FlightSettingsMaxPauseDays = 5269`, start `2023-08-17T12:47:51Z`. Here: end `2077-01-01T00:00:00Z`, `FlightSettingsMaxPauseDays = 18400`, start `2026-09-19T00:00:00Z`.
- **Power scheme softening.** On top of the untouched Atlas `DisablePowerSaving.ps1`: CPU min 15% instead of 100%, display off after 15 min instead of never.
- **Browser choice.** Image tiles like Atlas, but only Firefox and Chrome; Firefox is the default, no Chrome warning.

## Usage

1. Download [AME Wizard](https://amelabs.net). Requirements: Windows 10 22H2 (other builds are refused) and internet — the full variant downloads a browser, vcredists and PSReadLine while applying.
2. Drag `wtweaks_0.1.0.apbx` (or the `-lite` one) into it. Full only: optionally pick Firefox or Chrome on the options page.
3. Done — Explorer restarts itself.
   - Lite: no reboot needed.
   - Full: reboot needed for mitigations, Fast Startup and services to fully apply (everything else works immediately).

> ⚠️ Nothing this playbook does can be undone from within itself — there is no revert, no toggle-back, no uninstaller. If anything breaks or you change your mind, your only way back is a restore point, a VM snapshot, or a fresh Windows install. Set one of those up before applying.

## Build from source

Open this folder in VS Code and press `F5` (Run and Debug → `Build Playbook (.apbx)`, needs the [PowerShell extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)), or run the default build task (`Ctrl+Shift+B`). Both `.apbx` archives are packed with 7-Zip, password `malte`.

## Credits

- [Atlas OS](https://github.com/Atlas-OS/Atlas) (tweaks taken from `0.4.1`) — Explorer/Start/search tweaks, UWP/Edge/OneDrive/browser/vcredist installs, Game Bar, power scheme, mitigations, updates handling, mouse, indexing, wallpapers and theme values
- [ReviOS playbook](https://github.com/meetrevision/playbook) — services configuration, updates pause mechanism
- [Ameliorated](https://amelabs.net) — AME Wizard

# wtweaks — full tweak list

Full (`wtweaks_0.1.0.apbx`) — 41 tasks in apply order. Lite (`wtweaks_0.1.0-lite.apbx`) — 25 tasks (QoL subset + Explorer restart).

Legend: ✅ included, ❌ not included, 🔘 optional (options page).

## Debloat

| Tweak (task file) | What it does | Source | Full | Lite |
|---|---|---|---|---|
| Remove UWP apps (`remove-uwp-apps.yml`) | Removes ~35 preinstalled AppX families (Teams, Copilot, Clipchamp, Disney, Spotify, Cortana, Xbox App, Mail/Calendar, Paint, Get Started, Movies & TV, Family, Mixed Reality Portal, Dev Home, Weather/News, Outlook, Get Help, 3D Viewer, Office Hub, Solitaire, Sticky Notes, OneNote, People, Power Automate, Snipping-ish ScreenSketch, Skype, To Do, Alarms, Camera, Feedback Hub, Maps, Voice Recorder, Phone Link), blocks Chat auto-install, deprovisions against reinstall, clears AppX cache | Atlas OS | ✅ | ❌ |
| Clear Start menu (`clear-start-menu.yml`) | Clears dead AppX tiles after debloat, restarts StartMenuExperienceHost | Atlas OS | ✅ | ❌ |
| Remove Edge (`remove-edge.yml`) | Uninstalls Edge via `RemoveEdge.ps1`, removes AppX + deprovision keys so it doesn't come back | Atlas OS | ✅ | ❌ |
| Remove OneDrive (`remove-onedrive.yml`) | Uninstalls OneDrive via `ONED.cmd` | Atlas OS | ✅ | ❌ |
| Content Delivery off (`disable-content-delivery.yml`) | Disables Content Delivery Manager: suggested apps, Tips, ads, silent installs, preinstalled OEM apps, lockscreen overlay promos, Start account notifications | Atlas OS | ✅ | ✅ |
| Browser install (`install-browser.yml`) | Installs the browser picked on the options page (Firefox default, or Chrome, or None) 🔘 | Atlas OS | 🔘 | ❌ |
| Taskbar pins (`config-pins.yml`) | Resets taskbar pins to Explorer + chosen browser, unpins Mail/Copilot | Atlas OS | ✅ | ❌ |
| Visual C++ Runtimes (`install-vcredist.yml`) | Installs VC++ 2005–2022 x86/x64 | Atlas OS | ✅ | ❌ |

## Performance

| Tweak (task file) | What it does | Source | Full | Lite |
|---|---|---|---|---|
| Game Bar off (`disable-game-bar.yml`) | Disables Game Bar overlay, GameDVR capture, PresenceWriter; `AppCaptureEnabled` / `AllowGameDVR = 0` | Atlas OS | ✅ | ✅ |
| Background apps off (`disable-background-apps.yml`) | `GlobalUserDisabled = 1`, no UWP background activity | Atlas OS | ✅ | ❌ |
| Services tuning (`disable-services.yml`) | Disables/manual 16 services: dam, GpuEnergyDrv, NetBT, Telemetry, DiagHub collector, WerSvc, DiagTrack, wisvc, PcaSvc, WDI hosts, tcpipreg, Wecsvc, UCPD (+ UCPD task); edgeupdate → manual, condrv → auto | ReviOS | ✅ | ❌ |
| Search indexing minimal (`search-indexing.yml`) | Rebuilds index limited to Start Menu only, no user folders | Atlas OS | ✅ | ✅ |

## Privacy & Search

| Tweak (task file) | What it does | Source | Full | Lite |
|---|---|---|---|---|
| Bing / web search off (`disable-bing-search.yml`) | No Bing, cloud search, location in search, no search suggestions; taskbar search in icon mode | Atlas OS | ✅ | ✅ |

## Explorer & Start QoL

| Tweak (task file) | What it does | Source | Full | Lite |
|---|---|---|---|---|
| Hide folders from This PC (`hide-folders-this-pc.yml`) | `ThisPCPolicy = Hide` for 7 folders: Desktop, Documents, Downloads, Music, Pictures, Videos, 3D Objects | Atlas OS | ✅ | ✅ |
| Removable drives only in This PC (`removable-drives-only-this-pc.yml`) | No duplicate removable drives in the sidebar | Atlas OS | ✅ | ✅ |
| No Network in sidebar (`disable-network-pane.yml`) | `IsPinnedToNameSpaceTree = 0` for the Network item | Atlas OS | ✅ | ✅ |
| Open to This PC (`open-to-this-pc.yml`) | Explorer `LaunchTo = 1` | Atlas OS | ✅ | ✅ |
| Transfer details (`transfer-details.yml`) | Detailed file-transfer dialog by default (`EnthusiastMode`) | Atlas OS | ✅ | ✅ |
| Send-To cleanup (`sendto-debloat.yml`) | Removes Documents / Mail / Fax / Bluetooth from Send To | Atlas OS | ✅ | ✅ |
| No recent / frequent (`hide-frequently-used-items.yml`) | `ShowFrequent / ShowRecent = 0`, no docs history, no remote jump lists, clear on exit | Atlas OS | ✅ | ✅ |
| No "Recently added" (`hide-recently-added-start-menu.yml`) | `HideRecentlyAddedApps = 1` in Start | Atlas OS | ✅ | ✅ |
| Start recommendations off (`disable-start-recommendations.yml`) | No tips, shortcuts, new-app promos, account notifications (`Start_IrisRecommendations`, `Start_AccountNotifications`) | Atlas OS | ✅ | ✅ |
| Aero Shake off (`disable-aero-shake.yml`) | `DisallowShaking = 1` | Atlas OS | ✅ | ✅ |
| No network prompt (`disable-network-wizard.yml`) | Suppresses the network discoverability popup (`NewNetworkWindowOff`) | Atlas OS | ✅ | ✅ |
| Mouse acceleration off (`disable-mouse-accel.yml`) | 1:1 movement (`MouseSpeed / Threshold1 / Threshold2 = 0`) | Atlas OS | ✅ | ✅ |
| Instant menus (`disable-menu-delay.yml`) | `MenuShowDelay = 0` | Atlas OS | ✅ | ✅ |
| No startup delay (`disable-startup-delay.yml`) | `StartupDelayInMSec = 0` | Atlas OS | ✅ | ✅ |
| Fast shutdown (`decrease-shutdown-time.yml`) | `HungAppTimeout / WaitToKillApp / WaitToKillServiceTimeout = 2000` | Atlas OS | ✅ | ✅ |

## Updates & Store

| Tweak (task file) | What it does | Source | Full | Lite |
|---|---|---|---|---|
| Auto-download off (`disable-auto-updates.yml`) | WU `AUOptions = 2` (notify instead of auto-download) | Atlas OS | ✅ | ✅ |
| Delivery Optimization off (`disable-delivery-optimization.yml`) | `DODownloadMode = 0`, no P2P upload | Atlas OS | ✅ | ✅ |
| Store auto-updates off (`disable-store-auto-updates.yml`) | Manual Store updates (`AutoDownload = 2`) | Atlas OS | ✅ | ❌ |
| Release pinned (`pin-windows-release.yml`) | `TargetReleaseVersion`, no silent feature upgrades | Atlas OS | ✅ | ❌ |
| Updates paused (`pause-updates.yml`) | All update branches paused until `2077-01-01`, `FlightSettingsMaxPauseDays = 18400` | ReviOS | ✅ | ❌ |
| PSReadLine updated (`update-psreadline.yml`) | Updates the outdated Win10 PSReadLine module (needs internet) | wtweaks | ✅ | ✅ |

## Look & feel

| Tweak (task file) | What it does | Source | Full | Lite |
|---|---|---|---|---|
| Atlas appearance (`appearance.yml`) | Atlas dark wallpaper + lockscreen, dark mode, `#4A51A8` / `#4A51A8`-family accent, Atlas dark theme, lockscreen overlays off | Atlas OS | ✅ | ❌ |
| Lockscreen blur off (`disable-lockscreen-blur.yml`) | Sharp logon background (`DisableAcrylicBackgroundOnLogon = 1`) | wtweaks | ✅ | ✅ |
| OEM branding (`oem-info.yml`) | OEM model branded as `wtweaks` (Lite: `wtweaks lite`) | wtweaks | ✅ | ✅ |
| Explorer restart (`restart-explorer.yml`) | Restarts Explorer so everything applies immediately | Atlas OS | ✅ | ✅ |

## Power & Security (Full only)

| Tweak (task file) | What it does | Source | Full | Lite |
|---|---|---|---|---|
| Power plan (`power-plan.yml`) | Atlas power scheme clone (Ultimate Performance base, CPU min softened to 15%, display off after 15 min), Fast Startup off (`HiberbootEnabled = 0`) | Atlas OS + wtweaks | ✅ | ❌ |
| Mitigations off (`disable-mitigations.yml`) | Disables Spectre/Meltdown, SEHOP, CFG, DEP mitigations (reboot to fully apply) | Atlas OS | ✅ | ❌ |
| Defender off (`disable-defender.yml`) | Policy-level disable (optional): Defender AV/spyware/RTP/behavior policies, WinDefend/WdNisSvc/Sense/wscsvc disabled, SmartScreen off, SecurityHealth removed from startup, 4 Defender scheduled tasks off, PUA protection off 🔘 | Atlas OS + ReviOS | 🔘 | ❌ |

## Counts

- Full: 41 tasks (all of the above, in `Configuration/main.yml` order).
- Lite: 25 tasks — Game Bar, search indexing, Bing, Content Delivery, all 17 Explorer/Start QoL rows above except Store/release/pause/appearance, plus lockscreen blur, OEM (`wtweaks lite`), PSReadLine and Explorer restart. No options pages, no reboot needed.

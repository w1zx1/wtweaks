# wtweaks — full tweak list

Full (`wtweaks_0.1.0.apbx`) — 50 tasks in apply order. Lite (`wtweaks_0.1.0-lite.apbx`) — 25 tasks (QoL subset + Explorer restart).

Legend: ✅ included, ❌ not included, 🔘 optional (options page).

## Debloat

| Tweak (task file) | What it does | Full | Lite |
|---|---|---|---|
| Remove UWP apps (`remove-uwp-apps.yml`) | Removes ~35 preinstalled AppX families for all users plus provisioned packages via `Remove-UwpApps.ps1` (Win11Debloat-style engine: single inventory, per-app jobs with timeout): Teams (legacy + new), Copilot, Clipchamp, Disney, Spotify, Yandex Music, Cortana, Xbox App, Mail/Calendar, Paint 3D, Tips, Movies & TV, Family, Mixed Reality Portal, Dev Home, Weather/News/Search, Outlook, Get Help, 3D Viewer, Office Hub, Solitaire, Sticky Notes, OneNote, People, Power Automate, Snipping-ish ScreenSketch, Skype, To Do, Alarms, Camera, Feedback Hub, Maps, Voice Recorder; blocks Chat auto-install, clears AppX cache | ✅ | ❌ |
| Remove Edge (`remove-edge.yml`) | Uninstalls Edge via `RemoveEdge.ps1`, removes AppX + deprovision keys so it doesn't come back | ✅ | ❌ |
| Remove OneDrive (`remove-onedrive.yml`) | Uninstalls OneDrive via `ONED.cmd` | ✅ | ❌ |
| Clear Start menu (`clear-start-menu.yml`) | Applies an empty default tile layout and drops the tilegrid database (right-side tiles gone; app-list needs no extra cleanup since AllUsers removal takes it) | ✅ | ❌ |
| Content Delivery off (`disable-content-delivery.yml`) | Disables Content Delivery Manager: suggested apps, Tips, ads, silent installs, preinstalled OEM apps, lockscreen overlay promos, Start account notifications | ✅ | ✅ |
| Browser install (`install-browser.yml`) | Installs the browser picked on the options page (Firefox default, or Chrome, or None) 🔘 | 🔘 | ❌ |
| Visual C++ Runtimes (`install-vcredist.yml`) | Installs VC++ 2005–2022 x86/x64, on by default but skippable via checkbox 🔘 | 🔘 | ❌ |
| PSReadLine updated (`update-psreadline.yml`) | Updates the outdated Win10 PSReadLine module, then `Unblock-File`s it so the MOTW mark can't break loading (needs internet) | ✅ | ✅ |

## Performance

| Tweak (task file) | What it does | Full | Lite |
|---|---|---|---|
| Game Bar off (`disable-game-bar.yml`) | Disables Game Bar overlay, GameDVR capture, PresenceWriter; `AppCaptureEnabled` / `AllowGameDVR = 0` | ✅ | ✅ |
| Background apps off (`disable-background-apps.yml`) | `GlobalUserDisabled = 1`, no UWP background activity | ✅ | ❌ |
| Services tuning (`disable-services.yml`) | Disables/manual 16 services: dam, GpuEnergyDrv, NetBT, Telemetry, DiagHub collector, WerSvc, DiagTrack, wisvc, PcaSvc, WDI hosts, tcpipreg, Wecsvc, UCPD (+ UCPD task); edgeupdate → manual, condrv → auto | ✅ | ❌ |
| Service host unsplitting (`disable-service-host-split.yml`) | Sets `SvcHostSplitDisable = 1` on all services except Xbox (lower RAM usage, fewer processes; needs reboot) | ✅ | ❌ |
| Search indexing minimal (`search-indexing.yml`) | Rebuilds index limited to Start Menu only, no user folders | ✅ | ✅ |
| Auto folder discovery off (`disable-auto-folder-discovery.yml`) | No per-folder content-type sniffing in Explorer: `FolderType = NotSpecified` set directly | ✅ | ❌ |
| Power plan (`power-plan.yml`) | Custom power scheme (Ultimate Performance base, CPU min 15%, display off after 15 min), Fast Startup off (`HiberbootEnabled = 0`) | ✅ | ❌ |
| Mitigations off (`disable-mitigations.yml`) | Disables Spectre/Meltdown, SEHOP, CFG, DEP mitigations (reboot to fully apply) | ✅ | ❌ |

## QoL

| Tweak (task file) | What it does | Full | Lite |
|---|---|---|---|
| Hide folders from This PC (`hide-folders-this-pc.yml`) | `ThisPCPolicy = Hide` for 7 folders: Desktop, Documents, Downloads, Music, Pictures, Videos, 3D Objects | ✅ | ✅ |
| Removable drives only in This PC (`removable-drives-only-this-pc.yml`) | No duplicate removable drives in the sidebar | ✅ | ✅ |
| No Network in sidebar (`disable-network-pane.yml`) | `IsPinnedToNameSpaceTree = 0` for the Network item | ✅ | ✅ |
| Open to This PC (`open-to-this-pc.yml`) | Explorer `LaunchTo = 1` | ✅ | ✅ |
| Transfer details (`transfer-details.yml`) | Detailed file-transfer dialog by default (`EnthusiastMode`) | ✅ | ✅ |
| Send-To cleanup (`sendto-debloat.yml`) | Removes Documents / Mail / Fax / Bluetooth from Send To | ✅ | ✅ |
| No recent / frequent (`hide-frequently-used-items.yml`) | `ShowFrequent / ShowRecent = 0`, no docs history, no remote jump lists, clear on exit | ✅ | ✅ |
| Videos pinned to Home (`pin-videos-to-home.yml`) | Re-pins Videos to Home after recent-files cleanup hides it | ✅ | ❌ |
| Show files + extensions (`show-files.yml`) | Shows hidden/system files and file extensions (`Hidden = 1`, `HideFileExt = 0`) — QoL and security | ✅ | ❌ |
| No "- Shortcut" suffix (`remove-shortcut-text.yml`) | New shortcuts keep their clean name (`ShortcutNameTemplate = "%s.lnk"`) | ✅ | ❌ |
| No Store in Open With (`no-internet-open-with.yml`) | Hides "Look for an app in the Microsoft Store" in the Open With dialog (`NoUseStoreOpenWith = 1`) | ✅ | ❌ |
| No "Recently added" (`hide-recently-added-start-menu.yml`) | `HideRecentlyAddedApps = 1` in Start | ✅ | ✅ |
| Start recommendations off (`disable-start-recommendations.yml`) | No tips, shortcuts, new-app promos, account notifications (`Start_IrisRecommendations`, `Start_AccountNotifications`) | ✅ | ✅ |
| Setup suggestions off (`disable-scoobe.yml`) | No "Get even more out of Windows" prompt (`ScoobeSystemSettingEnabled = 0`) | ✅ | ❌ |
| Bing / web search off (`disable-bing-search.yml`) | No Bing, cloud search, location in search, no search suggestions | ✅ | ✅ |
| Aero Shake off (`disable-aero-shake.yml`) | `DisallowShaking = 1` | ✅ | ✅ |
| No network prompt (`disable-network-wizard.yml`) | Suppresses the network discoverability popup (`NewNetworkWindowOff`) | ✅ | ✅ |
| Meet Now hidden (`hide-meet-now.yml`) | Hides the Meet Now tray icon (`HideSCAMeetNow = 1`) | ✅ | ❌ |
| Security tray icon hidden (`hide-security-tray-icon.yml`) | Removes the Windows Security systray autostart (`SecurityHealth` Run value) | ✅ | ❌ |
| Mouse acceleration off (`disable-mouse-accel.yml`) | 1:1 movement (`MouseSpeed / Threshold1 / Threshold2 = 0`) | ✅ | ✅ |
| Instant menus (`disable-menu-delay.yml`) | `MenuShowDelay = 0` | ✅ | ✅ |
| No startup delay (`disable-startup-delay.yml`) | `StartupDelayInMSec = 0` | ✅ | ✅ |
| Fast shutdown (`decrease-shutdown-time.yml`) | `HungAppTimeout / WaitToKillApp / WaitToKillServiceTimeout = 2000` | ✅ | ✅ |
| Auto-download off (`disable-auto-updates.yml`) | WU `AUOptions = 2` (notify instead of auto-download) | ✅ | ✅ |
| Delivery Optimization off (`disable-delivery-optimization.yml`) | `DODownloadMode = 0`, no P2P upload | ✅ | ✅ |
| Store auto-updates off (`disable-store-auto-updates.yml`) | Manual Store updates (`AutoDownload = 2`) | ✅ | ❌ |
| Release pinned (`pin-windows-release.yml`) | `TargetReleaseVersion`, no silent feature upgrades | ✅ | ❌ |
| Updates paused (`pause-updates.yml`) | All update branches paused until `2077-01-01`, `FlightSettingsMaxPauseDays = 18400` | ✅ | ❌ |
| Dark appearance (`appearance.yml`) | Dark wallpaper + lockscreen via bundled dark theme file (dark mode and accent come from the theme file itself, no registry writes), lockscreen overlays off — on by default but skippable via checkbox 🔘 | 🔘 | ❌ |
| Lockscreen blur off (`disable-lockscreen-blur.yml`) | Sharp logon background (`DisableAcrylicBackgroundOnLogon = 1`) | ✅ | ✅ |
| OEM branding (`oem-info.yml`) | OEM model branded as `wtweaks` (Lite: `wtweaks lite`) | ✅ | ✅ |

## Security (Full only, Defender option)

| Tweak (task file) | What it does | Full | Lite |
|---|---|---|---|
| Defender removed (`disable-defender.yml`) | Installs the NoDefender CBS package via `Install-DefenderPackage.ps1` (TrustedInstaller, cert-checked) when Disable is chosen; uninstalls it back when Enable is chosen 🔘 | 🔘 | ❌ |
| Unused Security pages hidden (`hide-unused-security-pages.yml`) | Hides Family options, Device performance & health and Account protection pages (`UILockdown = 1`), applied together with Defender removal 🔘 | 🔘 | ❌ |

## Final

| Tweak (task file) | What it does | Full | Lite |
|---|---|---|---|
| Explorer restart (`restart-explorer.yml`) | Restarts Explorer so everything applies immediately | ✅ | ✅ |

## Counts

- Full: 50 tasks (all of the above, in `Configuration/main.yml` order).
- Lite: 25 tasks — Game Bar, search indexing, Content Delivery, Bing, the ✅ Lite rows above, PSReadLine and Explorer restart. No options pages, no reboot needed.

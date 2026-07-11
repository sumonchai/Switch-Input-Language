# AGENTS.md — Switch Input Language

## Project overview

Windows system-tray app. Press CapsLock → switch input language (EN↔TH). Hold CapsLock → toggle real Caps Lock.

- **Target:** Windows 10/11 x64, .NET Framework 4.8
- **UI:** WinForms `NotifyIcon` (tray only, no main window)
- **Language:** Thai + English; UI strings in Thai
- **Repo:** https://github.com/sumonchai/Switch-Input-Language

## Tech stack

| Layer | Tech |
|---|---|
| Runtime | .NET Framework 4.8 (net48-windows) |
| UI | WinForms |
| Hook | Low-level keyboard hook (`WH_KEYBOARD_LL`) via P/Invoke |
| Installer | Inno Setup 6 (`SwitchInputLanguage.iss`) |
| Version | `src/SwitchInputLanguage.csproj` → `<Version>` tag |
| Arch | x64 only (`<PlatformTarget>x64</PlatformTarget>`) |
| Manifest | `asInvoker` (no admin required) |

## File map

```
src/
  Program.cs          — Entry point. Single-instance mutex, tray icon + context menu, wires up hook
  KeyboardHook.cs     — Low-level keyboard hook, CapsLock capture, language switch, RDP passthrough
  Settings.cs         — Persists HoldMs (100-900ms) to %APPDATA%\SwitchInputLanguage\settings.txt
  SettingsForm.cs     — Simple slider dialog for HoldMs
  StartupHelper.cs    — Auto-start registry (HKCU\Run) + Startup folder shortcut
  UpdateChecker.cs    — GitHub API release check, shows "update available" dialog
  app.manifest        — asInvoker, uiAccess=false
  media/LJ LOGO.ico   — Tray icon
SwitchInputLanguage.iss  — Inno Setup 6 installer script
```

## Build

```bash
# Debug build
dotnet build src/SwitchInputLanguage.csproj

# Release publish → out/ folder (self-contained=false, single file)
dotnet publish src/SwitchInputLanguage.csproj -c Release -r win-x64 --self-contained false -o out

# Create installer (requires Inno Setup 6 installed)
& "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" SwitchInputLanguage.iss
# Output → dist/SwitchInputLanguage-Setup-{version}-x64.exe
```

The `out/` folder must contain:
- `SwitchInputLanguage.exe`
- `SwitchInputLanguage.exe.config`
- `media/LJ LOGO.ico`

The installer reads from `out/` and compiles to `dist/`. Both `out/` and `dist/` are gitignored.

## Architecture

### CapsLock lifecycle

1. `KeyboardHook` installs `WH_KEYBOARD_LL`, intercepts every keystroke
2. On CapsLock key-down: suppress it, start timer
3. On CapsLock key-up:
   - **Short press** (< `Settings.HoldMs` ms) → switch input language via `ActivateKeyboardLayout(HKL_NEXT)`
   - **Long press** (≥ `Settings.HoldMs` ms) → inject real CapsLock toggle via `SendInput`
4. Injected keystrokes are tagged with `extra = 0xCAFEF00D` marker; hook ignores its own injections

### Language switching

- Uses `HKL_NEXT` (value 1) to cycle through installed keyboard layouts
- Attaches thread input to foreground window's thread before switching
- Falls back to direct `ActivateKeyboardLayout` for desktop/taskbar (no foreground window)

### RDP/Remote Desktop passthrough

- Detects remote client processes by name: mstsc, msrdc, teamviewer, anydesk, rustdesk, parsec, etc.
- When remote is detected: short CapsLock → inject scancode-based `Win+Space` (bypasses injected-key filters like RustDesk's `LLKHF_INJECTED` filter)
- `KeyboardHook.IsForegroundRemoteDesktop()` cached 500ms to avoid repeated `GetForegroundWindow` calls

### Auto-start (StartupHelper.cs)

**Two methods, either is sufficient:**
1. **Registry:** `HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\SwitchInputLanguage` = `"<path>"` (primary)
2. **Shortcut:** `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\SwitchInputLanguage.lnk` (backup)

**Enable:** Returns true if **either** method succeeds (`regOk || lnkOk`).
**Disable:** Returns true only if **both** methods clean up (`regOk && lnkOk`).
**Check (`IsStartupEnabled`):** Validates the path in registry still exists (`File.Exists`), falls back to shortcut existence check.

The installer also offers a `[Tasks] StartupTask` option (line 47 in .iss) that writes the same registry value.

### Settings persistence

- File: `%APPDATA%\SwitchInputLanguage\settings.txt`
- Contains a single integer (100–900 ms)
- Default: 500ms
- Loaded at startup, saved when user clicks "ตกลง" in SettingsForm slider

### Update check

- Hits `https://api.github.com/repos/sumonchai/Switch-Input-Language/releases/latest`
- Parses `tag_name` and `browser_download_url` from JSON (simple string parsing, no JSON library)
- Compares against `Assembly.GetExecutingAssembly().GetName().Version`
- On update available: opens browser to download URL

## Versioning

Version is set in **three places** — keep all in sync:

| Location | Field |
|---|---|
| `src/SwitchInputLanguage.csproj` | `<Version>`, `<FileVersion>`, `<AssemblyVersion>` |
| `SwitchInputLanguage.iss` | `AppVersion`, `OutputBaseFilename` |
| Git tag | e.g. `v3.1.2` |

## Common issues

### Auto-start won't enable
- App runs as `asInvoker` → HKCU\Run should be writable without admin
- If `WScript.Shell` COM unavailable → shortcut creation fails silently, but registry method should still succeed
- Check: `RegistryEntryExists()` now validates the exe path exists, not just key presence

### Auto-start enabled but app doesn't start on boot
- Antivirus may block Run registry entries
- Path may be stale (moved/reinstalled to different folder) — `IsStartupEnabled` now catches this via `File.Exists`
- Windows 10/11 Task Manager "Startup" tab may show app as "Disabled"

### Double-launch
- Single-instance mutex `SwitchInputLanguage_SingleInstance` — second launch exits immediately
- Both registry Run + Startup folder shortcut can fire simultaneously; mutex handles it

### CapsLock not working
- If a remote desktop process is detected → CapsLock sends Win+Space scancodes instead of switching language directly
- `Passthrough` mode: CapsLock passes through untouched (tray menu toggle)
- `Paused` mode: CapsLock suppressed entirely (during Settings dialog)

## Installer (Inno Setup)

- `PrivilegesRequired=lowest` — installs per-user without admin
- Installs to `{autopf}\Switch Input Language` (typically `C:\Program Files\Switch Input Language`)
- Creates Start Menu shortcut, desktop shortcut, and optional auto-start registry entry
- Uninstall kills running process via `taskkill` before removing files
- Auto-silent-uninstalls previous version before installing (via `CurStepChanged` Pascal script)

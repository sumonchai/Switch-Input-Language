# Context — Switch Input Language

โปรเจค: เปลี่ยนภาษาด้วย CapsLock (EN↔TH) บน Windows 10/11 x64

## โฟลเดอร์

| โฟลเดอร์ | เนื้อหา |
|---|---|
| `src/` | source code .NET Framework 4.8 (WinForms) |
| `out/` | build output → เข้า installer (gitignore) |
| `dist/` | ไฟล์ setup.exe (gitignore) |
| `Files/` | รูปประกอบ installer (WizardImage) |

## ไฟล์สำคัญ

| ไฟล์ | หน้าที่ |
|---|---|
| `src/Program.cs` | จุดเริ่ม, tray icon, context menu, single-instance mutex |
| `src/KeyboardHook.cs` | จับ CapsLock ด้วย WH_KEYBOARD_LL, เปลี่ยนภาษา, RDP passthrough |
| `src/StartupHelper.cs` | Auto-start: Registry (HKCU\Run) + Startup shortcut |
| `src/Settings.cs` | อ่าน/เขียน HoldMs ลง %APPDATA%\SwitchInputLanguage\settings.txt |
| `src/SettingsForm.cs` | Dialog slider ตั้งค่า HoldMs (100-900ms) |
| `src/UpdateChecker.cs` | เช็คเวอร์ชันใหม่จาก GitHub Releases |
| `SwitchInputLanguage.iss` | Inno Setup 6 installer script |
| `AGENTS.md` | เอกสารเทคนิคเต็มสำหรับ AI agents |

## Build

```bash
# debug
dotnet build src/SwitchInputLanguage.csproj

# release → out/
dotnet publish src/SwitchInputLanguage.csproj -c Release -r win-x64 --self-contained false -o out

# setup → dist/
& "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" SwitchInputLanguage.iss
```

## เวอร์ชัน — ต้อง sync 3 ที่

1. `src/SwitchInputLanguage.csproj` → `<Version>`
2. `SwitchInputLanguage.iss` → `AppVersion` + `OutputBaseFilename`
3. Git tag → e.g. `v3.1.2`

## Auto-start

- ลงทะเบียนผ่าน Registry เท่านั้น: `HKCU\...\Run\SwitchInputLanguage`
- ไม่ใช้ Shortcut (ถอดออกเพราะ WScript.Shell COM มีปัญหา)
- `IsStartupEnabled`: เช็คค่าใน registry ว่ามีอยู่หรือเปล่า (ไม่ตรวจ File.Exists)

### กฎห้ามแก้ (CRITICAL)
- **ห้ามแก้ไข auto-start logic** เว้นแต่ user ร้องขอโดยตรง
- Registry อย่างเดียว (v3.1.1 ที่ใช้ได้) — ถ้าเปลี่ยนอะไรกลับมาเสียอีก

## ปัญหาบ่อย

- Auto-start ไม่ติดหลัง reboot → เช็ค Task Manager "Startup" tab, เช็ค path ใน registry
- CapsLock ไม่เปลี่ยนภาษา → ดูว่า foreground เป็น remote desktop ไหม (จะส่ง Win+Space แทน)
- RDP passthrough → ตรวจจับ process: mstsc, rustdesk, teamviewer, anydesk, etc.

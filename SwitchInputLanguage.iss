[Setup]
AppName=Switch Input Language
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppVersion=3.0.1
AppPublisher=LJ TECHNOLOGY
AppPublisherURL=https://github.com/sumonchai/Switch-Input-Language
AppSupportURL=https://github.com/sumonchai/Switch-Input-Language
AppUpdatesURL=https://github.com/sumonchai/Switch-Input-Language
VersionInfoCopyright=Copyright (C) LJ TECHNOLOGY
DefaultDirName={commonpf}\Switch Input Language
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
DefaultGroupName=Switch Input Language
AllowNoIcons=yes
Compression=lzma2/max
SolidCompression=yes
UninstallDisplayIcon={app}\SwitchInputLanguage.exe
TimeStampsInUTC=yes
TouchDate=none
TouchTime=00:00
OutputBaseFilename=SwitchInputLanguage-Setup-3.0.1-x64
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
SetupIconFile=src\media\LJ LOGO.ico
WizardImageFile=Files\WizModernImage-IS.bmp
WizardSmallImageFile=Files\WizModernSmallImage-IS.bmp

[Languages]
Name: english; MessagesFile: "compiler:Default.isl"

[Files]
Source: "src\bin\Release\net48-windows\SwitchInputLanguage.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "src\bin\Release\net48-windows\SwitchInputLanguage.exe.config"; DestDir: "{app}"; Flags: ignoreversion
Source: "src\media\LJ LOGO.ico"; DestDir: "{app}\media"; Flags: ignoreversion

[Icons]
; Start Menu shortcut
Name: "{group}\Switch Input Language"; Filename: "{app}\SwitchInputLanguage.exe"; IconFilename: "{app}\media\LJ LOGO.ico"
; Start Menu uninstall shortcut
Name: "{group}\Uninstall Switch Input Language"; Filename: "{uninstallexe}"

[Registry]
; Run at Windows startup (HKCU = ไม่ต้อง admin)
Root: HKCU; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "Switch Input Language"; ValueData: """{app}\SwitchInputLanguage.exe"""; Flags: uninsdeletevalue

[Tasks]
Name: StartAfterInstall; Description: "Run application after install"
Name: StartupTask; Description: "Start automatically with Windows"; GroupDescription: "Additional options:"

[Run]
Filename: "{app}\SwitchInputLanguage.exe"; Flags: shellexec skipifsilent nowait; Tasks: StartAfterInstall

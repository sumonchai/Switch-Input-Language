#define AppName    "Switch Input Language"
#define AppVersion "3.0.0"
#define AppExe     "SwitchInputLanguage.exe"
#define AppPublisher "LAO Work Space"

[Setup]
AppId={{A3F2C1D0-4B5E-4F6A-8C9D-1E2F3A4B5C6D}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisherURL=https://github.com/sumonchai/Switch-Input-Language
AppPublisher={#AppPublisher}
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
OutputDir=dist
OutputBaseFilename=SwitchInputLanguage_Setup_{#AppVersion}
SetupIconFile=src\media\LJ LOGO.ico
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
UninstallDisplayIcon={app}\{#AppExe}
DisableWelcomePage=no
DisableDirPage=no
DisableReadyPage=no
; ลบเวอร์ชันเก่าก่อนติดตั้ง
CloseApplications=yes
CloseApplicationsFilter=*{#AppExe}
RestartApplications=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "startup"; Description: "เริ่มทำงานอัตโนมัติเมื่อ Windows เปิด"; GroupDescription: "ตัวเลือกเพิ่มเติม:"; Flags: unchecked

[Files]
Source: "src\bin\Release\net48-windows\{#AppExe}"; DestDir: "{app}"; Flags: ignoreversion
Source: "src\bin\Release\net48-windows\{#AppExe}.config"; DestDir: "{app}"; Flags: ignoreversion
Source: "src\bin\Release\net48-windows\media\LJ LOGO.ico"; DestDir: "{app}\media"; Flags: ignoreversion

[Icons]
; Desktop shortcut เท่านั้น — ไม่สร้าง Start Menu
Name: "{userdesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"

[Registry]
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "{#AppName}"; ValueData: """{app}\{#AppExe}"""; Flags: uninsdeletevalue; Tasks: startup

[Run]
Filename: "{app}\{#AppExe}"; Description: "เปิดโปรแกรม"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "taskkill"; Parameters: "/IM {#AppExe} /F"; Flags: runhidden; RunOnceId: "KillApp"

[Code]
// ลบ version เก่าก่อนติดตั้ง
procedure CurStepChanged(CurStep: TSetupStep);
var
  UninstPath: String;
  UninstExe:  String;
  ResultCode: Integer;
begin
  if CurStep = ssInstall then
  begin
    UninstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#SetupSetting("AppId")}_is1');
    if RegQueryStringValue(HKCU, UninstPath, 'UninstallString', UninstExe) or
       RegQueryStringValue(HKLM, UninstPath, 'UninstallString', UninstExe) then
    begin
      Exec(RemoveQuotes(UninstExe), '/SILENT /NORESTART', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    end;
  end;
end;

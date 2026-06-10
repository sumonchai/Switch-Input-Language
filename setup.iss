#define AppName    "Switch Input Language"
#define AppVersion "3.1.0"
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
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
CloseApplications=yes
CloseApplicationsFilter=*{#AppExe}
RestartApplications=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "startup"; Description: "เริ่มทำงานอัตโนมัติเมื่อ Windows เปิด"; GroupDescription: "ตัวเลือกเพิ่มเติม:"; Flags: unchecked

[Files]
Source: "out\{#AppExe}"; DestDir: "{app}"; Flags: ignoreversion
Source: "out\{#AppExe}.config"; DestDir: "{app}"; Flags: ignoreversion
Source: "out\media\LJ LOGO.ico"; DestDir: "{app}\media"; Flags: ignoreversion

[Icons]
Name: "{userdesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExe}"; IconFilename: "{app}\media\LJ LOGO.ico"
Name: "{group}\Uninstall {#AppName}"; Filename: "{uninstallexe}"

[Registry]
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "{#AppName}"; ValueData: """{app}\{#AppExe}"""; Flags: uninsdeletevalue; Tasks: startup

[Run]
Filename: "{app}\{#AppExe}"; Description: "เปิดโปรแกรม"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "taskkill"; Parameters: "/IM {#AppExe} /F"; Flags: runhidden; RunOnceId: "KillApp"

[Code]
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

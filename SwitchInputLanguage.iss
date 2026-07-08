[Setup]
AppName=Switch Input Language
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppVersion=3.1.2
AppPublisher=LXRJ
AppPublisherURL=https://github.com/sumonchai/Switch-Input-Language
AppSupportURL=https://github.com/sumonchai/Switch-Input-Language
AppUpdatesURL=https://github.com/sumonchai/Switch-Input-Language
VersionInfoCopyright=Copyright (C) LJ TECHNOLOGY
DefaultDirName={autopf}\Switch Input Language
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
OutputDir=dist
OutputBaseFilename=SwitchInputLanguage-Setup-3.1.2-x64
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
SetupIconFile=src\media\LJ LOGO.ico
WizardImageFile=Files\WizModernImage-IS.bmp
WizardSmallImageFile=Files\WizModernSmallImage-IS.bmp

[Languages]
Name: english; MessagesFile: "compiler:Default.isl"

[Files]
Source: "out\SwitchInputLanguage.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "out\SwitchInputLanguage.exe.config"; DestDir: "{app}"; Flags: ignoreversion
Source: "out\media\LJ LOGO.ico"; DestDir: "{app}\media"; Flags: ignoreversion

[Icons]
Name: "{group}\Switch Input Language"; Filename: "{app}\SwitchInputLanguage.exe"; IconFilename: "{app}\media\LJ LOGO.ico"
Name: "{group}\Uninstall Switch Input Language"; Filename: "{uninstallexe}"
Name: "{userdesktop}\Switch Input Language"; Filename: "{app}\SwitchInputLanguage.exe"

[Registry]
Root: HKCU; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "SwitchInputLanguage"; ValueData: """{app}\SwitchInputLanguage.exe"""; Flags: uninsdeletevalue; Tasks: StartupTask

[Tasks]
Name: StartAfterInstall; Description: "Run application after install"
Name: StartupTask; Description: "Start automatically with Windows"; GroupDescription: "Additional options:"

[Run]
Filename: "{app}\SwitchInputLanguage.exe"; Flags: shellexec skipifsilent nowait; Tasks: StartAfterInstall

[UninstallRun]
Filename: "taskkill"; Parameters: "/IM SwitchInputLanguage.exe /F"; Flags: runhidden; RunOnceId: "KillApp"

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

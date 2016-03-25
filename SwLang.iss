
[Setup]
AppName=Switch Input Language
AppVersion=0.1 Beta
DefaultDirName={pf}\Switch Input Language
DefaultGroupName=Switch Input Language
UninstallDisplayIcon={app}\swlang.exe
;OutputDir=userdocs:Switch Input Language Output
InfoBeforeFile=Readme.txt
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin


[Files]
Source: "swlang.exe"; DestDir: "{app}"
Source: "InputLang.exe"; DestDir: "{app}"
;Source: "Readme.txt"; DestDir: "{app}"; Flags: isreadme

[Icons]
Name: "{group}\Switch Input Language"; Filename: "{app}\swlang.exe"

[Run]
Filename: "{app}\swlang.exe"

; NOTE: Most apps do not need registry entries to be pre-created. If you
; don't know what the registry is or if you need to use it, then chances are
; you don't need a [Registry] section.

[Registry]
; Start "Software\My Company\My Program" keys under HKEY_CURRENT_USER
; and HKEY_LOCAL_MACHINE. The flags tell it to always delete the
; "My Program" keys upon uninstall, and delete the "My Company" keys
; if there is nothing left in them.
Root: HKCU; Subkey: "Software\LJ TECHNOLOGY"; Flags: uninsdeletekeyifempty
Root: HKCU; Subkey: "Software\LJ TECHNOLOGY\Switch Input Language"; Flags: uninsdeletekey
;Root: HKLM; Subkey: "Software\LJ TECHNOLOGY"; Flags: uninsdeletekeyifempty
Root: HKLM64; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "Switch Input Language"; ValueData: """{app}\InputLang.exe"""; Flags: uninsdeletevalue
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "Switch Input Language"; ValueData: """{app}\InputLang.exe"""; Flags: uninsdeletevalue




#define MyAppName "Switch Input Language"
#define MyAppExeName "InputLang.exe"

[Code]
function InitializeUninstall(): Boolean;
  var ErrorCode: Integer;
begin
  ShellExec('open','taskkill.exe','/f /im {#MyAppExeName}','',SW_HIDE,ewNoWait,ErrorCode);
  ShellExec('open','taskill.exe',' {#MyAppName}','',SW_HIDE,ewNoWait,ErrorCode);
  result := True;
end;

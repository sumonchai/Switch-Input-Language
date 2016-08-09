[Setup]
AppName=Switch Input Language
AppId=Switch Input Language
AppVersion=1.1
AppPublisher=jrsoftware.org
AppPublisherURL=https://github.com/sumonchai/Switch-Input-Language
AppSupportURL=https://github.com/sumonchai/Switch-Input-Language
AppUpdatesURL=https://github.com/sumonchai/Switch-Input-Language
VersionInfoCopyright=Copyright (C) 2016 LJTECHNOLOGY
;AppMutex=InnoSetupCompilerAppMutex,Global\InnoSetupCompilerAppMutex
;SetupMutex=InnoSetupCompilerSetupMutex,Global\InnoSetupCompilerSetupMutex
;MinVersion=0,5.0
DefaultDirName={pf}\Switch Input Language
DefaultGroupName=Switch Input Language
AllowNoIcons=yes
Compression=lzma2/max
SolidCompression=yes
;Uninstallable=not PortableCheck
UninstallDisplayIcon={app}\WIN 10.exe
LicenseFile=readme.txt
TimeStampsInUTC=yes
TouchDate=none
TouchTime=00:00
WizardImageFile=compiler:WizModernImage-IS.bmp
WizardSmallImageFile=compiler:WizModernSmallImage-IS.bmp
#ifndef NOSIGNTOOL
;SignTool=issigntool
;SignTool=issigntool256
;SignedUninstaller=yes
#endif

[Languages]
Name: english; MessagesFile: "files\Default.isl"

#sub ProcessFoundFile
  #define FileName FindGetFileName(FindHandle)
  #define Name LowerCase(RemoveFileExt(FileName))
  #define MessagesFile PathName + FileName
  #pragma message "Generating [Languages] entry with name " + Name
  Name: {#Name}; MessagesFile: {#MessagesFile}
#endsub

#define PathName "files\Languages\"
#define FindHandle
#define FindResult

#for {FindHandle = FindResult = FindFirst(PathName + "*.isl", 0); FindResult; FindResult = FindNext(FindHandle)} ProcessFoundFile
#if FindHandle
  #expr FindClose(FindHandle)
#endif
#ifdef UNICODE
  #for {FindHandle = FindResult = FindFirst(PathName + "*.islu", 0); FindResult; FindResult = FindNext(FindHandle)} ProcessFoundFile
  #if FindHandle
    #expr FindClose(FindHandle)
  #endif
#endif

[Messages]
; two "Setup" on the same line looks weird, so put a line break in between
english.WelcomeLabel1=Welcome to Switch Input Language%nSetup Wizard

[InstallDelete]
; Remove Unicode-only files if needed
Type: files; Name: "{app}\WIN 10.exe"


[Files]
Source: "WIN 10.exe"; DestDir: "{app}"; Flags: ignoreversion signonce touch

[Icons]
Name: "{group}\Switch Input Language"; Filename: "{app}\WIN 10.exe"


[Registry]
; Start "Software\My Company\My Program" keys under HKEY_CURRENT_USER
; and HKEY_LOCAL_MACHINE. The flags tell it to always delete the
; "My Program" keys upon uninstall, and delete the "My Company" keys
; if there is nothing left in them.
;Root: HKCU; Subkey: "Software\LJ TECHNOLOGY"; Flags: uninsdeletekeyifempty
;Root: HKCU; Subkey: "Software\LJ TECHNOLOGY\Switch Input Language"; Flags: uninsdeletekey
;Root: HKLM; Subkey: "Software\LJ TECHNOLOGY"; Flags: uninsdeletekeyifempty
;Root: HKLM64; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "Switch Input Language"; ValueData: """{app}\InputLang.exe"""; Flags: uninsdeletevalue
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "Switch Input Language"; ValueData: """{app}\WIN 10.exe"""; Flags: uninsdeletevalue

[Tasks]
Name: StartAfterInstall; Description: Run application after install

[Run]
Filename: {app}\WIN 10.exe; Flags: shellexec skipifsilent nowait; Tasks: StartAfterInstall

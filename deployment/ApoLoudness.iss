; Inno Setup Script for ApoLoudness
; Requires Inno Setup 6.x

#define MyAppName "ApoLoudness"
#define MyAppVersion "0.3.1"
#define MyAppPublisher "ApoLoudness Project"
#define MyAppURL "https://github.com/grisys83/APO-Loudness"
#define MyAppExeName "ApoLoudness.exe"
#define MyAppCalibrationExeName "ApoLoudnessCalibration.exe"

[Setup]
AppId={{8F7A9B2C-4E3D-4A6F-B1C9-2D8E7F4A5B3C}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
LicenseFile=..\LICENSE
OutputDir=.
OutputBaseFilename=ApoLoudness_v{#MyAppVersion}_Setup
SetupIconFile=..\ApoLoudness.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1; Check: not IsAdminInstallMode

[Files]
; Main executables
Source: "ApoLoudness\ApoLoudness.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "ApoLoudness\ApoLoudnessCalibration.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "ApoLoudness\calibration.ini"; DestDir: "{app}"; Flags: ignoreversion

; Qt6 Core DLLs
Source: "ApoLoudness\Qt6Core.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "ApoLoudness\Qt6Gui.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "ApoLoudness\Qt6Widgets.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "ApoLoudness\Qt6Multimedia.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "ApoLoudness\Qt6Network.dll"; DestDir: "{app}"; Flags: ignoreversion

; MinGW Runtime DLLs
Source: "ApoLoudness\libgcc_s_seh-1.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "ApoLoudness\libstdc++-6.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "ApoLoudness\libwinpthread-1.dll"; DestDir: "{app}"; Flags: ignoreversion

; Qt Plugins
Source: "ApoLoudness\platforms\*"; DestDir: "{app}\platforms"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "ApoLoudness\styles\*"; DestDir: "{app}\styles"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "ApoLoudness\imageformats\*"; DestDir: "{app}\imageformats"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "ApoLoudness\multimedia\*"; DestDir: "{app}\multimedia"; Flags: ignoreversion recursesubdirs createallsubdirs

; Documentation
Source: "ApoLoudness\README.txt"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{#MyAppName} Calibration"; Filename: "{app}\{#MyAppCalibrationExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
function InitializeSetup(): Boolean;
var
  ResultCode: Integer;
begin
  Result := True;
  
  // Check if EqualizerAPO is installed
  if not FileExists('C:\Program Files\EqualizerAPO\config\config.txt') then
  begin
    if MsgBox('EqualizerAPO is not detected on your system.' + #13#10 + 
              'ApoLoudness requires EqualizerAPO to function properly.' + #13#10 + #13#10 +
              'Do you want to continue anyway?', mbConfirmation, MB_YESNO) = IDNO then
    begin
      Result := False;
    end;
  end;
end;
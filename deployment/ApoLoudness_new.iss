; Inno Setup Script for ApoLoudness
; Requires Inno Setup 6.x

#define MyAppName "ApoLoudness"
#define MyAppVersion "0.3.1"
#define MyAppPublisher "ApoLoudness Project"
#define MyAppURL "https://github.com/grisys83/APO-Loudness"
#define MyAppExeName "ApoLoudness.exe"
#define MyAppCalibrationExeName "ApoLoudnessCalibration.exe"
#define EqualizerAPOPath "C:\Program Files\EqualizerAPO"

[Setup]
AppId={{8F7A9B2C-4E3D-4A6F-B1C9-2D8E7F4A5B3C}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={#EqualizerAPOPath}\config\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
LicenseFile=..\LICENSE
OutputDir=.
OutputBaseFilename=ApoLoudness_v{#MyAppVersion}_Setup
SetupIconFile=ApoLoudness_Setup.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequired=admin
DisableDirPage=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1

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
Source: "ApoLoudness\imageformats\*"; DestDir: "{app}\imageformats"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "ApoLoudness\multimedia\*"; DestDir: "{app}\multimedia"; Flags: ignoreversion recursesubdirs createallsubdirs

; Documentation
Source: "ApoLoudness\README.txt"; DestDir: "{app}"; Flags: ignoreversion

; Filter files (will be installed based on user selection)
; 44.1kHz filters
Source: "D:\FIR-Filter-Maker-for-Equal-Loudness--Loudness\bulk_filters\*.wav"; DestDir: "{#EqualizerAPOPath}\config\Filters"; Flags: ignoreversion; Check: Is441kHzSelected
; 48.0kHz filters - already exist in the destination, so no need to copy

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{#MyAppName} Calibration"; Filename: "{app}\{#MyAppCalibrationExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
var
  SampleRatePage: TInputOptionWizardPage;
  DetectedSampleRate: Integer;
  
// External Windows API declarations
function waveOutGetNumDevs: Integer;
  external 'waveOutGetNumDevs@winmm.dll stdcall';

type
  WAVEOUTCAPS = record
    wMid: Word;
    wPid: Word;
    vDriverVersion: DWORD;
    szPname: array[0..31] of Char;
    dwFormats: DWORD;
    wChannels: Word;
    wReserved1: Word;
    dwSupport: DWORD;
  end;

function waveOutGetDevCaps(uDeviceID: UINT; var pwoc: WAVEOUTCAPS; cbwoc: UINT): UINT;
  external 'waveOutGetDevCapsA@winmm.dll stdcall';

const
  WAVE_FORMAT_44M16 = $00000400;  // 44.1 kHz, Mono, 16-bit
  WAVE_FORMAT_44S16 = $00000800;  // 44.1 kHz, Stereo, 16-bit
  WAVE_FORMAT_48M16 = $00001000;  // 48 kHz, Mono, 16-bit
  WAVE_FORMAT_48S16 = $00002000;  // 48 kHz, Stereo, 16-bit

function DetectDefaultSampleRate(): Integer;
var
  NumDevices: Integer;
  DeviceCaps: WAVEOUTCAPS;
  i: Integer;
  Has44kHz: Boolean;
  Has48kHz: Boolean;
begin
  Result := 48000; // Default to 48kHz
  Has44kHz := False;
  Has48kHz := False;
  
  NumDevices := waveOutGetNumDevs();
  
  if NumDevices > 0 then
  begin
    // Check first (default) device
    if waveOutGetDevCaps(0, DeviceCaps, SizeOf(DeviceCaps)) = 0 then
    begin
      // Check supported formats
      if (DeviceCaps.dwFormats and (WAVE_FORMAT_44M16 or WAVE_FORMAT_44S16)) <> 0 then
        Has44kHz := True;
      if (DeviceCaps.dwFormats and (WAVE_FORMAT_48M16 or WAVE_FORMAT_48S16)) <> 0 then
        Has48kHz := True;
        
      // Prefer 48kHz if both are supported
      if Has48kHz then
        Result := 48000
      else if Has44kHz then
        Result := 44100;
    end;
  end;
end;

function Is441kHzSelected(): Boolean;
begin
  Result := (SampleRatePage <> nil) and SampleRatePage.Values[0];
end;

function Is480kHzSelected(): Boolean;
begin
  Result := (SampleRatePage <> nil) and SampleRatePage.Values[1];
end;

procedure InitializeWizard();
begin
  // Detect sample rate
  DetectedSampleRate := DetectDefaultSampleRate();
  
  // Create custom page for sample rate selection
  SampleRatePage := CreateInputOptionPage(wpSelectTasks,
    'Select Audio Sample Rate',
    'Which sample rate filters should be installed?',
    'Your system appears to be using ' + IntToStr(DetectedSampleRate) + ' Hz. ' +
    'Please confirm or select the appropriate sample rate for your audio device:',
    True, False);
    
  SampleRatePage.Add('44.1 kHz (44100 Hz) - Common for music/CD audio');
  SampleRatePage.Add('48.0 kHz (48000 Hz) - Common for video/professional audio');
  
  // Pre-select based on detection
  if DetectedSampleRate = 44100 then
    SampleRatePage.Values[0] := True
  else
    SampleRatePage.Values[1] := True;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  
  if CurPageID = SampleRatePage.ID then
  begin
    // Ensure at least one option is selected
    if not (SampleRatePage.Values[0] or SampleRatePage.Values[1]) then
    begin
      MsgBox('Please select at least one sample rate option.', mbError, MB_OK);
      Result := False;
    end;
  end;
end;

function InitializeSetup(): Boolean;
begin
  Result := True;
  
  // Check if EqualizerAPO is installed
  if not FileExists(ExpandConstant('{#EqualizerAPOPath}\config\config.txt')) then
  begin
    MsgBox('EqualizerAPO is not detected on your system.' + #13#10 + 
          'ApoLoudness requires EqualizerAPO to function properly.' + #13#10 + #13#10 +
          'Please install EqualizerAPO first from: https://equalizerapo.com', 
          mbError, MB_OK);
    Result := False;
  end;
end;

procedure UpdateEqualizerAPOConfig();
var
  ConfigFile: String;
  ConfigContent: TArrayOfString;
  NewContent: TStringList;
  i: Integer;
  FoundInclude: Boolean;
  IncludeLine: String;
begin
  ConfigFile := ExpandConstant('{#EqualizerAPOPath}\config\config.txt');
  IncludeLine := 'Include: ApoLoudness\ApoLoudness.txt';
  FoundInclude := False;
  
  if FileExists(ConfigFile) then
  begin
    // Load existing config
    LoadStringsFromFile(ConfigFile, ConfigContent);
    NewContent := TStringList.Create;
    
    try
      // Check if our include already exists
      for i := 0 to GetArrayLength(ConfigContent) - 1 do
      begin
        NewContent.Add(ConfigContent[i]);
        if Pos('Include: ApoLoudness', ConfigContent[i]) > 0 then
          FoundInclude := True;
      end;
      
      // Add our include if not found
      if not FoundInclude then
      begin
        NewContent.Add('');
        NewContent.Add('# ApoLoudness Equal Loudness Filter');
        NewContent.Add(IncludeLine);
        
        // Save updated config
        SaveStringToFile(ConfigFile, NewContent.Text, False);
      end;
    finally
      NewContent.Free;
    end;
  end;
end;

procedure CreateApoLoudnessConfig();
var
  ConfigFile: String;
  ConfigContent: TStringList;
  FilterPath: String;
begin
  ConfigFile := ExpandConstant('{app}\ApoLoudness.txt');
  ConfigContent := TStringList.Create;
  
  try
    FilterPath := ExpandConstant('{#EqualizerAPOPath}\config\Filters\');
    
    ConfigContent.Add('# ApoLoudness Configuration');
    ConfigContent.Add('# This file is included by EqualizerAPO');
    ConfigContent.Add('');
    ConfigContent.Add('# Equal Loudness Convolution Filter');
    ConfigContent.Add('# The filter file will be selected by ApoLoudness.exe based on current volume');
    ConfigContent.Add('# Default filter (you can change this in ApoLoudness.exe):');
    ConfigContent.Add('Convolution: ' + FilterPath + '40.0-80.0_filter.wav');
    
    SaveStringToFile(ConfigFile, ConfigContent.Text, False);
  finally
    ConfigContent.Free;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    // Create ApoLoudness config file
    CreateApoLoudnessConfig();
    
    // Update EqualizerAPO config.txt
    UpdateEqualizerAPOConfig();
  end;
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  FilterSource441: String;
  FilterSource480: String;
begin
  Result := '';
  
  // Verify filter source directories exist
  if Is441kHzSelected() then
  begin
    FilterSource441 := 'D:\FIR-Filter-Maker-for-Equal-Loudness--Loudness\bulk_filters';
    if not DirExists(FilterSource441) then
    begin
      Result := 'Cannot find 44.1kHz filter files at: ' + FilterSource441;
      Exit;
    end;
  end;
  
  if Is480kHzSelected() then
  begin
    FilterSource480 := 'C:\Program Files\EqualizerAPO\config\Filters';
    if not DirExists(FilterSource480) then
    begin
      Result := 'Cannot find 48.0kHz filter files at: ' + FilterSource480;
      Exit;
    end;
  end;
end;
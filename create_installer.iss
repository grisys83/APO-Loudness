; Inno Setup Script for ApoLoudness v0.3.5

#define MyAppName "ApoLoudness"
#define MyAppVersion "0.3.5"
#define MyAppPublisher "grisys"
#define MyAppURL "https://github.com/grisys83/APO-Loudness"
#define MyAppExeName "ApoLoudness.exe"
#define MyAppCalibrationExeName "ApoLoudnessCalibration.exe"

[Setup]
AppId={{8B7A9F4E-5C1D-4A2B-9E3F-6D8C7B5A4F3E}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} v{#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={commonpf}\EqualizerAPO\config\ApoLoudness
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
LicenseFile=LICENSE
InfoBeforeFile=README.txt
OutputDir=deployment
OutputBaseFilename=ApoLoudness_v{#MyAppVersion}_Setup
SetupIconFile=ApoLoudness.ico
Compression=lzma2/max
SolidCompression=yes
PrivilegesRequired=admin
ArchitecturesInstallIn64BitMode=x64
DisableProgramGroupPage=yes
UninstallDisplayIcon={app}\{#MyAppExeName}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Messages]
BeveledLabel=ApoLoudness v{#MyAppVersion}

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "includeconfig"; Description: "Add to Equalizer APO config.txt"; GroupDescription: "Configuration:"; Flags: checked

[Files]
; Main executables
Source: "deployment\v{#MyAppVersion}\bin\ApoLoudness.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "deployment\v{#MyAppVersion}\bin\ApoLoudnessCalibration.exe"; DestDir: "{app}"; Flags: ignoreversion

; Qt dependencies (deployed by windeployqt)
Source: "deployment\v{#MyAppVersion}\bin\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

; Documentation
Source: "deployment\v{#MyAppVersion}\README.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "deployment\v{#MyAppVersion}\LICENSE"; DestDir: "{app}"; Flags: ignoreversion
Source: "deployment\v{#MyAppVersion}\RELEASE_NOTES_v{#MyAppVersion}.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "deployment\v{#MyAppVersion}\docs\README.md"; DestDir: "{app}\docs"; Flags: ignoreversion

; Configuration files
Source: "deployment\v{#MyAppVersion}\bin\calibration.ini"; DestDir: "{app}"; Flags: ignoreversion onlyifdoesntexist

; Sample ApoLoudness.txt (will be created by the application)
Source: "deployment\ApoLoudness.txt.sample"; DestDir: "{app}"; Flags: ignoreversion skipifsourcedoesntexist

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{#MyAppName} Calibration"; Filename: "{app}\{#MyAppCalibrationExeName}"
Name: "{group}\Documentation"; Filename: "{app}\README.txt"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
Filename: "{app}\{#MyAppCalibrationExeName}"; Description: "Launch Calibration Tool"; Flags: nowait postinstall skipifsilent unchecked

[Code]
var
  SampleRatePage: TInputOptionWizardPage;
  
procedure InitializeWizard;
begin
  SampleRatePage := CreateInputOptionPage(wpSelectDir,
    'Audio Sample Rate Selection', 'Select your audio device sample rate',
    'ApoLoudness needs to know your audio sample rate to install the correct filters. ' +
    'Most modern systems use 48000 Hz, but some use 44100 Hz.',
    True, False);
    
  SampleRatePage.Add('48000 Hz (Recommended for most systems)');
  SampleRatePage.Add('44100 Hz');
  
  // Default to 48000 Hz
  SampleRatePage.Values[0] := True;
end;

function GetSampleRate: String;
begin
  if SampleRatePage.Values[0] then
    Result := '48000'
  else
    Result := '44100';
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ConfigFile: String;
  ConfigContent: TStringList;
  IncludeLine: String;
  LineFound: Boolean;
  i: Integer;
begin
  if CurStep = ssPostInstall then
  begin
    // Update Equalizer APO config if requested
    if IsTaskSelected('includeconfig') then
    begin
      ConfigFile := ExpandConstant('{commonpf}\EqualizerAPO\config\config.txt');
      if FileExists(ConfigFile) then
      begin
        ConfigContent := TStringList.Create;
        try
          ConfigContent.LoadFromFile(ConfigFile);
          
          // Check if already included
          IncludeLine := 'Include: ApoLoudness\ApoLoudness.txt';
          LineFound := False;
          
          for i := 0 to ConfigContent.Count - 1 do
          begin
            if Pos('Include: ApoLoudness', ConfigContent[i]) > 0 then
            begin
              LineFound := True;
              Break;
            end;
          end;
          
          if not LineFound then
          begin
            ConfigContent.Add('');
            ConfigContent.Add('# ApoLoudness - Equal-loudness volume control');
            ConfigContent.Add(IncludeLine);
            ConfigContent.SaveToFile(ConfigFile);
          end;
        finally
          ConfigContent.Free;
        end;
      end;
    end;
    
    // Create settings.ini with selected sample rate
    ConfigContent := TStringList.Create;
    try
      ConfigContent.Add('SampleRate=' + GetSampleRate);
      ConfigContent.SaveToFile(ExpandConstant('{app}\settings.ini'));
    finally
      ConfigContent.Free;
    end;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  ConfigFile: String;
  ConfigContent: TStringList;
  i: Integer;
begin
  if CurUninstallStep = usUninstall then
  begin
    // Remove from Equalizer APO config
    ConfigFile := ExpandConstant('{commonpf}\EqualizerAPO\config\config.txt');
    if FileExists(ConfigFile) then
    begin
      ConfigContent := TStringList.Create;
      try
        ConfigContent.LoadFromFile(ConfigFile);
        
        // Remove ApoLoudness lines
        for i := ConfigContent.Count - 1 downto 0 do
        begin
          if (Pos('ApoLoudness', ConfigContent[i]) > 0) or
             (Pos('Equal-loudness volume control', ConfigContent[i]) > 0) then
          begin
            ConfigContent.Delete(i);
          end;
        end;
        
        ConfigContent.SaveToFile(ConfigFile);
      finally
        ConfigContent.Free;
      end;
    end;
  end;
end;
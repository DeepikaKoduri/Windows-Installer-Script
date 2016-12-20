#include "Defaults.iss"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{838E3AF3-F90B-4B76-AB2E-BCAE9D9334BE}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yesAppendDefaultDirName=no
OutputBaseFilename={#InstallerName}
Compression=lzma
SolidCompression=yes
DefaultDirName={code:GetDir}DisableDirPage=yes
UninstallFilesDir={code:GetDir}\modules\{#AppFolder}\

[Registry]
Root: HKLM64; Subkey: "Software\{#CompanyName}\{#MyAppName}"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\{#CompanyName}\{#MyAppName}"; Flags: uninsdeletekey
Root : HKLM64; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppName}"; ValueType: string; ValueName: "InstallPath"; ValueData:{code:GetDir}; Flags: uninsdeletekey
Root : HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppName}"; ValueType: string; ValueName: "InstallPath"; ValueData:{code:GetDir}; Flags: uninsdeletekey

[Code]
var
  DataDirPage: TInputDirWizardPage;
  userInput : String;  CSinstallpath : String;
  location : String;

function isCSinstalled(Default: String) : String;
var
  InstallPath: String;
begin
  CSinstallpath := '';
  if RegQueryStringValue(HKLM, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#CoreAppName}', 'InstallLocation', InstallPath) then
    begin
     CSinstallpath := InstallPath;
    end
  else if RegQueryStringValue(HKLM64, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#CoreAppName}', 'InstallLocation', InstallPath) then
    begin
     CSinstallpath := InstallPath;
    end;
   Result := CSinstallpath;
end;

function GetDir(Default:String) : String;
begin
    Result:= ExpandConstant('{pf}');
    if(userInput <> '') then
    begin
      Result := userInput
    end;
end;

function InitializeSetup(): boolean;
begin
  Result := true;
  if (RegKeyExists(HKLM, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppName}') or RegKeyExists(HKLM64, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppName}') ) then
    begin
        MsgBox('{#CompanyName} {#MyAppName} is already installed', mbInformation, MB_OK);
        Result := false;
    end;
end;

procedure InitializeWizard;
begin
  userInput := ExpandConstant('{pf}');
  CSinstallpath := '';
  location := isCSinstalled('') ;

  if(location='') then
    begin
         location := ExpandConstant('{pf}');
    end;

  DataDirPage := CreateInputDirPage(wpSelectDir,
  '{#MyAppName} Setup', '',
  'Choose Destination Location',
  False, 'New Folder');
  DataDirPage.Add('Destination Location');
  DataDirPage.Values[0] := location+'\..\';
 end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  if Assigned(DataDirPage) then
    begin
    if CurPageID = DataDirPage.ID then
      begin
        if DataDirPage.Values[0]= '' then
          begin
            MsgBox('You must enter Destination Location .', mbError, MB_OK);
            Result :=False;
          end
        else
          begin
            userInput := DataDirPage.Values[0];
          end;
      end;
   end;
end;

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
;NOTE : Alter this section accordingly

Source: "..\modules\{#AppFolder}\*"; DestDir: "{code:GetDir}\modules\{#AppFolder}\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\mod_data\config\{#AppFolder}\*"; DestDir: "{code:GetDir}\mod_data\config\{#AppFolder}\"; Flags: ignoreversion recursesubdirs createallsubdirs

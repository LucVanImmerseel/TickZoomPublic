; Script generated by the HM NIS Edit Script Wizard.
!include WordFunc.nsh
!insertmacro VersionCompare
;!include LogicLib.nsh

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "TickZOOM"
; !define PRODUCT_VERSION "0.0.0.0"
!define PRODUCT_PUBLISHER "TickZOOM"
!define PRODUCT_WEB_SITE "http://www.tickzoom.org"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\TickZoomGUI.exe ${PRODUCT_VERSION}"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME} ${PRODUCT_VERSION}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define NSIS

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "license.rtf"
; Directory page
;!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\TickZoomGUI.exe"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "TZGuiSetup-${PRODUCT_VERSION}.exe"
InstallDir "$PROGRAMFILES\TickZOOM\${PRODUCT_VERSION}\TickZOOM Application"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show
var DOCDIR

Section 'NET Framework 3.5 SP1' SEC01
    SetOutPath '$INSTDIR'
    LogSet on
    SetOverwrite on
    Pop $1
    
    ;registry
    ReadRegDWORD $0 HKLM 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5' Install

    LogText "NET Framework Registry Version $0"
    ${If} $0 == 1
          DetailPrint '..NET Framework 3.5 already installed.'
    ${Else}

        ;options
      inetc::get /RESUME "Your internet connection seems to have dropped out!\nPlease reconnect and click Retry to resume downloading..." /caption "Downloading .NET Framework 3.5" /canceltext "Cancel" "http://www.tickzoom.org/chrome/site/dotnetfx35.exe" "$INSTDIR\dotnetfx35.exe" /end
      ${If} $1 != "OK"
        DetailPrint "Download of .NET Framework 3.5 failed: $1"
        Abort "Installation Canceled."
      ${EndIf}

      ;file work
      ExecWait "$INSTDIR\dotnetfx35.exe /quiet /norestart" $0
      DetailPrint "..NET Framework 3.5 SP1 exit code = $0"

    ${EndIf}

SectionEnd

Section "TickZOOM Application" SEC02
  SetOutPath "$INSTDIR"
  LogSet on
  SetOverwrite try

  File "..\bin\Release\TickZoomAPI1.0.dll"
  File "..\bin\Release\TickZoomAPI1.0.pdb"
  File "..\bin\Release\TickZoomCommon.dll"
  File "..\bin\Release\TickZoomCommon.pdb"
  File "..\bin\Release\TickZoomCommunication.dll"
  File "..\bin\Release\TickZoomCommunication.pdb"
  File "..\Engine\TickZoomEngine.dll"
  File "..\bin\Release\TickZoomGUI.exe"
  File "..\bin\Release\TickZoomGUI.pdb"
  File "..\bin\Release\TickZoomGUI.exe.config"
  File "GUI\DockPanel.config"
  File "..\bin\Release\TickZoomGUI2.exe"
  File "..\bin\Release\TickZoomGUI2.pdb"
  File "..\bin\Release\TickZoomGUI2.exe.config"
  File "..\bin\Release\WeifenLuo.WinFormsUI.Docking.dll"
  File "..\bin\Release\WeifenLuo.WinFormsUI.Docking.pdb"
  File "..\bin\Release\TickZoomLogging.dll"
  File "..\bin\Release\TickZoomLogging.pdb"
  File "..\bin\Release\TickZoomStarters.dll"
  File "..\bin\Release\TickZoomStarters.pdb"
  File "..\bin\Release\TickZoomTickUtil.dll"
  File "..\bin\Release\TickZoomTickUtil.pdb"
  File "..\bin\Release\ZedGraph.dll"
  File "..\bin\Release\ZedGraph.pdb"
  CreateDirectory "$SMPROGRAMS\TickZOOM ${PRODUCT_VERSION}"
  CreateDirectory "$SMPROGRAMS\TickZOOM ${PRODUCT_VERSION}\TickZOOM Application"
  CreateShortCut "$SMPROGRAMS\TickZOOM ${PRODUCT_VERSION}\TickZOOM Application\TickZOOM Application.lnk" "$INSTDIR\TickZoomGUI.exe"
  CreateShortCut "$SMPROGRAMS\TickZOOM ${PRODUCT_VERSION}\TickZOOM Application\TickZOOM Application 2.lnk" "$INSTDIR\TickZoomGUI2.exe"
SectionEnd

Section "Sample Data" SEC03
  SetOutPath "C:\TickZOOM\DataCache"
  SetOverwrite try
  File "DataCache\AUDUSD_Tick.tck"
  File "DataCache\EURJPY_Tick.tck"
  File "DataCache\EURUSD_Tick.tck"
  File "DataCache\GBPUSD_Tick.tck"
  File "DataCache\NZDUSD_Tick.tck"
  File "DataCache\USDCAD_Tick.tck"
  File "DataCache\USDCHF_Tick.tck"
  File "DataCache\USDDKK_Tick.tck"
  File "DataCache\USDJPY_Tick.tck"
  File "DataCache\USDNOK_Tick.tck"
  File "DataCache\USDSEK_Tick.tck"
SectionEnd

Section "Sample Project Files" SEC04
  SetOutPath "C:\TickZOOM"
  SetOverwrite try
  File "ProjectFiles\portfolio.tzproj"
SectionEnd

Section "Plugins" SEC05
  SetOutPath "$PROGRAMFILES\TickZOOM\${PRODUCT_VERSION}\Plugins"
  SetOverwrite try
  File "..\bin\Release\CustomPlugin.dll"
  File "..\bin\Release\ExamplesPlugin.dll"
SectionEnd

Section "CustomPlugin" SEC06
  StrCpy $DOCDIR "$DOCUMENTS\TickZOOM Projects\${PRODUCT_VERSION}"
  SetOutPath "$DOCDIR\CustomPlugin"
  SetOverwrite off
  File "..\CustomPlugin\COPYING.txt"
  File "CustomPlugin\CustomPlugin.csproj"
  File "CustomPlugin\PostBuild.bat"
  SetOutPath "$DOCDIR\CustomPlugin\Indicators"
;  File "..\CustomPlugin\Indicators\*.cs"
  SetOutPath "$DOCDIR\CustomPlugin\Strategies"
;  File "..\CustomPlugin\Strategies\*.cs"
  SetOutPath "$DOCDIR\CustomPlugin\Loaders"
;  SetOutPath "$DOCDIR\CustomPlugin\Loaders"
  SetOutPath "$DOCDIR\CustomPlugin\Properties"
  File "..\CustomPlugin\Properties\*.cs"
  
  Push "<HintPath>REPLACE\TickZoomAPI1.0.dll</HintPath>" #text to be replaced
  Push "<HintPath>$INSTDIR\TickZoomAPI1.0.dll</HintPath>" #replace with
  Push all #replace all other occurrences
  Push all #replace all other occurrences
  Push "$DOCDIR\CustomPlugin\CustomPlugin.csproj" #file to replace in
  Call AdvReplaceInFile
  
  Push "<HintPath>REPLACE\TickZoomCommon.dll</HintPath>" #text to be replaced
  Push "<HintPath>$INSTDIR\TickZoomCommon.dll</HintPath>" #replace with
  Push all #replace all other occurrences
  Push all #replace all other occurrences
  Push "$DOCDIR\CustomPlugin\CustomPlugin.csproj" #file to replace in
  Call AdvReplaceInFile
  
  Push "REPLACE\TickZoomGUI.exe" #text to be replaced
  Push "$INSTDIR\TickZoomGUI.exe" #replace with
  Push all #replace all other occurrences
  Push all #replace all other occurrences
  Push "$DOCDIR\CustomPlugin\CustomPlugin.csproj" #file to replace in
  Call AdvReplaceInFile
  
  Push "REPLACE\PluginFolder" #text to be replaced
  Push "$INSTDIR\..\Plugins" #replace with
  Push all #replace all other occurrences
  Push all #replace all other occurrences
  Push "$DOCDIR\CustomPlugin\PostBuild.bat" #file to replace in
  Call AdvReplaceInFile
SectionEnd

Section "CustomPlugin" SEC07
  StrCpy $DOCDIR "$DOCUMENTS\TickZOOM Projects\${PRODUCT_VERSION}"
  SetOutPath "$DOCDIR\ExamplesPlugin"
  SetOverwrite off
  File "..\ExamplesPlugin\COPYING.txt"
  File "ExamplesPlugin\ExamplesPlugin.csproj"
  File "ExamplesPlugin\PostBuild.bat"
  SetOutPath "$DOCDIR\ExamplesPlugin\Indicators"
  File "..\ExamplesPlugin\Indicators\*.cs"
  SetOutPath "$DOCDIR\ExamplesPlugin\Strategies"
  File "..\ExamplesPlugin\Strategies\*.cs"
  SetOutPath "$DOCDIR\ExamplesPlugin\Loaders"
  File "..\ExamplesPlugin\Loaders\*.cs"
  SetOutPath "$DOCDIR\ExamplesPlugin\Properties"
  File "..\ExamplesPlugin\Properties\*.cs"
  
  Push "<HintPath>REPLACE\TickZoomAPI1.0.dll</HintPath>" #text to be replaced
  Push "<HintPath>$INSTDIR\TickZoomAPI1.0.dll</HintPath>" #replace with
  Push all #replace all other occurrences
  Push all #replace all other occurrences
  Push "$DOCDIR\ExamplesPlugin\ExamplesPlugin.csproj" #file to replace in
  Call AdvReplaceInFile
  
  Push "<HintPath>REPLACE\TickZoomCommon.dll</HintPath>" #text to be replaced
  Push "<HintPath>$INSTDIR\TickZoomCommon.dll</HintPath>" #replace with
  Push all #replace all other occurrences
  Push all #replace all other occurrences
  Push "$DOCDIR\ExamplesPlugin\ExamplesPlugin.csproj" #file to replace in
  Call AdvReplaceInFile
  
  Push "REPLACE\TickZoomGUI.exe" #text to be replaced
  Push "$INSTDIR\TickZoomGUI.exe" #replace with
  Push all #replace all other occurrences
  Push all #replace all other occurrences
  Push "$DOCDIR\ExamplesPlugin\ExamplesPlugin.csproj" #file to replace in
  Call AdvReplaceInFile
  
  Push "REPLACE\PluginFolder" #text to be replaced
  Push "$INSTDIR\..\Plugins" #replace with
  Push all #replace all other occurrences
  Push all #replace all other occurrences
  Push "$DOCDIR\ExamplesPlugin\PostBuild.bat" #file to replace in
  Call AdvReplaceInFile
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\TickZOOM ${PRODUCT_VERSION}\TickZOOM Application\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\TickZOOM ${PRODUCT_VERSION}\TickZOOM Application\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\TickZoomGUI.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\TickZoomGUI.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\install.log"
  Delete "$PROGRAMFILES\TickZOOM\${PRODUCT_VERSION}\Plugins\CustomPlugin.dll"
  Delete "$PROGRAMFILES\TickZOOM\${PRODUCT_VERSION}\Plugins\CustomPlugin.pdb"
  Delete "C:\TickZOOM\DataCache\AUDUSD_Tick.tck"
  Delete "C:\TickZOOM\DataCache\EURJPY_Tick.tck"
  Delete "C:\TickZOOM\DataCache\EURUSD_Tick.tck"
  Delete "C:\TickZOOM\DataCache\GBPUSD_Tick.tck"
  Delete "C:\TickZOOM\DataCache\NZDUSD_Tick.tck"
  Delete "C:\TickZOOM\DataCache\USDCAD_Tick.tck"
  Delete "C:\TickZOOM\DataCache\USDCHF_Tick.tck"
  Delete "C:\TickZOOM\DataCache\USDDKK_Tick.tck"
  Delete "C:\TickZOOM\DataCache\USDJPY_Tick.tck"
  Delete "C:\TickZOOM\DataCache\USDNOK_Tick.tck"
  Delete "C:\TickZOOM\DataCache\USDSEK_Tick.tck"
  Delete "$INSTDIR\ZedGraph.dll"
  Delete "$INSTDIR\ZedGraph.pdb"
  Delete "$INSTDIR\TickZoomTickUtil.dll"
  Delete "$INSTDIR\TickZoomTickUtil.pdb"
  Delete "$INSTDIR\TickZoomLogging.dll"
  Delete "$INSTDIR\TickZoomLogging.pdb"
  Delete "$INSTDIR\TickZoomStarters.dll"
  Delete "$INSTDIR\TickZoomStarters.pdb"
  Delete "$INSTDIR\TickZoomGUI.exe.config"
  Delete "$INSTDIR\TickZoomGUI.exe"
  Delete "$INSTDIR\TickZoomGUI.pdb"
  Delete "$INSTDIR\TickZoomGUI2.exe.config"
  Delete "$INSTDIR\TickZoomGUI2.exe"
  Delete "$INSTDIR\TickZoomGUI2.pdb"
  Delete "$INSTDIR\TickZoomEngine.dll"
  Delete "$INSTDIR\TickZoomEngine.pdb"
  Delete "$INSTDIR\TickZoomCommunication.dll"
  Delete "$INSTDIR\TickZoomCommunication.pdb"
  Delete "$INSTDIR\TickZoomCommon.dll"
  Delete "$INSTDIR\TickZoomCommon.pdb"
  Delete "$INSTDIR\TickZoomAPI1.0.dll"
  Delete "$INSTDIR\TickZoomAPI1.0.pdb"
  Delete "$INSTDIR\WeifenLuo.WinFormsUI.Docking.dll"
  Delete "$INSTDIR\WeifenLuo.WinFormsUI.Docking.pdb"
  Delete "$INSTDIR\DockPanel.config"
  Delete "$INSTDIR\dotnetfx35.exe"

  ; CustomPlugins

  Delete "$SMPROGRAMS\TickZOOM ${PRODUCT_VERSION}\TickZOOM Application\Uninstall.lnk"
  Delete "$SMPROGRAMS\TickZOOM ${PRODUCT_VERSION}\TickZOOM Application\Website.lnk"
  Delete "$SMPROGRAMS\TickZOOM ${PRODUCT_VERSION}\TickZOOM Application\TickZOOM Application.lnk"
  Delete "$SMPROGRAMS\TickZOOM ${PRODUCT_VERSION}\TickZOOM Application\TickZOOM Application 2.lnk"

  RMDir "$PROGRAMFILES\TickZOOM\${PRODUCT_VERSION}\Plugins"
  RMDir "C:\TickZOOM\DataCache"
  RMDir "$SMPROGRAMS\TickZOOM ${PRODUCT_VERSION}\TickZOOM Application"
  RMDir "$SMPROGRAMS\TickZOOM ${PRODUCT_VERSION}"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

Function AdvReplaceInFile
Exch $0 ;file to replace in
Exch
Exch $1 ;number to replace after
Exch
Exch 2
Exch $2 ;replace and onwards
Exch 2
Exch 3
Exch $3 ;replace with
Exch 3
Exch 4
Exch $4 ;to replace
Exch 4
Push $5 ;minus count
Push $6 ;universal
Push $7 ;end string
Push $8 ;left string
Push $9 ;right string
Push $R0 ;file1
Push $R1 ;file2
Push $R2 ;read
Push $R3 ;universal
Push $R4 ;count (onwards)
Push $R5 ;count (after)
Push $R6 ;temp file name

  GetTempFileName $R6
  FileOpen $R1 $0 r ;file to search in
  FileOpen $R0 $R6 w ;temp file
   StrLen $R3 $4
   StrCpy $R4 -1
   StrCpy $R5 -1

loop_read:
 ClearErrors
 FileRead $R1 $R2 ;read line
 IfErrors exit

   StrCpy $5 0
   StrCpy $7 $R2

loop_filter:
   IntOp $5 $5 - 1
   StrCpy $6 $7 $R3 $5 ;search
   StrCmp $6 "" file_write2
   StrCmp $6 $4 0 loop_filter

StrCpy $8 $7 $5 ;left part
IntOp $6 $5 + $R3
IntCmp $6 0 is0 not0
is0:
StrCpy $9 ""
Goto done
not0:
StrCpy $9 $7 "" $6 ;right part
done:
StrCpy $7 $8$3$9 ;re-join

IntOp $R4 $R4 + 1
StrCmp $2 all file_write1
StrCmp $R4 $2 0 file_write2
IntOp $R4 $R4 - 1

IntOp $R5 $R5 + 1
StrCmp $1 all file_write1
StrCmp $R5 $1 0 file_write1
IntOp $R5 $R5 - 1
Goto file_write2

file_write1:
 FileWrite $R0 $7 ;write modified line
Goto loop_read

file_write2:
 FileWrite $R0 $R2 ;write unmodified line
Goto loop_read

exit:
  FileClose $R0
  FileClose $R1

   SetDetailsPrint none
  Delete $0
  Rename $R6 $0
  Delete $R6
   SetDetailsPrint both

Pop $R6
Pop $R5
Pop $R4
Pop $R3
Pop $R2
Pop $R1
Pop $R0
Pop $9
Pop $8
Pop $7
Pop $6
Pop $5
Pop $0
Pop $1
Pop $2
Pop $3
Pop $4
FunctionEnd
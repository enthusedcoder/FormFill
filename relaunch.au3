#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=C:\Users\whiggs\OneDrive\always script\relaunch.exe
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; *** Start added by AutoIt3Wrapper ***
#include <FileConstants.au3>
; *** End added by AutoIt3Wrapper ***
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.15.0 (Beta)
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Constants.au3>
Sleep (1000)
#cs
$again = FileOpen ( @AppDataDir & "\filler\hold.txt" )
FileSetPos ( $again, 0, $FILE_BEGIN )
$loc = FileRead ( $again )
FileClose ( $again )
If StringRight ( $loc, 1 ) == "1" Then
	$loc = StringTrimRight ( $loc, 1 )
Run ( @ComSpec & " /c " & $loc, "", @SW_HIDE )
ElseIf StringRight ( $loc, 1 ) == "2" Then
	$loc = StringTrimRight ( $loc, 1 )
	$dss = StringReplace ( $loc, "passwnew.exe", "passw.exe" )
	FileMove ( $loc, $dss )
	Run ( @ComSpec & " /c " & $dss, "", @SW_HIDE )
Else
EndIf
#ce
Run ( @ComSpec & ' /c "' & $CmdLine[1] & '"', "", @SW_HIDE )

;MsgBox($MB_OK,"path",$CmdLine[1])

;ShellExecute (
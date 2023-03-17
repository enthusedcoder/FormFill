#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\auto-fill-form-icon.ico
#AutoIt3Wrapper_Outfile=C:\Users\whiggs\Onedrive\always script\passw.exe
#AutoIt3Wrapper_Outfile_x64=C:\Users\whiggs\Onedrive\always script\passwx64.exe
#AutoIt3Wrapper_Res_Fileversion=2.0.0.238
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; *** Start added by AutoIt3Wrapper ***
#include <EditConstants.au3>
#include <GuiEdit.au3>
; *** End added by AutoIt3Wrapper ***
; *** Start added by AutoIt3Wrapper ***
#include <FileConstants.au3>
; *** End added by AutoIt3Wrapper ***
; *** Start added by AutoIt3Wrapper ***
#include <GUIConstantsEx.au3>
; *** End added by AutoIt3Wrapper ***
; *** Start added by AutoIt3Wrapper ***
#include <FontConstants.au3>
; *** End added by AutoIt3Wrapper ***
; *** Start added by AutoIt3Wrapper ***
#include <ListViewConstants.au3>
#include <WindowsConstants.au3>
; *** End added by AutoIt3Wrapper ***
; *** Start added by AutoIt3Wrapper ***
#include <GUIConstants.au3>
; *** End added by AutoIt3Wrapper ***
; *** Start added by AutoIt3Wrapper ***
#include <AutoItConstants.au3>
#include <ListBoxConstants.au3>
; *** End added by AutoIt3Wrapper ***
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.13.19 (Beta)
	Author:         myName

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here


#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <Constants.au3>
#include <Misc.au3>
#include <Array.au3>
#include <GUIListViewEx.au3>
#include <GuiButton.au3>
#include <WinAPI.au3>
#include <MsgBoxConstants.au3>
#include <GuiListBox.au3>
#include <GuiListView.au3>
#include <GuiComboBox.au3>
#include <Word.au3>
#include <Crypt.au3>

;#include <_SelfDelete.au3>
OnAutoItExitRegister("refresh")
OnAutoItExitRegister("_WordExit")
HotKeySet("^{LEFT}", "PreviousSelection")
HotKeySet("^{RIGHT}", "NextSelection")
HotKeySet("^d", "SetTransparent")
Const $path = @AppDataDir & "\filler"
Opt("TrayMenuMode", 1)
Global $wordinst = False
Global $oWordApp = _Word_Create(False)
If @error Then
	SetError(0)
	$wordinst = False
	MsgBox($MB_OK + $MB_ICONEXCLAMATION, "Word not found", "Microsoft Word was not detected on this system.  This application uses Microsoft word to spell check your input.  In order to take advantage of this functionality, please exit this script, install word, and accept the EULA after opening it.  However, this is not required, and you can continue to use the application without spell check if you want to.")
Else
	$wordinst = True
	Global $oDoc = _Word_DocAdd($oWordApp)
	Global $oRange = $oDoc.Range
	Global $oSpellCollection, $oAlternateWords
EndIf

;#include "SpellGUI.au3"
Global $extend = 0
$nonote = False
Global $transp = False


Global $passarray
Global $passlistview[0][2]
$TrayMenu = TrayCreateMenu("Settings")
$settings1 = TrayCreateItem("Turn off notifications", $TrayMenu)
TrayItemSetState(-1, Int(IniRead($path & "\infostore.ini", "Tray Settings", "No Notifications", "68")))
$settings2 = TrayCreateItem("Keep Window on top", $TrayMenu)
TrayItemSetState(-1, Int(IniRead($path & "\infostore.ini", "Tray Settings", "On top", "68")))
Global Const $key = _Crypt_DeriveKey("KeyToKeepDataSafe", $CALG_AES_256)
DirCreate($path)
FileInstall("C:\Users\whiggs\Onedrive\always script\1_ClipboardHelpAndSpell.ico", $path & "\1_ClipboardHelpAndSpell.ico")
FileInstall("C:\Users\whiggs\OneDrive\Pic\Aha-Soft-Software-Cancel.ico", $path & "\Aha-Soft-Software-Cancel.ico")
FileInstall("C:\Users\whiggs\OneDrive\always script\relaunch.exe", $path & "\relaunch.exe", $FC_OVERWRITE)
If FileExists($path & "\FormFiller.chm") Then
	Do
		FileDelete($path & "\FormFiller.chm")
	Until Not FileExists($path & "\FormFiller.chm")
EndIf
FileInstall("C:\Users\whiggs\OneDrive\always script\FormFiller.chm", $path & "\FormFiller.chm")
Const $temp = EnvGet("TEMP")
$exist = True
Global $finterrupt = 0
;progUpdate()
Global $storepath = IniRead($path & "\infostore.ini", "location", "info", "Not found")
If $storepath = "Not found" Or Not FileExists($storepath) Then
	#Region --- CodeWizard generated code Start ---

	;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Default Button=Second, Icon=None
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_DEFBUTTON2, "Cannot find Information file", 'If this is your first time running the program, select "no" and you will be asked to enter your information.  If you have run this program and generated a file containing your information, please select "yes" and open the file.')
	Select
		Case $iMsgBoxAnswer = $IDYES
			$exist = True
			$file = FileOpenDialog("Select your info file here.", @MyDocumentsDir, "Ini File (*.ini)", 3, "login.ini")
			If $file == "" Then
				Exit
			EndIf

			IniWrite($path & "\infostore.ini", "location", "info", $file)
			Global $storepath = IniRead($path & "\infostore.ini", "location", "info", "Not found")

		Case $iMsgBoxAnswer = $IDNO
			$exist = False
			$file = FileSaveDialog("create your file", @MyDocumentsDir, "Ini files (*.ini)", 18, "login.ini")
			If $file == "" Then
				Exit
			EndIf

			IniWrite($path & "\infostore.ini", "location", "info", $file)
			Global $storepath = IniRead($path & "\infostore.ini", "location", "info", "Not found")

	EndSelect
	#EndRegion --- CodeWizard generated code Start ---
EndIf


Local $readhold = IniReadSectionNames($storepath)
$entercomp = False
$enterref = False
$entered = False

$seafile = @ScriptDir & "\1_ClipboardHelpAndSpell.ico"
$tune = False
#Region ### START Koda GUI section ### Form=C:\Users\whiggs\seafile\always script\form\final.kxf
$Form1_1 = GUICreate("Form filler", 701, 659, 317, 125, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX, $WS_THICKFRAME, $WS_TABSTOP)) ;, $WS_EX_TRANSPARENT)
If $exist = False Then
	names(True)
	emailadd(True)
	usernames(True)
	passx(True)
	addradd(True)
	phoneadd(True)
	addwebsite(True)
EndIf

If $exist = False And TrayItemGetState($settings1) = 68 Then
	#Region --- CodeWizard generated code Start ---

	;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "Education", "Do you have any educational institutions you want to input into the form filler?")
	Select
		Case $iMsgBoxAnswer = $IDYES
			$entered = True

		Case $iMsgBoxAnswer = $IDNO
			$entered = False

	EndSelect
	#EndRegion --- CodeWizard generated code Start ---
EndIf
If $entered = True Then
	Edadd(True)
EndIf



If $exist = False And TrayItemGetState($settings1) = 68 Then
	#Region --- CodeWizard generated code Start ---

	;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "Work History?", "Do you want to add past work history to the form filler?")
	Select
		Case $iMsgBoxAnswer = $IDYES
			$entercomp = True

		Case $iMsgBoxAnswer = $IDNO
			$entercomp = False

	EndSelect
	#EndRegion --- CodeWizard generated code Start ---
EndIf

If $entercomp = True Then
	compadd()
	refadd(True)
EndIf

If Not IsAdmin() Then
	#Region --- CodeWizard generated code Start ---

	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info
	MsgBox($MB_OK + $MB_ICONASTERISK, "Admin credentials", "While administrative credentials are not required for this program to work, it is recommended that you run the program with admin credentials to so that it can function in elevated processes.")
	#EndRegion --- CodeWizard generated code Start ---

EndIf
$starttop = False



;WinSetTrans ( $Form1_1, "", 100 )
If TrayItemGetState($settings2) = 65 Then
	WinSetOnTop($Form1_1, "", $WINDOWS_ONTOP)
EndIf

GUISetHelp('hh.exe "' & $path & '\FormFiller.chm"')
$MenuItem11 = GUICtrlCreateMenu("File")
$MenuItem12 = GUICtrlCreateMenuItem("Load information file", $MenuItem11)
$MenuItem1 = GUICtrlCreateMenu("Add/Edit")
$MenuItem2 = GUICtrlCreateMenu("Users", $MenuItem1)
$MenuItem3 = GUICtrlCreateMenu("email", $MenuItem1)
$MenuItem4 = GUICtrlCreateMenu("password", $MenuItem1)
$MenuItem13 = GUICtrlCreateMenu("personal address", $MenuItem1)
$MenuItem5 = GUICtrlCreateMenu("phone", $MenuItem1)
$MenuItem6 = GUICtrlCreateMenu("education", $MenuItem1)
$MenuItem15 = GUICtrlCreateMenuItem("Whole Entry", $MenuItem6)
$MenuItem16 = GUICtrlCreateMenu("Address", $MenuItem6)
$MenuItem17 = GUICtrlCreateMenuItem("Whole Address", $MenuItem16)
$MenuItem18 = GUICtrlCreateMenuItem("Street", $MenuItem16)
$MenuItem19 = GUICtrlCreateMenuItem("City", $MenuItem16)
$MenuItem20 = GUICtrlCreateMenuItem("State", $MenuItem16)
$MenuItem21 = GUICtrlCreateMenuItem("Zip", $MenuItem16)
$MenuItem22 = GUICtrlCreateMenuItem("Phone", $MenuItem6)
$MenuItem23 = GUICtrlCreateMenuItem("GPA", $MenuItem6)
$MenuItem24 = GUICtrlCreateMenuItem("Degree", $MenuItem6)
$MenuItem7 = GUICtrlCreateMenu("references", $MenuItem1)
$MenuItem25 = GUICtrlCreateMenuItem("Whole entry", $MenuItem7)
$MenuItem26 = GUICtrlCreateMenuItem("Company", $MenuItem7)
$MenuItem27 = GUICtrlCreateMenuItem("Relationship", $MenuItem7)
$MenuItem28 = GUICtrlCreateMenuItem("Years Known", $MenuItem7)
$MenuItem29 = GUICtrlCreateMenuItem("Title", $MenuItem7)
$MenuItem30 = GUICtrlCreateMenuItem("Phone", $MenuItem7)
$MenuItem31 = GUICtrlCreateMenuItem("Email", $MenuItem7)
$MenuItem8 = GUICtrlCreateMenu("company", $MenuItem1)
$MenuItem32 = GUICtrlCreateMenuItem("Whole entry", $MenuItem8)
$MenuItem33 = GUICtrlCreateMenu("Address", $MenuItem8)
$MenuItem34 = GUICtrlCreateMenuItem("Whole Address", $MenuItem33)
$MenuItem35 = GUICtrlCreateMenuItem("Street", $MenuItem33)
$MenuItem36 = GUICtrlCreateMenuItem("City", $MenuItem33)
$MenuItem37 = GUICtrlCreateMenuItem("State", $MenuItem33)
$MenuItem38 = GUICtrlCreateMenuItem("Zip", $MenuItem33)
$MenuItem39 = GUICtrlCreateMenuItem("Phone", $MenuItem8)
$MenuItem40 = GUICtrlCreateMenuItem("Title", $MenuItem8)
$MenuItem41 = GUICtrlCreateMenuItem("Job Description", $MenuItem8)
$MenuItem42 = GUICtrlCreateMenuItem("Start/end date", $MenuItem8)
$MenuItem43 = GUICtrlCreateMenuItem("Pay", $MenuItem8)
$MenuItem44 = GUICtrlCreateMenuItem("Reason Left", $MenuItem8)
$MenuItem14 = GUICtrlCreateMenu("website", $MenuItem1)
$MenuItem45 = GUICtrlCreateMenuItem("Cover Letter", $MenuItem1)
$MenuItem46 = GUICtrlCreateMenuItem("Objective", $MenuItem1)
$MenuItem47 = GUICtrlCreateMenuItem("Add", $MenuItem2)
$MenuItem48 = GUICtrlCreateMenuItem("Edit", $MenuItem2)
$MenuItem49 = GUICtrlCreateMenuItem("Add", $MenuItem3)
$MenuItem50 = GUICtrlCreateMenuItem("Edit", $MenuItem3)
$MenuItem51 = GUICtrlCreateMenuItem("Add", $MenuItem4)
$MenuItem52 = GUICtrlCreateMenuItem("Edit", $MenuItem4)
$MenuItem53 = GUICtrlCreateMenuItem("Add", $MenuItem5)
$MenuItem54 = GUICtrlCreateMenuItem("Edit", $MenuItem5)
$MenuItem55 = GUICtrlCreateMenuItem("Add", $MenuItem14)
$MenuItem56 = GUICtrlCreateMenuItem("Edit", $MenuItem14)
$MenuItem57 = GUICtrlCreateMenuItem("Add", $MenuItem13)
$MenuItem58 = GUICtrlCreateMenuItem("Edit", $MenuItem13)
$menuitem59 = GUICtrlCreateMenuItem("Misc", $MenuItem1)
$menuitem60 = GUICtrlCreateMenuItem("Add", $menuitem59)
$menuitem61 = GUICtrlCreateMenuItem("Edit", $menuitem59)
$MenuItem9 = GUICtrlCreateMenu("Help")
$MenuItem10 = GUICtrlCreateMenuItem("Help file (F1)", $MenuItem9)
$Checkbox1 = GUICtrlCreateCheckbox("Name?", 32, 24, 57, 17)
GUIStartGroup()
$Radio1 = GUICtrlCreateRadio("Full Name?", 112, 16, 121, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Radio2 = GUICtrlCreateRadio("First Name?", 112, 32, 121, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Radio3 = GUICtrlCreateRadio("Last Name?", 112, 48, 121, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Radio4 = GUICtrlCreateRadio("Full name seperatly?", 112, 64, 121, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
GUIStartGroup()
$Button1 = GUICtrlCreateButton("Send", 264, 24, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetCursor(-1, 0)
$Checkbox2 = GUICtrlCreateCheckbox("Username?", 32, 100, 73, 17)
$Combo1 = GUICtrlCreateCombo("", 120, 100, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
Local $numusername = IniReadSection($storepath, "User Names")
If @error Then
	SetError(0)
	If TrayItemGetState($settings1) = 68 Then
		#Region --- CodeWizard generated code Start ---

		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "No username", "Even though you have configured previous entries, you do not have any user names stored for input.  Would you like to store a user name now?")
		Select
			Case $iMsgBoxAnswer = $IDYES
				usernames(False)

				For $count1 = 1 To $numusername[0][0] Step 1
					GUICtrlSetData($Combo1, BinaryToString(decry($numusername[$count1][1])))
				Next
			Case $iMsgBoxAnswer = $IDNO
		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
	EndIf

Else
	If $numusername[0][0] > 1 Then
		For $count1 = 1 To $numusername[0][0] Step 1
			GUICtrlSetData($Combo1, BinaryToString(decry($numusername[$count1][1])))
		Next
	Else
		GUICtrlSetData($Combo1, BinaryToString(decry($numusername[1][1])))
	EndIf
EndIf

$Button2 = GUICtrlCreateButton("Send", 294, 100, 75, 25)
GUICtrlSetCursor(-1, 0)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox3 = GUICtrlCreateCheckbox("Email?", 32, 150, 49, 17)
$Combo2 = GUICtrlCreateCombo("", 120, 150, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
Local $numemail = IniReadSection($storepath, "Email")
If @error Then
	SetError(0)
	If TrayItemGetState($settings1) = 68 Then
		#Region --- CodeWizard generated code Start ---
		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "No email", "Even though you have configured previous entries, you do not have any email addresses stored for input.  Would you like to store an email address now?")
		Select
			Case $iMsgBoxAnswer = $IDYES
				emailadd(False)

				For $count2 = 1 To $numemail[0][0] Step 1
					GUICtrlSetData($Combo2, BinaryToString(decry($numemail[$count2][1])))
				Next
			Case $iMsgBoxAnswer = $IDNO
		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
	EndIf

Else
	If $numemail[0][0] > 1 Then
		For $count2 = 1 To $numemail[0][0] Step 1
			GUICtrlSetData($Combo2, BinaryToString(decry($numemail[$count2][1])))
		Next
	Else
		GUICtrlSetData($Combo2, BinaryToString(decry($numemail[1][1])))
	EndIf
EndIf

$Button3 = GUICtrlCreateButton("Send", 294, 150, 75, 25)
GUICtrlSetCursor(-1, 0)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox4 = GUICtrlCreateCheckbox("Password?", 32, 200, 73, 17)
$Combo3 = GUICtrlCreateCombo("", 120, 200, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$tempbool = True
Local $numpass = IniReadSection($storepath, "Password")


If @error Then
	SetError(0)
	If TrayItemGetState($settings1) = 68 Then
		#Region --- CodeWizard generated code Start ---

		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "No password", "Even though you have configured previous entries, you do not have any passwords stored for input.  Would you like to store some now?")
		Select
			Case $iMsgBoxAnswer = $IDYES
				passx(False)
				Local $numpass = IniReadSection($storepath, "Password")
				Global $passarray[$numpass[0][0]][2]
				For $ghg = 1 To $numpass[0][0] Step 1
					#cs
					$passarray[$ghg - 1][0] = BinaryToString(decry($numpass[$ghg][1]))
					$remove = StringLen ( BinaryToString(decry($numpass[$ghg][1])))
					$left = StringLeft ( BinaryToString(decry($numpass[$ghg][1])), 2 )
					$right = StringRight ( BinaryToString(decry($numpass[$ghg][1])), 2 )

					$star = ''
					For $vr = 1 To $remove - 4 Step 1
					$star = $star & "*"
					Next
					If_GUICtrlComboBox_FindString ( $Combo3, $left & $star & $right ) <> -1 Then
					Do
					$star = $star & "*"
					Until ( _GUICtrlComboBox_FindString ( $Combo3, $left & $star & $right ) = -1 )
					EndIf
					$passarray[$ghg - 1][1] = $left & $star & $right
					GUICtrlSetData($Combo3, $passarray[$ghg - 1][1])
					#ce
					GUICtrlSetData($Combo3, BinaryToString(decry($numpass[$ghg][1])))
				Next
			Case $iMsgBoxAnswer = $IDNO
		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
	EndIf

Else
	Global $passarray[$numpass[0][0]][2]
	If $numpass[0][0] > 1 Then
		For $ghg = 1 To $numpass[0][0] Step 1
			#cs
			$passarray[$ghg - 1][0] = BinaryToString(decry($numpass[$ghg][1]))
			$remove = StringLen ( BinaryToString(decry($numpass[$ghg][1])))
			$left = StringLeft ( BinaryToString(decry($numpass[$ghg][1])), 2 )
			$right = StringRight ( BinaryToString(decry($numpass[$ghg][1])), 2 )

			$star = ''
			For $vr = 1 To $remove - 4 Step 1
			$star = $star & "*"
			Next
			If_GUICtrlComboBox_FindString ( $Combo3, $left & $star & $right ) <> -1 Then
			Do
			$star = $star & "*"
			Until ( _GUICtrlComboBox_FindString ( $Combo3, $left & $star & $right ) = -1 )
			EndIf
			$passarray[$ghg - 1][1] = $left & $star & $right
			#ce
			GUICtrlSetData($Combo3, BinaryToString(decry($numpass[$ghg][1])))
			;GUICtrlSetData($Combo3, $passarray[$ghg - 1][1])
		Next
	Else
		#cs
		$passarray[0][0] = BinaryToString(decry($numpass[1][1]))
		$remove = StringLen ( BinaryToString(decry($numpass[1][1])))
		$left = StringLeft ( BinaryToString(decry($numpass[1][1])), 2 )
		$right = StringRight ( BinaryToString(decry($numpass[1][1])), 2 )

		$star = ''
		For $vr = 1 To $remove - 4 Step 1
		$star = $star & "*"
		Next
		$passarray[0][1] = $left & $star & $right
		#ce
		GUICtrlSetData($Combo3, BinaryToString(decry($numpass[1][1])))
	EndIf
EndIf
$checkbox61 = GUICtrlCreateCheckbox("Show hidden password values.", 120, 240, 155, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Button4 = GUICtrlCreateButton("Send", 294, 200, 75, 25)
GUICtrlSetCursor(-1, 0)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox6 = GUICtrlCreateCheckbox("Address?", 32, 280, 81, 17)
$Checkbox7 = GUICtrlCreateCheckbox("Phone?", 32, 320, 57, 17)
$Combo5 = GUICtrlCreateCombo("", 120, 320, 145, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
Local $numphone = IniReadSection($storepath, "Phone number")
If @error Then
	SetError(0)
	If TrayItemGetState($settings1) = 68 Then
		#Region --- CodeWizard generated code Start ---

		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "No phone", "Even though you have configured previous entries, you do not have any phone numbers stored for input.  Would you like to store some now?")
		Select
			Case $iMsgBoxAnswer = $IDYES
				phoneadd(False)
				For $why = 1 To $numphone[0][0] Step 1
					GUICtrlSetData($Combo5, BinaryToString(decry($numphone[$why][1])))
				Next
			Case $iMsgBoxAnswer = $IDNO

		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
	EndIf

Else
	If $numphone[0][0] > 1 Then
		For $why = 1 To $numphone[0][0] Step 1
			GUICtrlSetData($Combo5, BinaryToString(decry($numphone[$why][1])))
		Next
	Else

		GUICtrlSetData($Combo5, BinaryToString(decry($numphone[1][1])))
	EndIf
EndIf
$Button7 = GUICtrlCreateButton("Send", 294, 320, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetCursor(-1, 0)
$Checkbox8 = GUICtrlCreateCheckbox("Education?", 400, 32, 73, 17)
; $Button8 = GUICtrlCreateButton("Send", 576, 24, 75, 25)
;GUICtrlSetState(-1, $GUI_DISABLE)
;GUICtrlSetState(-1, $GUI_HIDE)
;GUICtrlSetCursor (-1, 0)
$Checkbox58 = GUICtrlCreateCheckbox("Cover Letter?", 408, 74, 80, 17)
$Button35 = GUICtrlCreateButton("Send", 530, 70, 65, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox59 = GUICtrlCreateCheckbox("Objective?", 408, 110, 90, 20)
$Button36 = GUICtrlCreateButton("Send", 530, 105, 65, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox5 = GUICtrlCreateCheckbox("Company?", 408, 144, 73, 17)
$Checkbox11 = GUICtrlCreateCheckbox("References?", 408, 184, 81, 17)
$Checkbox50 = GUICtrlCreateCheckbox("Website?", 408, 224, 73, 17)
$Combo6 = GUICtrlCreateCombo("", 488, 224, 137, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetState($Combo6, $GUI_DISABLE)
GUICtrlSetState($Combo6, $GUI_HIDE)
Local $numwebsite = IniReadSection($storepath, "Websites")
If @error Then
	SetError(0)
	If TrayItemGetState($settings1) = 68 Then
		#Region --- CodeWizard generated code Start ---

		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "No website", "Even though you have configured previous entries, you do not have any websites stored for input.  Would you like to store some now?")
		Select
			Case $iMsgBoxAnswer = $IDYES
				addwebsite(False)
				$numwebsite = IniReadSection($storepath, "Websites")
				For $whh = 1 To $numwebsite[0][0] Step 1
					GUICtrlSetData($Combo6, BinaryToString(decry($numwebsite[$whh][1])))
				Next
			Case $iMsgBoxAnswer = $IDNO
		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
	EndIf

Else
	If $numwebsite[0][0] > 1 Then
		For $whh = 1 To $numwebsite[0][0] Step 1
			GUICtrlSetData($Combo6, BinaryToString(decry($numwebsite[$whh][1])))
		Next
	Else
		GUICtrlSetData($Combo6, BinaryToString(decry($numwebsite[1][1])))
	EndIf
EndIf
$Checkbox60 = GUICtrlCreateCheckbox("Display passwords", 500, 430, 130, 17)
$Button27 = GUICtrlCreateButton("Send", 632, 224, 65, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox62 = GUICtrlCreateCheckbox("Misc?", 408, 264, 73, 17)
$Label5 = GUICtrlCreateLabel("Templates", 510, 315, 100, 25)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
$Combo7 = GUICtrlCreateCombo("Add to Templates", 460, 350, 200, 15, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
templateFill()
$Button28 = GUICtrlCreateButton("Add/Display Template", 480, 385, 150, 25)
GUICtrlSetCursor(-1, 0)
$Button11 = GUICtrlCreateButton("Send", 525, 480, 75, 40)
GUICtrlSetCursor(-1, 0)
$Button12 = GUICtrlCreateButton("RESET", 468, 600, 75, 25)
GUICtrlSetCursor(-1, 0)
$ListView1 = GUICtrlCreateListView("Information|Data", 6, 360, 427, 273, BitOR($LVS_SHOWSELALWAYS, $LVS_REPORT), BitOR($WS_EX_CLIENTEDGE, $LVS_EX_FULLROWSELECT))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 135)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 288)
$Button13 = GUICtrlCreateButton("Remove item", 580, 600, 81, 25)
GUICtrlSetCursor(-1, 0)
$Button18 = GUICtrlCreateButton("Export Raw data", 468, 540, 75, 41, $BS_MULTILINE)
GUICtrlSetCursor(-1, 0)
$Button26 = GUICtrlCreateButton("Import Raw data", 580, 540, 81, 41, $BS_MULTILINE)
GUICtrlSetCursor(-1, 0)

#Region ### START Koda GUI section ### Form=c:\users\whiggs\onedrive\always script\form\education.kxf
$Form3_1 = GUICreate("Education", 495, 487, 228, 181, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX, $WS_THICKFRAME, $WS_TABSTOP), BitOR($WS_EX_OVERLAPPEDWINDOW, $WS_EX_WINDOWEDGE), $Form1_1)
If TrayItemGetState($settings2) = 65 Then
	WinSetOnTop($Form3_1, "", $WINDOWS_ONTOP)
EndIf

$thee = Int(IniRead($storepath, "Hold Num", "Education Number", "Null"))
$Label1 = GUICtrlCreateLabel("Select the Information to include in the list", 72, 8, 348, 28)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("High School", 40, 48, 120, 30)
GUICtrlSetFont(-1, 17, 400, 0, "MS Sans Serif")
$List2 = GUICtrlCreateList("", 8, 96, 209, 136, BitOR($GUI_SS_DEFAULT_LIST, $LBS_MULTIPLESEL, $LBS_HASSTRINGS, $WS_HSCROLL))
$Label3 = GUICtrlCreateLabel("College", 296, 48, 74, 30)
GUICtrlSetFont(-1, 17, 400, 0, "MS Sans Serif")
$List3 = GUICtrlCreateList("", 264, 96, 217, 136, BitOR($GUI_SS_DEFAULT_LIST, $LBS_MULTIPLESEL, $LBS_HASSTRINGS, $WS_HSCROLL))
For $rer = 1 To $thee Step 1
	If BinaryToString(decry(IniRead($storepath, "Education history " & $rer, "Education Level", "null"))) == "College" Then
		GUICtrlSetData($List3, BinaryToString(decry(IniRead($storepath, "Education history " & $rer, "Name", "null"))))
	Else
		GUICtrlSetData($List2, BinaryToString(decry(IniRead($storepath, "Education history " & $rer, "Name", "null"))))
	EndIf
Next
$Checkbox14 = GUICtrlCreateCheckbox("Address", 160, 248, 81, 33)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox15 = GUICtrlCreateCheckbox("Phone", 256, 248, 65, 33)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox16 = GUICtrlCreateCheckbox("GPA", 336, 248, 57, 33)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox17 = GUICtrlCreateCheckbox("Degree", 400, 248, 81, 33)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
GUIStartGroup()
$Radio8 = GUICtrlCreateRadio("Full Address", 72, 296, 113, 25)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Radio9 = GUICtrlCreateRadio("Partial", 72, 328, 113, 25)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
GUIStartGroup()
$Group1 = GUICtrlCreateGroup("Partial address selection", 240, 288, 225, 97)
$Checkbox18 = GUICtrlCreateCheckbox("Street", 248, 304, 81, 25) ;, BitOR($GUI_SS_DEFAULT_CHECKBOX,$WS_GROUP))   "Street", 248, 304, 81, 25,
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox19 = GUICtrlCreateCheckbox("City", 344, 304, 97, 25)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox20 = GUICtrlCreateCheckbox("State", 248, 344, 73, 25)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox21 = GUICtrlCreateCheckbox("Zip", 352, 344, 73, 25) ;, BitOR($GUI_SS_DEFAULT_CHECKBOX,$WS_GROUP))
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState($Group1, $GUI_DISABLE)
GUICtrlSetState($Group1, $GUI_HIDE)
$Button14 = GUICtrlCreateButton("Add to list", 176, 408, 145, 49)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetCursor(-1, 0)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
#EndRegion ### END Koda GUI section ###

#Region ### START Koda GUI section ### Form=c:\users\whiggs\onedrive\always script\form\company.kxf
$Form5 = GUICreate("Company info", 420, 435, 268, 215, -1, -1, $Form1_1)
If TrayItemGetState($settings2) = 65 Then
	WinSetOnTop($Form5, "", $WINDOWS_ONTOP)
EndIf
$gogo = Int(IniRead($storepath, "Hold Num", "Company number", "Problem somewhere"))
$GroupBox1 = GUICtrlCreateGroup("", 8, 1, 401, 257)
$List1 = GUICtrlCreateList("", 16, 16, 217, 227, BitOR($GUI_SS_DEFAULT_LIST, $LBS_MULTIPLESEL, $LBS_HASSTRINGS, $LBS_DISABLENOSCROLL, $WS_HSCROLL))
For $ytr = 1 To $gogo Step 1
	GUICtrlSetData(-1, BinaryToString(decry(IniRead($storepath, "Company " & $ytr, "Company name", "Null"))))
Next
$Checkbox32 = GUICtrlCreateCheckbox("Address?", 240, 40, 105, 17)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox33 = GUICtrlCreateCheckbox("Phone?", 240, 72, 97, 17)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox34 = GUICtrlCreateCheckbox("Title?", 240, 104, 97, 17)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox52 = GUICtrlCreateCheckbox("Job Description?", 240, 136, 161, 17)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox53 = GUICtrlCreateCheckbox("Start/end dates?", 240, 168, 153, 17)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox54 = GUICtrlCreateCheckbox("Pay?", 240, 192, 153, 25)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox55 = GUICtrlCreateCheckbox("Reason left?", 240, 224, 153, 17)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("Address type", 32, 272, 129, 81)
GUIStartGroup()
$Radio10 = GUICtrlCreateRadio("Full?", 48, 288, 97, 25, $GUI_SS_DEFAULT_RADIO)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Radio11 = GUICtrlCreateRadio("Partial?", 48, 320, 97, 25, $GUI_SS_DEFAULT_RADIO)
GUIStartGroup()
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Group4 = GUICtrlCreateGroup("Pieces", 216, 272, 185, 81)
$Checkbox41 = GUICtrlCreateCheckbox("Street address", 224, 288, 89, 25, BitOR($GUI_SS_DEFAULT_CHECKBOX, $WS_GROUP))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox42 = GUICtrlCreateCheckbox("City", 328, 296, 57, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox43 = GUICtrlCreateCheckbox("State", 224, 320, 81, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox44 = GUICtrlCreateCheckbox("Zip", 320, 328, 65, 17, BitOR($GUI_SS_DEFAULT_CHECKBOX, $WS_GROUP))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
GUIStartGroup()
$Radio12 = GUICtrlCreateRadio("Single Entry?", 264, 288, 97, 25, $GUI_SS_DEFAULT_RADIO)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Radio13 = GUICtrlCreateRadio("Multiple Entries?", 264, 320, 105, 25, $GUI_SS_DEFAULT_RADIO)
GUIStartGroup()
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Button20 = GUICtrlCreateButton("&OK", 33, 371, 91, 33)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetCursor(-1, 0)
$Button19 = GUICtrlCreateButton("&Cancel", 194, 371, 91, 33)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetCursor(-1, 0)
#EndRegion ### END Koda GUI section ###
#Region ### START Koda GUI section ### Form=c:\users\whiggs\onedrive\always script\form\references.kxf
$Form3 = GUICreate("References", 394, 397, 228, 222, -1, -1, $Form1_1)
If TrayItemGetState($settings2) = 65 Then
	WinSetOnTop($Form3, "", $WINDOWS_ONTOP)
EndIf
$too = Int(IniRead($storepath, "Hold Num", "Reference Number", "Problem"))
$List4 = GUICtrlCreateList("", 48, 48, 281, 188, BitOR($GUI_SS_DEFAULT_LIST, $LBS_MULTIPLESEL, $LBS_HASSTRINGS, $LBS_DISABLENOSCROLL, $WS_HSCROLL))
For $prep = 1 To $too Step 1
	GUICtrlSetData(-1, BinaryToString(decry(IniRead($storepath, "Reference " & $prep, "Name", "Null"))))
Next
$Checkbox35 = GUICtrlCreateCheckbox("Company?", 48, 248, 73, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox36 = GUICtrlCreateCheckbox("Title?", 48, 272, 49, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox37 = GUICtrlCreateCheckbox("Phone?", 136, 272, 57, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox38 = GUICtrlCreateCheckbox("Relationship?", 128, 248, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox39 = GUICtrlCreateCheckbox("Email?", 248, 272, 57, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox40 = GUICtrlCreateCheckbox("Years known?", 240, 248, 89, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Button21 = GUICtrlCreateButton("&OK", 80, 328, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetCursor(-1, 0)
$Button22 = GUICtrlCreateButton("&Cancel", 192, 328, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetCursor(-1, 0)
$Label4 = GUICtrlCreateLabel("References", 136, 8, 101, 28)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
#EndRegion ### END Koda GUI section ###

#Region ### START Koda GUI section ### Form=C:\Users\whiggs\OneDrive\always script\form\Form4.kxf
$Form4 = GUICreate("Dialog", 310, 258, 341, 266, -1, -1, $Form1_1)
If TrayItemGetState($settings2) = 65 Then
	WinSetOnTop($Form4, "", $WINDOWS_ONTOP)
EndIf
$hell = Int(IniRead($storepath, "Hold Num", "Address", "0"))
$List5 = GUICtrlCreateList("", 16, 16, 161, 162, BitOR($GUI_SS_DEFAULT_LIST, $LBS_MULTIPLESEL, $LBS_HASSTRINGS))
For $fra = 1 To $hell Step 1
	GUICtrlSetData(-1, BinaryToString(decry(IniRead($storepath, "Address " & $fra, "Name", ""))))
Next

GUIStartGroup()
$Checkbox45 = GUICtrlCreateCheckbox("Street", 192, 40, 97, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox46 = GUICtrlCreateCheckbox("City", 192, 64, 81, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox47 = GUICtrlCreateCheckbox("State", 192, 88, 89, 33)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox48 = GUICtrlCreateCheckbox("ZIP", 192, 112, 89, 33)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$Checkbox49 = GUICtrlCreateCheckbox("All", 192, 144, 89, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
GUIStartGroup()
$Button23 = GUICtrlCreateButton("&OK", 65, 203, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetCursor(-1, 0)
$Button24 = GUICtrlCreateButton("&Cancel", 162, 203, 75, 25)
GUICtrlSetCursor(-1, 0)
#EndRegion ### END Koda GUI section ###

#Region ### START Koda GUI section ### Form=c:\users\whiggs\seafile\always script\form\paste.kxf
$Form2 = GUICreate("Form2", 300, 350, 433, 149, BitOR($GUI_SS_DEFAULT_GUI, $DS_SETFOREGROUND), $WS_EX_TOPMOST, $Form1_1)
$ListView2 = GUICtrlCreateListView("Data|Value", 0, 0, 300, 240, -1, BitOR($WS_EX_CLIENTEDGE, $LVS_EX_FULLROWSELECT, $LVS_EX_HEADERDRAGDROP, $LVS_EX_GRIDLINES, $LVS_EX_INFOTIP))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 150)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 150)
Global $Button16 = GUICtrlCreateButton("Start", 216, 264, 49, 49, $BS_DEFPUSHBUTTON)
GUICtrlSetCursor(-1, 0)
Global $Button17 = GUICtrlCreateButton("Back", 64, 264, 49, 49)
GUICtrlSetCursor(-1, 0)
$Button25 = GUICtrlCreateButton("", 136, 264, 49, 49, $BS_ICON)
GUICtrlSetImage(-1, $path & "\1_ClipboardHelpAndSpell.ico", -1)
GUICtrlSetCursor(-1, 0)
$Checkbox51 = GUICtrlCreateCheckbox("Clear Edit input before sending selected input", 32, 320, 257, 25)
#EndRegion ### END Koda GUI section ###
Global $iLVIndex_1 = _GUIListViewEx_Init($ListView2)
_GUIListViewEx_MsgRegister()
GUISetState(@SW_SHOW, $Form1_1)
$nMsg = 0
$hold = 0
;_GUIListViewEx_SetActive( $iLVIndex_1 )
While 1
	$tmsg = TrayGetMsg()
	Global $nMsg = GUIGetMsg(1)
	Switch $tmsg
		Case $TrayMenu
		Case $settings1
			#Region --- CodeWizard generated code Start ---

			;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=None
			MsgBox($MB_OK, "State", TrayItemGetState($settings1))
			#EndRegion --- CodeWizard generated code Start ---

			If TrayItemGetState($settings1) = 65 Then
				IniWrite($path & "\infostore.ini", "Tray Settings", "No Notifications", "65")
			ElseIf TrayItemGetState($settings1) = 68 Then
				IniWrite($path & "\infostore.ini", "Tray Settings", "No Notifications", "68")
			Else
			EndIf
		Case $settings2

			If TrayItemGetState($settings2) = 65 Then
				IniWrite($path & "\infostore.ini", "Tray Settings", "On top", "65")
				WinSetOnTop($Form1_1, "", $WINDOWS_ONTOP)
				WinSetOnTop($Form3, "", $WINDOWS_ONTOP)
				WinSetOnTop($Form3_1, "", $WINDOWS_ONTOP)
				WinSetOnTop($Form2, "", $WINDOWS_ONTOP)
				WinSetOnTop($Form4, "", $WINDOWS_ONTOP)
				WinSetOnTop($Form5, "", $WINDOWS_ONTOP)
			ElseIf TrayItemGetState($settings2) = 68 Then
				IniWrite($path & "\infostore.ini", "Tray Settings", "On top", "68")
				WinSetOnTop($Form1_1, "", $WINDOWS_NOONTOP)
				WinSetOnTop($Form3, "", $WINDOWS_NOONTOP)
				WinSetOnTop($Form3_1, "", $WINDOWS_NOONTOP)
				WinSetOnTop($Form4, "", $WINDOWS_NOONTOP)
				WinSetOnTop($Form5, "", $WINDOWS_NOONTOP)
				WinSetOnTop($Form2, "", $WINDOWS_ONTOP)
			Else
			EndIf

	EndSwitch

	Switch $nMsg[1]
		Case $Form1_1
			Switch $nMsg[0]
				Case $GUI_EVENT_CLOSE
					Exit
				Case $MenuItem1
				Case $MenuItem2

				Case $MenuItem3

				Case $MenuItem4

				Case $MenuItem13

				Case $MenuItem5

				Case $MenuItem6
				Case $MenuItem15
					GUISetState(@SW_HIDE, $Form1_1)
					GUISetState(@SW_DISABLE, $Form1_1)
					Edadd(False)
					GUISetState(@SW_SHOW, $Form1_1)
					GUISetState(@SW_ENABLE, $Form1_1)
				Case $MenuItem25
					GUISetState(@SW_HIDE, $Form1_1)
					GUISetState(@SW_DISABLE, $Form1_1)
					refadd(False)
					GUISetState(@SW_SHOW, $Form1_1)
					GUISetState(@SW_ENABLE, $Form1_1)
				Case $MenuItem32
					GUISetState(@SW_HIDE, $Form1_1)
					GUISetState(@SW_DISABLE, $Form1_1)
					compadd()
					GUISetState(@SW_SHOW, $Form1_1)
					GUISetState(@SW_ENABLE, $Form1_1)
				Case $MenuItem9
				Case $MenuItem10
					Send("{F1}", 0)
				Case $MenuItem11

				Case $MenuItem12
					$change = FileOpenDialog("Select your info file here.", @MyDocumentsDir, "Ini File (*.ini)", 3)
					$sdds = StringSplit($change, "")
					If $sdds[0] > 3 Then
						IniDelete($path & "\infostore.ini", "location", "info")
						IniWrite($path & "\infostore.ini", "location", "info", $change)
						#Region --- CodeWizard generated code Start ---

						;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info
						MsgBox($MB_OK + $MB_ICONASTERISK, "Save file changed", "You have successfully changed the information file used.  Program will restart to reflect updates.")
						#EndRegion --- CodeWizard generated code Start ---
						Exit 3
					Else
						#Region --- CodeWizard generated code Start ---

						;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=None
						MsgBox($MB_OK, "Invalid", "You did not select a valid file.  Nothing has changed.")
						#EndRegion --- CodeWizard generated code Start ---

					EndIf
				Case $MenuItem14


				Case $MenuItem16

				Case $MenuItem17
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the educational institution you select on the next screen already has an address assigned to it, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("School Address", "Please select the educational institution you would like to modify.", "Input the address you want to associate with the educational institution selected above.  It should be formatted as shown below.", "Street address and suite/apartment number" & @CRLF & "City, State Zip", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repl = SpellGUI(StringReplace($repl, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									$compnumva = $extend
									$split2 = StringSplit($repl, "\n", $STR_ENTIRESPLIT)
									If @error Then
										SetError(0)
										MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The string is not formatted correctly.  Try again.")
									Else
										$replstreet = StringStripWS($split2[1], 3)
										$split3 = StringSplit($split2[2], ",")
										If @error Then
											SetError(0)
											MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Try again.")
										Else
											$replcity = StringStripWS($split3[1], 3)
											$split4 = StringSplit(StringStripWS($split3[2], 3), " ")
											If @error Then
												SetError(0)
												MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Try again.")
											Else
												$replzip = $split4[$split4[0]]
												If $split4[0] = 2 Then
													$replstate = $split4[1]
												Else
													$replstate = $split4[1] & " " & $split4[2]
												EndIf
												IniWrite($storepath, "Education history " & $compnumva, "Street Address", encry($replstreet))
												IniWrite($storepath, "Education history " & $compnumva, "City", encry($replcity))
												IniWrite($storepath, "Education history " & $compnumva, "State", encry($replstate))
												IniWrite($storepath, "Education history " & $compnumva, "Zip code", encry($replzip))
											EndIf
										EndIf
									EndIf
								EndIf

							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)

						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem18
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the educational institution you select on the next screen already has a street address assigned to its address, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("School Street Address", "Please select the educational institution you would like to modify.", "Input the street address you want to associate with the address of the educational institution selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repl = SpellGUI(StringReplace($repl, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									$compnumva = $extend
									$repl = StringReplace($repl, "\n", "")
									IniWrite($storepath, "Education history " & $compnumva, "Street Address", encry($repl))
								EndIf
							EndIf

							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem19
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the educational institution you select on the next screen already has a city assigned to its address, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("School City", "Please select the educational institution you would like to modify.", "Input the city you want to associate with the addres of the educational institution selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repl = SpellGUI(StringReplace($repl, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									$compnumva = $extend
									$repl = StringReplace($repl, "\n", "")
									IniWrite($storepath, "Education history " & $compnumva, "City", encry($repl))
								EndIf
							EndIf

							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem20
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the educational institution you select on the next screen already has a state assigned to its address, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("School State", "Please select the educational institution you would like to modify.", "Input the state you want to associate with the address of the educational institution selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repl = SpellGUI(StringReplace($repl, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									$compnumva = $extend
									$repl = StringReplace($repl, "\n", "")
									IniWrite($storepath, "Education history " & $compnumva, "State", encry($repl))
								EndIf
							EndIf

							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem21
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the educational institution you select on the next screen already has a zip code assigned in its address, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("School Zip code", "Please select the educational institution you would like to modify.", "Input the zip code you want to associate with the address of the educational institution selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repl = SpellGUI(StringReplace($repl, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									$compnumva = $extend
									$repl = StringReplace($repl, "\n", "")
									IniWrite($storepath, "Education history " & $compnumva, "Zip code", encry($repl))
								EndIf
							EndIf

							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem22
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the educational institution you select on the next screen already has a phone number assigned to it, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("School Phone number", "Please select the educational institution you would like to modify.", "Input the phone number you want to associate with the educational institution selected above.", "", Default, $Form1_1)
							If @error Then
								GUISetState(@SW_SHOW, $Form1_1)
								GUISetState(@SW_ENABLE, $Form1_1)
							Else
								$compnumva = $extend
								$repl = StringReplace($repl, "\n", "")
								$nerray = 0
								Local $nerray[10]
								$aratore = 0
								$one = StringSplit(StringStripWS($repl, 3), "")
								For $hgg = 1 To $one[0] Step 1
									$chint = Int($one[$hgg])
									If $chint = 0 And $one[$hgg] <> "0" Then
										ContinueLoop
									EndIf
									If $aratore = 10 Then
										SetError(4)
										ExitLoop
									Else
										$nerray[$aratore] = $chint
										$aratore = $aratore + 1
									EndIf

								Next
								If @error Then
									SetError(0)
									MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "There are only 10 numbers in a standard telephone number.  Try again.")
								Else
									$lalaland = ""
									For $tu = 0 To 9 Step 1
										$lalaland = $lalaland & $nerray[$tu]
									Next
									IniWrite($storepath, "Education history " & $compnumva, "Phone number", encry($lalaland))
								EndIf
								GUISetState(@SW_SHOW, $Form1_1)
								GUISetState(@SW_ENABLE, $Form1_1)
							EndIf
						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem23
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the educational institution you select on the next screen already has your GPA associated with it, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("School GPA", "Please select the educational institution you would like to modify.", "Input the GPA you want to associate with the educational institution selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$compnumva = $extend
								$repl = StringReplace($repl, "\n", "")
								IniWrite($storepath, "Education history " & $compnumva, "GPA", encry($repl))
							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem24
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the educational institution you select on the next screen already has the degree you received associated with it, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("School degree", "Please select the educational institution you would like to modify.", "Input the degree you received while attending the educational institution selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repl = SpellGUI(StringReplace($repl, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									$compnumva = $extend
									$repl = StringReplace($repl, "\n", "")
									IniWrite($storepath, "Education history " & $compnumva, "Degree", encry($repl))
								EndIf
							EndIf

							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem26
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the reference you select on the next screen already has the company he/she works for associated with it, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Reference company", "Please select the reference you would like to modify.", "Input the company that the reference you selected above works at.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repl = SpellGUI(StringReplace($repl, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									$compnumva = $extend
									$repl = StringReplace($repl, "\n", "")
									IniWrite($storepath, "Reference " & $compnumva, "Company", encry($repl))
								EndIf
							EndIf

							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem27
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the reference you select on the next screen already has the description of your relationship with him/her associated with it, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Reference relationship", "Please select the reference you would like to modify.", "Input your relationship with the reference you selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repl = SpellGUI(StringReplace($repl, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									$compnumva = $extend
									$repl = StringReplace($repl, "\n", "")
									IniWrite($storepath, "Reference " & $compnumva, "Relationship", encry($repl))
								EndIf
							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem28
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the reference you select on the next screen already has the number of years you have known him/her associated with it, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Reference years known", "Please select the reference you would like to modify.", "Input the number of years you have been acquainted with the reference you selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$compnumva = $extend
								$repl = StringReplace($repl, "\n", "")
								IniWrite($storepath, "Reference " & $compnumva, "Years Known", encry($repl))
							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem29
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the reference you select on the next screen already has his/her title associated with it, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Reference title", "Please select the reference you would like to modify.", "Input the title held by the reference you selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repl = SpellGUI(StringReplace($repl, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									$compnumva = $extend
									$repl = StringReplace($repl, "\n", "")
									IniWrite($storepath, "Reference " & $compnumva, "Title", encry($repl))
								EndIf
							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem30
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the reference you select on the next screen already has a phone number associated with it, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Reference phone number", "Please select the reference you would like to modify.", "Input the phone number you would like to associate with the reference you selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$compnumva = $extend
								$repl = StringReplace($repl, "\n", "")
								$nerray = 0
								Local $nerray[10]
								$aratore = 0
								$one = StringSplit(StringStripWS($repl, 3), "")
								For $hgg = 1 To $one[0] Step 1
									$chint = Int($one[$hgg])
									If $chint = 0 And $one[$hgg] <> "0" Then
										ContinueLoop
									EndIf
									If $aratore = 10 Then
										SetError(3)
										ExitLoop
									Else
										$nerray[$aratore] = $chint
										$aratore = $aratore + 1
									EndIf

								Next
								If @error Then
									SetError(0)
									MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "There are only 10 numbers in a standard telephone number.  Try again.")
								Else
									$lalaland = ""
									For $tu = 0 To 9 Step 1
										$lalaland = $lalaland & $nerray[$tu]
									Next
									IniWrite($storepath, "Reference " & $compnumva, "Phone number", encry($lalaland))
								EndIf
							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem31
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the reference you select on the next screen already has an email address associated with it, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Reference email address", "Please select the reference you would like to modify.", "Input the email address you would like to associate with the reference you selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else

								$terr = $extend
								$repl = StringReplace($repl, "\n", "")
								If @error Or StringRegExp($repl, "^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)*)\.([A-Za-z]{2,})$") = 0 Then
									MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format?", "Make sure the email address that you entered is a valid email address.  Try again.")
								Else
									$compnumva = $terr
									IniWrite($storepath, "Reference " & $compnumva, "Email", encry($repl))
								EndIf
							EndIf

							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem33

				Case $MenuItem34
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the company you select on the next screen already has an address assigned to it, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Company Address", "Please select the company you would like to modify.", "Input the address you want to associate with the company selected above.  It should be formatted as shown below.", "Street address and suite/apartment number" & @CRLF & "City, State Zip", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repl = SpellGUI(StringReplace($repl, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									$compnumva = $extend
									$split2 = StringSplit($repl, "\n", $STR_ENTIRESPLIT)
									If @error Or $split2[0] < 2 Or $split2[0] > 3 Then
										SetError(0)
										MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The string is not formatted correctly.  Try again.")
									Else
										If $split2[0] = 2 Then

											$replstreet = StringStripWS($split2[1], 3)
											$split3 = StringSplit($split2[2], ",")
											If @error Then
												SetError(0)
												MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Separating the city failed.  Try again.")
											Else
												$replcity = StringStripWS($split3[1], 3)
												$split4 = StringSplit(StringStripWS($split3[2], 3), " ")
												If @error Then
													SetError(0)
													MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Separating the state and zip code failed.  Try again.")
												Else
													$replzip = $split4[$split4[0]]
													If $split4[0] = 2 Then
														$replstate = $split4[1]
													Else
														$replstate = $split4[1] & " " & $split4[2]
													EndIf
													IniWrite($storepath, "Company " & $compnumva, "Company street address", encry($replstreet))
													IniWrite($storepath, "Company " & $compnumva, "Company city", encry($replcity))
													IniWrite($storepath, "Company " & $compnumva, "Company state", encry($replstate))
													IniWrite($storepath, "Company " & $compnumva, "Company ZIP", encry($replzip))
												EndIf
											EndIf
										Else
											$replstreet = StringStripWS($split2[1], 3)
											$replsuite = StringStripWS($split2[2], 3)
											$split3 = StringSplit($split2[3], ",")
											If @error Then
												SetError(0)
												MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Separating the city failed.  Try again.")
											Else
												$replcity = StringStripWS($split3[1], 3)
												$split4 = StringSplit(StringStripWS($split3[2], 3), " ")
												If @error Then
													SetError(0)
													MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Separating the state and zip code failed.  Try again.")
												Else
													$replzip = $split4[$split4[0]]
													If $split4[0] = 2 Then
														$replstate = $split4[1]
													Else
														$replstate = $split4[1] & " " & $split4[2]
													EndIf
													IniWrite($storepath, "Company " & $compnumva, "Company street address", encry($replstreet))
													IniWrite($storepath, "Company " & $compnumva, "Company suite number", encry($replsuite))
													IniWrite($storepath, "Company " & $compnumva, "Company city", encry($replcity))
													IniWrite($storepath, "Company " & $compnumva, "Company state", encry($replstate))
													IniWrite($storepath, "Company " & $compnumva, "Company ZIP", encry($replzip))
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf

							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)

						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem35
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the company you select on the next screen already has a street address assigned to its address, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Company Street Address", "Please select the company you would like to modify.", "Input the street address you want to associate with the address of the company selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repl = SpellGUI(StringReplace($repl, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									$compnumva = $extend
									$repl = StringReplace($repl, "\n", "")
									IniWrite($storepath, "Company " & $compnumva, "Company street address", encry($repl))
								EndIf
							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect
				Case $MenuItem36
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the company you select on the next screen already has a city assigned to its address, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Company City", "Please select the company you would like to modify.", "Input the City you want to associate with the address of the company selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repl = SpellGUI(StringReplace($repl, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									$compnumva = $extend
									$repl = StringReplace($repl, "\n", "")
									IniWrite($storepath, "Company " & $compnumva, "Company city", encry($repl))
								EndIf
							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect
				Case $MenuItem37
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the company you select on the next screen already has a state assigned to its address, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Company State", "Please select the company you would like to modify.", "Input the state you want to associate with the address of the company selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repl = SpellGUI(StringReplace($repl, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									$compnumva = $extend
									$repl = StringReplace($repl, "\n", "")
									IniWrite($storepath, "Company " & $compnumva, "Company state", encry($repl))
								EndIf
							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem38
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the company you select on the next screen already has ZIP code assigned to its address, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Company ZIP Code", "Please select the company you would like to modify.", "Input the ZIP Code you want to associate with the address of the company selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$compnumva = $extend
								$repl = StringReplace($repl, "\n", "")
								IniWrite($storepath, "Company " & $compnumva, "Company ZIP", encry($repl))
							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect
				Case $MenuItem39
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the company you select on the next screen already has a phone number assigned to it, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Company Phone number", "Please select the company you would like to modify.", "Input the phone number you want to associate with the company selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
								GUISetState(@SW_SHOW, $Form1_1)
								GUISetState(@SW_ENABLE, $Form1_1)
							Else
								$compnumva = $extend
								$repl = StringReplace($repl, "\n", "")
								$nerray = 0
								Local $nerray[10]
								$aratore = 0
								$one = StringSplit(StringStripWS($repl, 3), "")
								For $hgg = 1 To $one[0] Step 1
									$chint = Int($one[$hgg])
									If $chint = 0 And $one[$hgg] <> "0" Then
										ContinueLoop
									EndIf
									If $aratore = 10 Then
										SetError(3)
										ExitLoop
									Else
										$nerray[$aratore] = $chint
										$aratore = $aratore + 1
									EndIf

								Next
								If @error Then
									SetError(0)
									MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "There are only 10 numbers in a standard telephone number.  Try again.")
								Else
									$lalaland = ""
									For $tu = 0 To 9 Step 1
										$lalaland = $lalaland & $nerray[$tu]
									Next
									IniWrite($storepath, "Company " & $compnumva, "Company phone", encry($lalaland))
								EndIf
								GUISetState(@SW_SHOW, $Form1_1)
								GUISetState(@SW_ENABLE, $Form1_1)
							EndIf
						Case $iMsgBoxAnswer = $IDNO

					EndSelect
				Case $MenuItem40
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the company you select on the next screen already has a value associated with your title while employed with the company, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Company title", "Please select the company you would like to modify.", "Input the title you held/hold that you want to associate with the company selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repl = SpellGUI(StringReplace($repl, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									$compnumva = $extend
									$repl = StringReplace($repl, "\n", "")
									IniWrite($storepath, "Company " & $compnumva, "Company title", encry($repl))
								EndIf
							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect
				Case $MenuItem41
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the company you select on the next screen already has a value associated with your job description, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Company job description", "Please select the company you would like to modify.", "Input a description of the tasks/duties performed that you want to associate with the company selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repl = SpellGUI(StringReplace($repl, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									$compnumva = $extend
									IniWrite($storepath, "Company " & $compnumva, "Company job description", encry($repl))
								EndIf
							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem42
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the company you select on the next screen already has a value associated with your start date and end date, these values will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Company Start Date", "Please select the company you would like to modify.", "Input the start date that you want to associate with the company selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$compnumva = $extend
								$repl2 = _MLInputBox("Company End Date", Default, "Input the end date that you want to associate with the company previously selected.", "", Default, $Form1_1)
								If @error Then
									SetError(0)
								Else
									$repl = StringReplace($repl, "\n", "")
									$repl2 = StringReplace($repl2, "\n", "")
									IniWrite($storepath, "Company " & $compnumva, "Company start", encry($repl))
									IniWrite($storepath, "Company " & $compnumva, "Company end", encry($repl2))
								EndIf
							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem43
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the company you select on the next screen already has a value associated with your pay, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Company Pay", "Please select the company you would like to modify.", "Input your rate of pay that you want to associate with the company selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$compnumva = $extend
								$repl = StringReplace($repl, "\n", "")
								IniWrite($storepath, "Company " & $compnumva, "Company salary", encry($repl))
							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $MenuItem44
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If the company you select on the next screen already has a value associated with your reason for leaving, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Company Reason left", "Please select the company you would like to modify.", "Explain why you are no longer with the company that you have selected above.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repl = SpellGUI(StringReplace($repl, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									$compnumva = $extend
									IniWrite($storepath, "Company " & $compnumva, "Company reason left", encry($repl))
								EndIf
							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect
				Case $MenuItem45
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If you already have a cover letter stored, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repp = _MLInputBox("Cover letter", Default, "Input your cover letter below.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repp = SpellGUI(StringReplace($repp, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									IniWrite($storepath, "Cover Letter", "Cover letter", encry($repp))
								EndIf
							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect
				Case $MenuItem46
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "If you already have an objective stored, it will be overwritten.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repp = _MLInputBox("Objective", Default, "Input your objective below.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repp = SpellGUI(StringReplace($repp, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									IniWrite($storepath, "Objective", "Objective", encry($repp))
								EndIf
							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect
				Case $MenuItem47
					GUISetState(@SW_HIDE, $Form1_1)
					GUISetState(@SW_DISABLE, $Form1_1)
					usernames(False)
					GUISetState(@SW_SHOW, $Form1_1)
					GUISetState(@SW_ENABLE, $Form1_1)
				Case $MenuItem48
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "This will overwrite the username you select on the next screen.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("User name", "Please select the user name you would like to modify.", "Input the new user name.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$compnumva = $extend
								$repl = StringReplace($repl, "\n", "")
								IniWrite($storepath, "User Names", "User name " & $compnumva, encry($repl))
							EndIf

							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect
				Case $MenuItem49
					GUISetState(@SW_HIDE, $Form1_1)
					GUISetState(@SW_DISABLE, $Form1_1)
					emailadd(False)
					GUISetState(@SW_SHOW, $Form1_1)
					GUISetState(@SW_ENABLE, $Form1_1)

				Case $MenuItem50
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "This will overwrite the personal email address you select on the next screen.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Personal Email", "Please select the personal email address you would like to modify.", "Input the new personal email address.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$compnumva = $extend
								$repl = StringReplace($repl, "\n", "")
								IniWrite($storepath, "Email", "Email " & $compnumva, encry($repl))
							EndIf

							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect
				Case $MenuItem51
					GUISetState(@SW_HIDE, $Form1_1)
					GUISetState(@SW_DISABLE, $Form1_1)
					passx(False)
					GUISetState(@SW_SHOW, $Form1_1)
					GUISetState(@SW_ENABLE, $Form1_1)
				Case $MenuItem52
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "This will overwrite the password you select on the next screen.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Password", "Please select the password you would like to modify.", "Input the new password.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$compnumva = $extend
								$repl = StringReplace($repl, "\n", "")
								IniWrite($storepath, "Password", "Password " & $compnumva, encry($repl))
							EndIf

							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect
				Case $MenuItem53
					GUISetState(@SW_HIDE, $Form1_1)
					GUISetState(@SW_DISABLE, $Form1_1)
					phoneadd(False)
					GUISetState(@SW_SHOW, $Form1_1)
					GUISetState(@SW_ENABLE, $Form1_1)
				Case $MenuItem54
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "This will overwrite the personal phone number you select on the next screen.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Personal phone", "Please select the personal phone number you would like to modify.", "Input the new personal phone number.", "", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$compnumva = $extend
								$repl = StringReplace($repl, "\n", "")
								IniWrite($storepath, "Phone number", "Phone number " & $compnumva, encry($repl))
							EndIf

							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect
				Case $MenuItem55
					GUISetState(@SW_HIDE, $Form1_1)
					GUISetState(@SW_DISABLE, $Form1_1)
					addwebsite(False)
					GUISetState(@SW_SHOW, $Form1_1)
					GUISetState(@SW_ENABLE, $Form1_1)
				Case $MenuItem56
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "This will overwrite the website you select on the next screen.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Website", "Please select the website you would like to modify.", "Input the new website.", "", Default, $Form1_1)
							$compnumva = @extended
							If @error Then
								SetError(0)
							Else

								$repl = StringReplace($repl, "\n", "")
								IniWrite($storepath, "Websites", "Website " & $compnumva, encry($repl))
							EndIf

							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
						Case $iMsgBoxAnswer = $IDNO

					EndSelect
				Case $MenuItem57
					GUISetState(@SW_HIDE, $Form1_1)
					GUISetState(@SW_DISABLE, $Form1_1)
					addradd(False)
					GUISetState(@SW_SHOW, $Form1_1)
					GUISetState(@SW_ENABLE, $Form1_1)
				Case $MenuItem58
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION + $MB_SYSTEMMODAL, "Are you sure?", "This will overwrite the personal address you select on the next screen.  Do you want to continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							GUISetState(@SW_HIDE, $Form1_1)
							GUISetState(@SW_DISABLE, $Form1_1)
							$repl = _MLInputBox("Personal Address", "Please select the personal address you would like to modify.", "Input the new personal address.  It should be formatted as shown below.", "Title for new address" & @CRLF & "Street address and suite/apartment number" & @CRLF & "City, State Zip", Default, $Form1_1)
							If @error Then
								SetError(0)
							Else
								$repl = SpellGUI(StringReplace($repl, "\n", @CRLF))
								If @error Then
									SetError(0)
								Else
									$compnumva = $extend
									$split5 = StringSplit($repl, "\n", $STR_ENTIRESPLIT)
									If @error Or $split5[0] > 3 Then
										SetError(0)
										MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The string is not formatted correctly.  Try again.")
									Else
										$replname = StringStripWS($split5[1], 3)
										$replstreet = StringStripWS($split5[2], 3)
										$split6 = StringSplit($split5[3], ",")
										If @error Then
											SetError(0)
											MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Separating the city failed.  Try again.")
										Else
											$replcity = StringStripWS($split6[1], 3)
											$split7 = StringSplit(StringStripWS($split6[2], 3), " ")
											If @error Then
												SetError(0)
												MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Separating the state and zip code failed.  Try again.")
											Else
												$replzip = $split7[$split7[0]]
												If $split7[0] = 2 Then
													$replstate = $split7[1]
												Else
													$replstate = $split7[1] & " " & $split7[2]
												EndIf
												IniWrite($storepath, "Address " & $compnumva, "Name", encry($replname))
												IniWrite($storepath, "Address " & $compnumva, "Street", encry($replstreet))
												IniWrite($storepath, "Address " & $compnumva, "City", encry($replcity))
												IniWrite($storepath, "Address " & $compnumva, "State", encry($replstate))
												IniWrite($storepath, "Address " & $compnumva, "Zip", encry($replzip))
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
							GUISetState(@SW_SHOW, $Form1_1)
							GUISetState(@SW_ENABLE, $Form1_1)
					EndSelect
				Case $menuitem60
					If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
					$sInputBoxAnswer = InputBox("Title", "What title would you like to give this entry?")
					If @error <> 0 Or $sInputBoxAnswer = "" Or $sInputBoxAnswer = Null Then

					Else
						_MLInputBox("Misc Text", Default, "Please enter the text for the new misc item", "Title for new address" & @CRLF & "Street address and suite/apartment number" & @CRLF & "City, State Zip", Default, $Form1_1)
					EndIf


				Case $Checkbox1
					If GUICtrlRead($Checkbox1) = 1 Then
						ToolTip("")
						$RadioVal = ""
						GUICtrlSetState($Radio1, $GUI_SHOW)
						GUICtrlSetState($Radio1, $GUI_ENABLE)
						GUICtrlSetState($Radio2, $GUI_SHOW)
						GUICtrlSetState($Radio2, $GUI_ENABLE)
						GUICtrlSetState($Radio3, $GUI_SHOW)
						GUICtrlSetState($Radio3, $GUI_ENABLE)
						GUICtrlSetState($Radio4, $GUI_SHOW)
						GUICtrlSetState($Radio4, $GUI_ENABLE)
						GUICtrlSetState($Button1, $GUI_SHOW)
						GUICtrlSetState($Button1, $GUI_ENABLE)
					Else
						ToolTip("")
						GUICtrlSetState($Radio1, $GUI_UNCHECKED)
						GUICtrlSetState($Radio1, $GUI_HIDE)
						GUICtrlSetState($Radio1, $GUI_DISABLE)
						GUICtrlSetState($Radio2, $GUI_UNCHECKED)
						GUICtrlSetState($Radio2, $GUI_HIDE)
						GUICtrlSetState($Radio2, $GUI_DISABLE)
						GUICtrlSetState($Radio3, $GUI_UNCHECKED)
						GUICtrlSetState($Radio3, $GUI_HIDE)
						GUICtrlSetState($Radio3, $GUI_DISABLE)
						GUICtrlSetState($Radio4, $GUI_UNCHECKED)
						GUICtrlSetState($Radio4, $GUI_HIDE)
						GUICtrlSetState($Radio4, $GUI_DISABLE)
						GUICtrlSetState($Button1, $GUI_HIDE)
						GUICtrlSetState($Button1, $GUI_DISABLE)
					EndIf
				Case $Radio1
					ToolTip("")
					If GUICtrlRead($Radio1) = 1 Then
						Global $RadioVal[2][1]
						$RadioVal[0][0] = "Full Name"
						$RadioVal[1][0] = BinaryToString(decry(IniRead($storepath, "Name", "First", "Null"))) & " " & BinaryToString(decry(IniRead($storepath, "Name", "Last", "Null")))
					EndIf

				Case $Radio2
					ToolTip("")
					If GUICtrlRead($Radio2) = 1 Then
						Global $RadioVal[2][1]
						$RadioVal[0][0] = "First name"
						$RadioVal[1][0] = BinaryToString(decry(IniRead($storepath, "Name", "First", "Null")))
					EndIf
				Case $Radio3
					ToolTip("")
					If GUICtrlRead($Radio3) = 1 Then
						Global $RadioVal[2][1]
						$RadioVal[0][0] = "Last name"
						$RadioVal[1][0] = BinaryToString(decry(IniRead($storepath, "Name", "Last", "Null")))
					EndIf
				Case $Radio4
					ToolTip("")
					If GUICtrlRead($Radio4) = 1 Then
						Global $RadioVal[2][2]
						$RadioVal[0][0] = "First name"
						$RadioVal[1][0] = BinaryToString(decry(IniRead($storepath, "Name", "First", "Null")))
						$RadioVal[0][1] = "Last name"
						$RadioVal[1][1] = BinaryToString(decry(IniRead($storepath, "Name", "Last", "Null")))
					EndIf
				Case $Button1
					If $RadioVal = "" Then
						#Region --- CodeWizard generated code Start ---
						;ToolTip features: Text=Yes, X Coordinate=Default, Y Coordinate=Default, Title=Yes, Error icon
						If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
						$sToolTipAnswer = ToolTip("You need to select a valid choice in order to submit this request.", Default, Default, "Make a selection", 3, 0)
						#EndRegion --- CodeWizard generated code Start ---
					Else
						ToolTip("")
						If UBound($RadioVal, $UBOUND_COLUMNS) = 1 Then
							$Listinput1 = GUICtrlCreateListViewItem($RadioVal[0][0] & "|" & $RadioVal[1][0], $ListView1)
						ElseIf UBound($RadioVal, $UBOUND_COLUMNS) > 1 Then
							$Listinput1 = GUICtrlCreateListViewItem($RadioVal[0][0] & "|" & $RadioVal[1][0], $ListView1)
							$Listinput2 = GUICtrlCreateListViewItem($RadioVal[0][1] & "|" & $RadioVal[1][1], $ListView1)
						Else
							#Region --- CodeWizard generated code Start ---

							;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=None
							MsgBox($MB_OK, "Error", "Try again")
							#EndRegion --- CodeWizard generated code Start ---
						EndIf
					EndIf



				Case $Checkbox2
					ToolTip("")
					If GUICtrlRead($Checkbox2) = 1 Then
						GUICtrlSetState($Combo1, $GUI_SHOW)
						GUICtrlSetState($Combo1, $GUI_ENABLE)
						GUICtrlSetState($Button2, $GUI_SHOW)
						GUICtrlSetState($Button2, $GUI_ENABLE)
					Else
						GUICtrlSetState($Combo1, $GUI_HIDE)
						GUICtrlSetState($Combo1, $GUI_DISABLE)
						GUICtrlSetState($Button2, $GUI_HIDE)
						GUICtrlSetState($Button2, $GUI_DISABLE)
					EndIf
				Case $Combo1
					If GUICtrlGetState($Combo1) = 80 Then
						ToolTip("")
						Global $ComboVal[2][1]
						$ComboVal[0][0] = "Username"
						$ComboVal[1][0] = GUICtrlRead($Combo1)
						$Listinput3 = GUICtrlCreateListViewItem($ComboVal[0][0] & "|" & $ComboVal[1][0], $ListView1)
					EndIf
				Case $Button2
					If GUICtrlRead($Combo1) == "" Then
						#Region --- CodeWizard generated code Start ---
						;ToolTip features: Text=Yes, X Coordinate=Default, Y Coordinate=Default, Title=Yes, Error icon
						If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
						$sToolTipAnswer = ToolTip("You need to select a valid choice in order to submit this request.", Default, Default, "Make a selection", 3, 0)
						#EndRegion --- CodeWizard generated code Start ---
					Else
						ToolTip("")
						$Listinput3 = GUICtrlCreateListViewItem($ComboVal[0][0] & "|" & $ComboVal[1][0], $ListView1)
					EndIf

				Case $Checkbox3
					ToolTip("")
					If GUICtrlRead($Checkbox3) = 1 Then
						GUICtrlSetState($Combo2, $GUI_SHOW)
						GUICtrlSetState($Combo2, $GUI_ENABLE)
						GUICtrlSetState($Button3, $GUI_SHOW)
						GUICtrlSetState($Button3, $GUI_ENABLE)
					Else
						GUICtrlSetState($Combo2, $GUI_HIDE)
						GUICtrlSetState($Combo2, $GUI_DISABLE)
						GUICtrlSetState($Button3, $GUI_HIDE)
						GUICtrlSetState($Button3, $GUI_DISABLE)
					EndIf
				Case $Combo2
					ToolTip("")
					If GUICtrlGetState($Combo2) = 80 Then
						Global $ComboVal2[2][1]
						$ComboVal2[0][0] = "Email"
						$ComboVal2[1][0] = GUICtrlRead($Combo2)
						$Listinput4 = GUICtrlCreateListViewItem($ComboVal2[0][0] & "|" & $ComboVal2[1][0], $ListView1)
					EndIf
				Case $Button3
					If GUICtrlRead($Combo2) == "" Then
						#Region --- CodeWizard generated code Start ---
						;ToolTip features: Text=Yes, X Coordinate=Default, Y Coordinate=Default, Title=Yes, Error icon
						If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
						$sToolTipAnswer = ToolTip("You need to select a valid choice in order to submit this request.", Default, Default, "Make a selection", 3, 0)
						#EndRegion --- CodeWizard generated code Start ---
					Else
						ToolTip("")
						$Listinput4 = GUICtrlCreateListViewItem($ComboVal2[0][0] & "|" & $ComboVal2[1][0], $ListView1)
					EndIf

				Case $Checkbox4
					ToolTip("")
					If GUICtrlRead($Checkbox4) = 1 Then
						GUICtrlSetState($Combo3, $GUI_SHOW)
						GUICtrlSetState($Combo3, $GUI_ENABLE)
						GUICtrlSetState($checkbox61, $GUI_SHOW)
						GUICtrlSetState($checkbox61, $GUI_ENABLE)
						GUICtrlSetState($Button4, $GUI_SHOW)
						GUICtrlSetState($Button4, $GUI_ENABLE)
					Else
						GUICtrlSetState($Combo3, $GUI_HIDE)
						GUICtrlSetState($Combo3, $GUI_DISABLE)
						GUICtrlSetState($checkbox61, $GUI_HIDE)
						GUICtrlSetState($checkbox61, $GUI_DISABLE)
						GUICtrlSetState($Button4, $GUI_HIDE)
						GUICtrlSetState($Button4, $GUI_DISABLE)
					EndIf
				Case $Combo3
					ToolTip("")
					If GUICtrlGetState($Combo3) = 80 Then
						Global $ComboVal3[2][1]
						$ComboVal3[0][0] = "Password"
						$ComboVal3[1][0] = GUICtrlRead($Combo3)
						$Listinput5 = GUICtrlCreateListViewItem($ComboVal3[0][0] & "|" & $ComboVal3[1][0], $ListView1)
					EndIf
				Case $checkbox61
					#cs
					If _GUICtrlComboBox_GetCurSel ( $Combo3 ) <> -1 Then
						$curselectindex = _GUICtrlComboBox_GetCurSel ( $Combo3 )
					Else
						$curselectindex = Null
					EndIf

					If GUICtrlRead($Checkbox61) = 1 Then
						_GUICtrlComboBox_BeginUpdate ( $Combo3 )
						_GUICtrlComboBox_ResetContent ( $Combo3 )
						For $mom = 0 To UBound ( $passarray, $UBOUND_ROWS ) - 1 Step 1
							_GUICtrlComboBox_AddString ( $Combo3, $passarray[$mom][0] )
						Next
						_GUICtrlComboBox_EndUpdate ( $Combo3 )
						If $curselectindex <> Null Then
							_GUICtrlComboBox_SetCurSel ( $Combo3, $curselectindex )
						EndIf
						If IsDeclared ( "gllistview" ) Then



					Else
						_GUICtrlComboBox_BeginUpdate ( $Combo3 )
						_GUICtrlComboBox_ResetContent ( $Combo3 )
						For $mom = 0 To UBound ( $passarray, $UBOUND_ROWS ) - 1 Step 1
							_GUICtrlComboBox_AddString ( $Combo3, $passarray[$mom][1] )
						Next
						_GUICtrlComboBox_EndUpdate ( $Combo3 )
						If $curselectindex <> Null Then
							_GUICtrlComboBox_SetCurSel ( $Combo3, $curselectindex )
						EndIf

					EndIf
					#ce
				Case $Button4
					If GUICtrlRead($Combo3) == "" Then
						#Region --- CodeWizard generated code Start ---
						;ToolTip features: Text=Yes, X Coordinate=Default, Y Coordinate=Default, Title=Yes, Error icon
						If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
						$sToolTipAnswer = ToolTip("You need to select a valid choice in order to submit this request.", Default, Default, "Make a selection", 3, 0)
						#EndRegion --- CodeWizard generated code Start ---
					Else
						ToolTip("")
						$Listinput5 = GUICtrlCreateListViewItem($ComboVal3[0][0] & "|" & $ComboVal3[1][0], $ListView1)
					EndIf
				Case $Checkbox6
					GUISetState(@SW_HIDE, $Form1_1)
					GUISetState(@SW_DISABLE, $Form1_1)
					GUISwitch($Form4)
					GUISetState(@SW_SHOW, $Form4)
					GUISetState(@SW_ENABLE, $Form4)
				Case $Checkbox7
					ToolTip("")
					If GUICtrlRead($Checkbox7) = 1 Then
						GUICtrlSetState($Combo5, $GUI_SHOW)
						GUICtrlSetState($Combo5, $GUI_ENABLE)
						GUICtrlSetState($Button7, $GUI_SHOW)
						GUICtrlSetState($Button7, $GUI_ENABLE)
					Else
						GUICtrlSetState($Combo5, $GUI_HIDE)
						GUICtrlSetState($Combo5, $GUI_DISABLE)
						GUICtrlSetState($Button7, $GUI_HIDE)
						GUICtrlSetState($Button7, $GUI_DISABLE)
					EndIf
				Case $Combo5
					ToolTip("")
					If GUICtrlGetState($Combo5) = 80 Then
						Global $ComboVal4[2][1]
						$ComboVal4[0][0] = "Phone number"
						$ComboVal4[1][0] = GUICtrlRead($Combo5)
						$Listinput7 = GUICtrlCreateListViewItem($ComboVal4[0][0] & "|" & $ComboVal4[1][0], $ListView1)
					EndIf
				Case $Button7
					If GUICtrlRead($Combo5) == "" Then
						#Region --- CodeWizard generated code Start ---
						;ToolTip features: Text=Yes, X Coordinate=Default, Y Coordinate=Default, Title=Yes, Error icon
						If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
						$sToolTipAnswer = ToolTip("You need to select a valid choice in order to submit this request.", Default, Default, "Make a selection", 3, 0)
						#EndRegion --- CodeWizard generated code Start ---
					Else
						ToolTip("")
						$Listinput7 = GUICtrlCreateListViewItem($ComboVal4[0][0] & "|" & $ComboVal4[1][0], $ListView1)
					EndIf
				Case $Checkbox8
					ToolTip("")
					GUISetState(@SW_HIDE, $Form1_1)
					GUISwitch($Form3_1)
					GUISetState(@SW_SHOW, $Form3_1)
				Case $Checkbox5
					ToolTip("")
					GUISetState(@SW_HIDE, $Form1_1)
					GUISwitch($Form5)
					GUISetState(@SW_SHOW, $Form5)


					;Case $Checkbox9
					;Case $Checkbox10
					;Case $Button8
				Case $Checkbox11
					ToolTip("")
					GUISetState(@SW_HIDE, $Form1_1)
					GUISwitch($Form3)
					GUISetState(@SW_SHOW, $Form3)
				Case $Checkbox50
					ToolTip("")
					If GUICtrlRead($Checkbox50) = 1 Then
						GUICtrlSetState($Combo6, $GUI_SHOW)
						GUICtrlSetState($Combo6, $GUI_ENABLE)
						GUICtrlSetState($Button27, $GUI_SHOW)
						GUICtrlSetState($Button27, $GUI_ENABLE)
					Else
						GUICtrlSetState($Combo6, $GUI_HIDE)
						GUICtrlSetState($Combo6, $GUI_DISABLE)
						GUICtrlSetState($Button27, $GUI_HIDE)
						GUICtrlSetState($Button27, $GUI_DISABLE)
					EndIf
					#cs
									Case $Checkbox60
										If GUICtrlRead ( $Checkbox60 ) = 1 Then

										Else

										EndIf
					#ce
				Case $Combo6
					ToolTip("")
					If GUICtrlGetState($Combo6) = 80 Then
						Global $ComboVal5[2][1]
						$ComboVal5[0][0] = "Website"
						$ComboVal5[1][0] = GUICtrlRead($Combo6)
						$Listinput83 = GUICtrlCreateListViewItem($ComboVal5[0][0] & "|" & $ComboVal5[1][0], $ListView1)
					EndIf

				Case $Button27
					If GUICtrlRead($Combo6) == "" Then
						#Region --- CodeWizard generated code Start ---
						;ToolTip features: Text=Yes, X Coordinate=Default, Y Coordinate=Default, Title=Yes, Error icon
						If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
						$sToolTipAnswer = ToolTip("You need to select a valid choice in order to submit this request.", Default, Default, "Make a selection", 3, 0)
						#EndRegion --- CodeWizard generated code Start ---
					Else
						ToolTip("")
						$Listinput83 = GUICtrlCreateListViewItem($ComboVal5[0][0] & "|" & $ComboVal5[1][0], $ListView1)
					EndIf

				Case $Button11
					ToolTip("")
					;If ProcessExists ( "pastebutt.exe" ) = 0 Then
					;FileInstall ( "C:\Users\whiggs\Seafile\always script\PasteButton.exe", $temp & "\pastebutt.exe" )
					;ShellExecute ( "pastebutt.exe","", $temp )
					;EndIf
					;ProcessWait ( "pastebutt.exe", 5 )
					If _GUICtrlListView_GetItemCount($ListView1) > 0 Then
						GUISetState(@SW_HIDE, $Form1_1)
						_GUICtrlListView_SetItemSelected($ListView1, -1, True)
						$listviewcount = _GUICtrlListView_GetItemCount($ListView1)
						For $lp = 0 To $listviewcount - 1 Step 1
							$temptext = _GUICtrlListView_GetItemTextArray($ListView1, $lp)
							_ArrayDelete($temptext, 0)
							_GUIListViewEx_Insert($temptext)
						Next

						GUISwitch($Form2)
						;_GUICtrlListView_CopyItems(GUICtrlGetHandle($ListView1), GUICtrlGetHandle($ListView2))
						GUISetState(@SW_SHOW, $Form2)
						_GUICtrlListView_SetItemSelected($ListView2, 0, True, False)
						;$listviewar = _GUIListViewEx_ReadToArray ( $ListView2 )
						;$iLVIndex_1 = _GUIListViewEx_Init ( $ListView2, $listviewar, Default, Default, True, 1 + 2 + 8 )
						;_GUIListViewEx_MsgRegister()
					Else
						#Region --- CodeWizard generated code Start ---

						;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info
						MsgBox($MB_OK + $MB_ICONASTERISK, "Data needed", "You need to add some data to the list to use the paste feature.")
						#EndRegion --- CodeWizard generated code Start ---
					EndIf

				Case $Button12
					ToolTip("")
					_GUICtrlListView_DeleteAllItems($ListView1)

				Case $ListView1
					ToolTip("")
				Case $Button18
					ToolTip("")
					;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=None, Modality=Task Modal
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_TASKMODAL, "Are you sure?", "This function will export all of your data, unencrypted, to a text file to simplify the removal of obsolete entries.  Are you sure you want to do this?  Please be sure to delete the txt file after you import it if so." & @CRLF & "Continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							$export = FileSaveDialog("Where do you want to save exported data file?", @MyDocumentsDir, "Text files (*.txt)", 18, "export_data.txt", $Form1_1)
							If $export == "" Then

							Else

								$exp_data = FileOpen($export, $FO_APPEND)
								$sec_names = IniReadSectionNames($storepath)
								For $lk = 1 To $sec_names[0] Step 1
									If $sec_names[$lk] = "Hold Num" Then
										ContinueLoop
									EndIf
									FileWriteLine($exp_data, $sec_names[$lk])
									$all_info = IniReadSection($storepath, $sec_names[$lk])
									For $rk = 1 To $all_info[0][0] Step 1
										If StringLeft($all_info[$rk][1], 2) == "0x" Then
											FileWriteLine($exp_data, $all_info[$rk][0] & ":" & BinaryToString(decry($all_info[$rk][1])))
										Else
											FileWriteLine($exp_data, $all_info[$rk][0] & ":" & $all_info[$rk][1])
										EndIf

									Next
								Next
								FileClose($exp_data)
							EndIf


						Case $iMsgBoxAnswer = $IDNO

					EndSelect

				Case $Button26
					ToolTip("")
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_TASKMODAL, "Are you sure?", "This function will rename your current config file and will recreate a new one using the information in the text file you select.  Are you sure you want to do this?  Please be sure to delete the txt file after you import it if so." & @CRLF & "Continue?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							$backfile = FileSelectFolder("Select where to save backup file", "")
							$backfile = $backfile & "\login.backini"
							FileMove($storepath, $backfile, $FC_OVERWRITE)
							$import = FileOpenDialog("Select the file containing exported data.", "", "Text files (*.txt)", 3, "export_data.txt", $Form1_1)
							$imp_data = FileReadToArray($import)
							For $tee = 0 To UBound($imp_data) - 1 Step 1
								If StringInStr($imp_data[$tee], "*") > 0 Then
									$imp_data[$tee] = StringTrimRight($imp_data[$tee], 1)
								EndIf
							Next
							For $gjj = 0 To UBound($imp_data) - 1 Step 1
								If StringInStr($imp_data[$gjj], ":") = 0 Then
									$inihead = $imp_data[$gjj]
									ContinueLoop
								Else
									$split = StringSplit($imp_data[$gjj], ":")
									If $split[0] > 2 Then
										$link = ""
										For $ted = 2 To $split[0] Step 1
											$link = $link & $split[$ted] & ":"
										Next
										$split[2] = StringTrimRight($link, 1)
									EndIf
									IniWrite($storepath, $inihead, $split[1], encry($split[2]))
								EndIf
							Next
							$emailcount = _ArrayFindAll($imp_data, "Email", Default, Default, Default, 1)
							$usercount = _ArrayFindAll($imp_data, "User name", Default, Default, Default, 1)
							$passcount = _ArrayFindAll($imp_data, "Password", Default, Default, Default, 1)
							$addresscount = _ArrayFindAll($imp_data, "Address", Default, Default, Default, 1)
							$phonecount = _ArrayFindAll($imp_data, "Phone number", Default, Default, Default, 1)
							$edcount = _ArrayFindAll($imp_data, "Education history", Default, Default, Default, 1)
							$compcount = _ArrayFindAll($imp_data, "Company", Default, Default, Default, 1)
							;regexp "Company\h\d+"
							$refcount = _ArrayFindAll($imp_data, "Reference", Default, Default, Default, 1)
							$webcount = _ArrayFindAll($imp_data, "Website", Default, Default, Default, 1)
							$newhold = 0
							For $t = 0 To UBound($emailcount) - 1 Step 1
								$newsplit = StringSplit($imp_data[$emailcount[$t]], ":")
								If @error Then
									SetError(0)
									ContinueLoop
								Else
									$regex = StringRegExp($newsplit[1], "Email\h\d+")
									If $regex = 1 Then
										$newhold += 1
										ContinueLoop
									Else
										ContinueLoop
									EndIf
								EndIf
							Next
							If $newhold > 0 Then
								IniWrite($storepath, "Hold Num", "Email number", $newhold)
								$newhold = 0
							EndIf
							For $t = 0 To UBound($usercount) - 1 Step 1
								$newsplit = StringSplit($imp_data[$usercount[$t]], ":")
								If @error Then
									SetError(0)
									ContinueLoop
								Else
									$regex = StringRegExp($newsplit[1], "User name\h\d+")
									If $regex = 1 Then
										$newhold += 1
										ContinueLoop
									Else
										ContinueLoop
									EndIf
								EndIf
							Next
							If $newhold > 0 Then
								IniWrite($storepath, "Hold Num", "User number", $newhold)
								$newhold = 0
							EndIf
							For $t = 0 To UBound($passcount) - 1 Step 1
								$newsplit = StringSplit($imp_data[$passcount[$t]], ":")
								If @error Then
									SetError(0)
									ContinueLoop
								Else
									$regex = StringRegExp($newsplit[1], "Password\h\d+")
									If $regex = 1 Then
										$newhold += 1
										ContinueLoop
									Else
										ContinueLoop
									EndIf
								EndIf
							Next
							If $newhold > 0 Then
								IniWrite($storepath, "Hold Num", "Password Number", $newhold)
								$newhold = 0
							EndIf
							For $t = 0 To UBound($addresscount) - 1 Step 1
								$regex = StringRegExp($imp_data[$addresscount[$t]], "Address\h\d+")
								If $regex = 1 Then
									$newhold += 1
									ContinueLoop
								Else
									ContinueLoop
								EndIf
							Next
							If $newhold > 0 Then
								IniWrite($storepath, "Hold Num", "Address", $newhold)
								$newhold = 0
							EndIf
							For $t = 0 To UBound($phonecount) - 1 Step 1
								$newsplit = StringSplit($imp_data[$phonecount[$t]], ":")
								If @error Then
									SetError(0)
									ContinueLoop
								Else
									$regex = StringRegExp($newsplit[1], "Phone number\h\d+")
									If $regex = 1 Then
										$newhold += 1
										ContinueLoop
									Else
										ContinueLoop
									EndIf
								EndIf
							Next
							If $newhold > 0 Then
								IniWrite($storepath, "Hold Num", "Phone number", $newhold)
								$newhold = 0
							EndIf
							For $t = 0 To UBound($edcount) - 1 Step 1
								$regex = StringRegExp($imp_data[$edcount[$t]], "Education history\h\d+")
								If $regex = 1 Then
									$newhold += 1
									ContinueLoop
								Else
									ContinueLoop
								EndIf
							Next
							If $newhold > 0 Then
								IniWrite($storepath, "Hold Num", "Education number", $newhold)
								$newhold = 0
							EndIf
							For $t = 0 To UBound($compcount) - 1 Step 1
								$regex = StringRegExp($imp_data[$compcount[$t]], "Company\h\d+")
								If $regex = 1 Then
									$newhold += 1
									ContinueLoop
								Else
									ContinueLoop
								EndIf
							Next
							If $newhold > 0 Then
								IniWrite($storepath, "Hold Num", "Company number", $newhold)
								$newhold = 0
							EndIf
							For $t = 0 To UBound($refcount) - 1 Step 1
								$regex = StringRegExp($imp_data[$refcount[$t]], "Reference\h\d+")
								If $regex = 1 Then
									$newhold += 1
									ContinueLoop
								Else
									ContinueLoop
								EndIf
							Next
							If $newhold > 0 Then
								IniWrite($storepath, "Hold Num", "Reference Number", $newhold)
								$newhold = 0
							EndIf
							For $t = 0 To UBound($webcount) - 1 Step 1
								$newsplit = StringSplit($imp_data[$webcount[$t]], ":")
								If @error Then
									SetError(0)
									ContinueLoop
								Else
									$regex = StringRegExp($newsplit[1], "Website\h\d+")
									If $regex = 1 Then
										$newhold += 1
										ContinueLoop
									Else
										ContinueLoop
									EndIf
								EndIf
							Next
							If $newhold > 0 Then
								IniWrite($storepath, "Hold Num", "Website", $newhold)
								$newhold = 0
							EndIf
						Case $iMsgBoxAnswer = $IDNO

					EndSelect
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_OK + $MB_ICONASTERISK, "Restarting", "The app will now restart to populate the new values.", 2)
					Exit 3


				Case $Button13
					ToolTip("")
					_GUICtrlListView_DeleteItemsSelected($ListView1)

				Case $Button28
					$info = GUICtrlRead($Combo7)
					Select
						Case $info = "Add to Templates"
							If _GUICtrlListView_GetItemCount($ListView1) > 0 Then
								#Region --- CodeWizard generated code Start ---
								;InputBox features: Title=Yes, Prompt=Yes, Default Text=No
								If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
								$sInputBoxAnswer = InputBox("Name", "Please enter the name you want to give this template.", "", " ")
								Select
									Case @error = 0 ;OK - The string returned is valid
										$tempnum = Int(IniRead($storepath, "Hold Num", "Template Number", "0"))
										$tempnum += 1
										Local $templa[_GUICtrlListView_GetItemCount($ListView1) + 1][2]
										$templa[0][0] = "Template Name"
										$templa[0][1] = $sInputBoxAnswer
										For $pup = 0 To _GUICtrlListView_GetItemCount($ListView1) - 1 Step 1
											$talk = _GUICtrlListView_GetItemTextArray($ListView1, $pup)
											$templa[$pup + 1][0] = $talk[1]
											$templa[$pup + 1][1] = encry($talk[2])
										Next
										If _GUICtrlListView_GetItemCount($ListView1) > 0 Then
											_GUICtrlListView_DeleteAllItems($ListView1)
										EndIf

										IniWriteSection($storepath, "Template " & $tempnum, $templa, 0)
										IniWrite($storepath, "Hold Num", "Template Number", $tempnum)
										;_GUICtrlComboBox_Destroy ($Combo7)
										;$Combo7 = _GUICtrlComboBox_Create ( $Form1_1, "Add to Templates", 460, 350, 200, 15, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
										;templateFill()
										Exit 3

									Case @error = 1 ;The Cancel button was pushed

									Case @error = 3 ;The InputBox failed to open

								EndSelect
								#EndRegion --- CodeWizard generated code Start ---
							Else

							EndIf
						Case Else
							If _GUICtrlListView_GetItemCount($ListView1) > 0 Then
								_GUICtrlListView_DeleteAllItems($ListView1)
							EndIf
							importTemplate($info)

					EndSelect
				Case $Checkbox58
					If GUICtrlRead($Checkbox58) = 1 Then
						GUICtrlSetState($Button35, $GUI_ENABLE)
						GUICtrlSetState($Button35, $GUI_SHOW)
					Else
						GUICtrlSetState($Button35, $GUI_DISABLE)
						GUICtrlSetState($Button35, $GUI_HIDE)
					EndIf

				Case $Button35
					$Listinput90 = GUICtrlCreateListViewItem("Cover letter|" & BinaryToString(decry(IniRead($storepath, "Cover Letter", "Cover Letter", "No cover letter stored."))), $ListView1)
				Case $Checkbox59
					If GUICtrlRead($Checkbox59) = 1 Then
						GUICtrlSetState($Button36, $GUI_ENABLE)
						GUICtrlSetState($Button36, $GUI_SHOW)
					Else
						GUICtrlSetState($Button36, $GUI_DISABLE)
						GUICtrlSetState($Button36, $GUI_HIDE)
					EndIf
				Case $Button36
					$Listinput90 = GUICtrlCreateListViewItem("Objective|" & BinaryToString(decry(IniRead($storepath, "Objective", "Objective", "No objective stored."))), $ListView1)

			EndSwitch
		Case $Form3_1
			Switch $nMsg[0]

				Case $GUI_EVENT_CLOSE
					_GUICtrlListBox_ResetContent($List2)

					_GUICtrlListBox_ResetContent($List3)
					For $rer = 1 To $thee Step 1
						If BinaryToString(decry(IniRead($storepath, "Education history " & $rer, "Education Level", "null"))) == "College" Then
							GUICtrlSetData($List3, BinaryToString(decry(IniRead($storepath, "Education history " & $rer, "Name", "null"))))
						Else
							GUICtrlSetData($List2, BinaryToString(decry(IniRead($storepath, "Education history " & $rer, "Name", "null"))))
						EndIf
					Next

					GUICtrlSetState($Checkbox14, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox14, $GUI_HIDE)
					GUICtrlSetState($Checkbox14, $GUI_DISABLE)
					GUICtrlSetState($Checkbox15, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox15, $GUI_HIDE)
					GUICtrlSetState($Checkbox15, $GUI_DISABLE)
					GUICtrlSetState($Checkbox16, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox16, $GUI_HIDE)
					GUICtrlSetState($Checkbox16, $GUI_DISABLE)
					GUICtrlSetState($Checkbox17, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox17, $GUI_HIDE)
					GUICtrlSetState($Checkbox17, $GUI_DISABLE)
					GUICtrlSetState($Checkbox18, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox18, $GUI_HIDE)
					GUICtrlSetState($Checkbox18, $GUI_DISABLE)
					GUICtrlSetState($Checkbox19, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox19, $GUI_HIDE)
					GUICtrlSetState($Checkbox19, $GUI_DISABLE)
					GUICtrlSetState($Checkbox20, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox20, $GUI_HIDE)
					GUICtrlSetState($Checkbox20, $GUI_DISABLE)
					GUICtrlSetState($Checkbox21, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox21, $GUI_HIDE)
					GUICtrlSetState($Checkbox21, $GUI_DISABLE)
					GUICtrlSetState($Radio8, $GUI_UNCHECKED)
					GUICtrlSetState($Radio8, $GUI_HIDE)
					GUICtrlSetState($Radio8, $GUI_DISABLE)
					GUICtrlSetState($Radio9, $GUI_UNCHECKED)
					GUICtrlSetState($Radio9, $GUI_HIDE)
					GUICtrlSetState($Radio9, $GUI_DISABLE)
					GUICtrlSetState($Button14, $GUI_HIDE)
					GUICtrlSetState($Button14, $GUI_DISABLE)
					GUICtrlSetState($Group1, $GUI_HIDE)
					GUICtrlSetState($Group1, $GUI_DISABLE)
					GUISetState(@SW_HIDE, $Form3_1)
					GUISwitch($Form1_1)
					GUICtrlSetState($Checkbox8, $GUI_UNCHECKED)
					GUISetState(@SW_SHOW, $Form1_1)
				Case $List2
					$arrayone = _GUICtrlListBox_GetSelItems($List2)
					$arraytwo = _GUICtrlListBox_GetSelItems($List3)
					If $arrayone[0] = 0 And $arraytwo[0] = 0 Then
						GUICtrlSetState($Checkbox14, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox14, $GUI_HIDE)
						GUICtrlSetState($Checkbox14, $GUI_DISABLE)
						GUICtrlSetState($Checkbox15, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox15, $GUI_HIDE)
						GUICtrlSetState($Checkbox15, $GUI_DISABLE)
						GUICtrlSetState($Checkbox16, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox16, $GUI_HIDE)
						GUICtrlSetState($Checkbox16, $GUI_DISABLE)
						GUICtrlSetState($Checkbox17, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox17, $GUI_HIDE)
						GUICtrlSetState($Checkbox17, $GUI_DISABLE)
						GUICtrlSetState($Button14, $GUI_HIDE)
						GUICtrlSetState($Button14, $GUI_DISABLE)
					Else
						GUICtrlSetState($Checkbox14, $GUI_SHOW)
						GUICtrlSetState($Checkbox14, $GUI_ENABLE)
						GUICtrlSetState($Checkbox15, $GUI_SHOW)
						GUICtrlSetState($Checkbox15, $GUI_ENABLE)
						GUICtrlSetState($Checkbox16, $GUI_SHOW)
						GUICtrlSetState($Checkbox16, $GUI_ENABLE)
						GUICtrlSetState($Checkbox17, $GUI_SHOW)
						GUICtrlSetState($Checkbox17, $GUI_ENABLE)
						GUICtrlSetState($Button14, $GUI_SHOW)
						GUICtrlSetState($Button14, $GUI_ENABLE)

					EndIf

				Case $List3
					$arrayone = _GUICtrlListBox_GetSelItems($List2)
					$arraytwo = _GUICtrlListBox_GetSelItems($List3)
					If $arrayone[0] = 0 And $arraytwo[0] = 0 Then
						GUICtrlSetState($Checkbox14, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox14, $GUI_HIDE)
						GUICtrlSetState($Checkbox14, $GUI_DISABLE)
						GUICtrlSetState($Checkbox15, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox15, $GUI_HIDE)
						GUICtrlSetState($Checkbox15, $GUI_DISABLE)
						GUICtrlSetState($Checkbox16, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox16, $GUI_HIDE)
						GUICtrlSetState($Checkbox16, $GUI_DISABLE)
						GUICtrlSetState($Checkbox17, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox17, $GUI_HIDE)
						GUICtrlSetState($Checkbox17, $GUI_DISABLE)
						GUICtrlSetState($Button14, $GUI_HIDE)
						GUICtrlSetState($Button14, $GUI_DISABLE)

					Else
						GUICtrlSetState($Checkbox14, $GUI_SHOW)
						GUICtrlSetState($Checkbox14, $GUI_ENABLE)
						GUICtrlSetState($Checkbox15, $GUI_SHOW)
						GUICtrlSetState($Checkbox15, $GUI_ENABLE)
						GUICtrlSetState($Checkbox16, $GUI_SHOW)
						GUICtrlSetState($Checkbox16, $GUI_ENABLE)
						GUICtrlSetState($Checkbox17, $GUI_SHOW)
						GUICtrlSetState($Checkbox17, $GUI_ENABLE)
						GUICtrlSetState($Button14, $GUI_SHOW)
						GUICtrlSetState($Button14, $GUI_ENABLE)
					EndIf
				Case $Checkbox14
					If GUICtrlRead($Checkbox14) = 1 Then
						GUICtrlSetState($Radio8, $GUI_ENABLE)
						GUICtrlSetState($Radio8, $GUI_SHOW)
						GUICtrlSetState($Radio9, $GUI_ENABLE)
						GUICtrlSetState($Radio9, $GUI_SHOW)
					Else
						GUICtrlSetState($Group1, $GUI_DISABLE)
						GUICtrlSetState($Group1, $GUI_HIDE)
						GUICtrlSetState($Radio8, $GUI_UNCHECKED)
						GUICtrlSetState($Radio8, $GUI_DISABLE)
						GUICtrlSetState($Radio8, $GUI_HIDE)
						GUICtrlSetState($Radio9, $GUI_UNCHECKED)
						GUICtrlSetState($Radio9, $GUI_DISABLE)
						GUICtrlSetState($Radio9, $GUI_HIDE)
						GUICtrlSetState($Checkbox18, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox18, $GUI_DISABLE)
						GUICtrlSetState($Checkbox18, $GUI_HIDE)
						GUICtrlSetState($Checkbox19, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox19, $GUI_DISABLE)
						GUICtrlSetState($Checkbox19, $GUI_HIDE)
						GUICtrlSetState($Checkbox20, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox20, $GUI_DISABLE)
						GUICtrlSetState($Checkbox20, $GUI_HIDE)
						GUICtrlSetState($Checkbox21, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox21, $GUI_DISABLE)
						GUICtrlSetState($Checkbox21, $GUI_HIDE)
					EndIf
				Case $Checkbox15

				Case $Checkbox16

				Case $Checkbox17
				Case $Radio8
					If GUICtrlRead($Radio8) = 1 Then
						GUICtrlSetState($Group1, $GUI_DISABLE)
						GUICtrlSetState($Group1, $GUI_HIDE)
						GUICtrlSetState($Checkbox18, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox18, $GUI_DISABLE)
						GUICtrlSetState($Checkbox18, $GUI_HIDE)
						GUICtrlSetState($Checkbox19, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox19, $GUI_DISABLE)
						GUICtrlSetState($Checkbox19, $GUI_HIDE)
						GUICtrlSetState($Checkbox20, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox20, $GUI_DISABLE)
						GUICtrlSetState($Checkbox20, $GUI_HIDE)
						GUICtrlSetState($Checkbox21, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox21, $GUI_DISABLE)
						GUICtrlSetState($Checkbox21, $GUI_HIDE)
					EndIf
				Case $Radio9
					If GUICtrlRead($Radio9) = 1 Then
						GUICtrlSetState($Group1, $GUI_ENABLE)
						GUICtrlSetState($Group1, $GUI_SHOW)
						GUICtrlSetState($Checkbox18, $GUI_ENABLE)
						GUICtrlSetState($Checkbox18, $GUI_SHOW)
						GUICtrlSetState($Checkbox19, $GUI_ENABLE)
						GUICtrlSetState($Checkbox19, $GUI_SHOW)
						GUICtrlSetState($Checkbox20, $GUI_ENABLE)
						GUICtrlSetState($Checkbox20, $GUI_SHOW)
						GUICtrlSetState($Checkbox21, $GUI_ENABLE)
						GUICtrlSetState($Checkbox21, $GUI_SHOW)
					Else
						GUICtrlSetState($Group1, $GUI_DISABLE)
						GUICtrlSetState($Group1, $GUI_HIDE)
						GUICtrlSetState($Checkbox18, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox18, $GUI_DISABLE)
						GUICtrlSetState($Checkbox18, $GUI_HIDE)
						GUICtrlSetState($Checkbox19, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox19, $GUI_DISABLE)
						GUICtrlSetState($Checkbox19, $GUI_HIDE)
						GUICtrlSetState($Checkbox20, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox20, $GUI_DISABLE)
						GUICtrlSetState($Checkbox20, $GUI_HIDE)
						GUICtrlSetState($Checkbox21, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox21, $GUI_DISABLE)
						GUICtrlSetState($Checkbox21, $GUI_HIDE)
					EndIf
				Case $Checkbox18
					If GUICtrlRead($Checkbox18) = 1 And GUICtrlRead($Radio9) = 1 Then
						$street = True
					Else
						$street = False
					EndIf

				Case $Checkbox19
					If GUICtrlRead($Checkbox19) = 1 And GUICtrlRead($Radio9) = 1 Then
						$city = True
					Else
						$city = False
					EndIf

				Case $Checkbox20
					If GUICtrlRead($Checkbox20) = 1 And GUICtrlRead($Radio9) = 1 Then
						$state = True
					Else
						$state = False
					EndIf

				Case $Checkbox21
					If GUICtrlRead($Checkbox21) = 1 And GUICtrlRead($Radio9) = 1 Then
						$zip = True
					Else
						$zip = False
					EndIf

				Case $Button14
					$edlist = _GUICtrlListBox_GetSelItemsText($List2)
					$edlist2 = _GUICtrlListBox_GetSelItemsText($List3)
					$tota = $edlist[0] + $edlist2[0]
					$storehere = 0
					Local $edarray[$tota]
					For $yre = 1 To Int(IniRead($storepath, "Hold Num", "Education number", "null")) Step 1
						For $try = 1 To $edlist[0] Step 1
							If StringCompare(BinaryToString(decry(IniRead($storepath, "Education history " & $yre, "Name", "NULL"))), $edlist[$try]) = 0 Then
								$edarray[$storehere] = "Education history " & $yre
								$storehere = $storehere + 1
							EndIf
						Next
						For $try = 1 To $edlist2[0] Step 1
							If StringCompare(BinaryToString(decry(IniRead($storepath, "Education history " & $yre, "Name", "NULL"))), $edlist2[$try]) = 0 Then
								$edarray[$storehere] = "Education history " & $yre
								$storehere = $storehere + 1
							EndIf
						Next
					Next
					For $hear = 0 To $tota - 1 Step 1
						$rab = ""
						If BinaryToString(decry(IniRead($storepath, $edarray[$hear], "Education Level", "null"))) == "College" Then
							$rab = "College name"
						Else
							$rab = "High School name"
						EndIf
						$Listinput49 = GUICtrlCreateListViewItem($rab & "|" & BinaryToString(decry(IniRead($storepath, $edarray[$hear], "Name", "Null"))), $ListView1)
						GUICtrlSetFont(-1, 12, $FW_BOLD)
						If GUICtrlRead($Checkbox14) = 1 Then
							If GUICtrlRead($Checkbox14) = 1 And GUICtrlRead($Radio8) = 1 Then
								$Listinput48 = GUICtrlCreateListViewItem("Street address|" & BinaryToString(decry(IniRead($storepath, $edarray[$hear], "Street Address", "null"))), $ListView1)
								$Listinput49 = GUICtrlCreateListViewItem("City|" & BinaryToString(decry(IniRead($storepath, $edarray[$hear], "City", "null"))), $ListView1)
								$Listinput50 = GUICtrlCreateListViewItem("State|" & BinaryToString(decry(IniRead($storepath, $edarray[$hear], "State", "null"))), $ListView1)
								$Listinput51 = GUICtrlCreateListViewItem("Zip code|" & BinaryToString(decry(IniRead($storepath, $edarray[$hear], "Zip code", "null"))), $ListView1)
							ElseIf GUICtrlRead($Checkbox14) = 1 And GUICtrlRead($Radio9) = 1 Then
								If GUICtrlRead($Checkbox18) = 1 Then
									$Listinput52 = GUICtrlCreateListViewItem("Street address|" & BinaryToString(decry(IniRead($storepath, $edarray[$hear], "Street Address", "null"))), $ListView1)
								EndIf
								If GUICtrlRead($Checkbox19) = 1 Then
									$Listinput53 = GUICtrlCreateListViewItem("City|" & BinaryToString(decry(IniRead($storepath, $edarray[$hear], "City", "null"))), $ListView1)
								EndIf
								If GUICtrlRead($Checkbox20) = 1 Then
									$Listinput54 = GUICtrlCreateListViewItem("State|" & BinaryToString(decry(IniRead($storepath, $edarray[$hear], "State", "null"))), $ListView1)
								EndIf
								If GUICtrlRead($Checkbox21) = 1 Then
									$Listinput55 = GUICtrlCreateListViewItem("Zip code|" & BinaryToString(decry(IniRead($storepath, $edarray[$hear], "Zip code", "null"))), $ListView1)
								EndIf
							EndIf
						EndIf
						If GUICtrlRead($Checkbox15) = 1 Then
							$Listinput56 = GUICtrlCreateListViewItem("Phone number|" & BinaryToString(decry(IniRead($storepath, $edarray[$hear], "Phone number", "Null"))), $ListView1)
						EndIf
						If GUICtrlRead($Checkbox16) = 1 Then
							$Listinput57 = GUICtrlCreateListViewItem("GPA|" & BinaryToString(decry(IniRead($storepath, $edarray[$hear], "GPA", "Null"))), $ListView1)
						EndIf
						If GUICtrlRead($Checkbox17) = 1 Then
							$Listinput58 = GUICtrlCreateListViewItem("Degree|" & BinaryToString(decry(IniRead($storepath, $edarray[$hear], "Degree", "Null"))), $ListView1)
						EndIf
					Next
					_GUICtrlListBox_ResetContent($List2)

					_GUICtrlListBox_ResetContent($List3)
					For $rer = 1 To $thee Step 1
						If BinaryToString(decry(IniRead($storepath, "Education history " & $rer, "Education Level", "null"))) == "College" Then
							GUICtrlSetData($List3, BinaryToString(decry(IniRead($storepath, "Education history " & $rer, "Name", "null"))))
						Else
							GUICtrlSetData($List2, BinaryToString(decry(IniRead($storepath, "Education history " & $rer, "Name", "null"))))
						EndIf
					Next

					GUICtrlSetState($Checkbox14, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox14, $GUI_HIDE)
					GUICtrlSetState($Checkbox14, $GUI_DISABLE)
					GUICtrlSetState($Checkbox15, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox15, $GUI_HIDE)
					GUICtrlSetState($Checkbox15, $GUI_DISABLE)
					GUICtrlSetState($Checkbox16, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox16, $GUI_HIDE)
					GUICtrlSetState($Checkbox16, $GUI_DISABLE)
					GUICtrlSetState($Checkbox17, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox17, $GUI_HIDE)
					GUICtrlSetState($Checkbox17, $GUI_DISABLE)
					GUICtrlSetState($Checkbox18, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox18, $GUI_HIDE)
					GUICtrlSetState($Checkbox18, $GUI_DISABLE)
					GUICtrlSetState($Checkbox19, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox19, $GUI_HIDE)
					GUICtrlSetState($Checkbox19, $GUI_DISABLE)
					GUICtrlSetState($Checkbox20, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox20, $GUI_HIDE)
					GUICtrlSetState($Checkbox20, $GUI_DISABLE)
					GUICtrlSetState($Checkbox21, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox21, $GUI_HIDE)
					GUICtrlSetState($Checkbox21, $GUI_DISABLE)
					GUICtrlSetState($Radio8, $GUI_UNCHECKED)
					GUICtrlSetState($Radio8, $GUI_HIDE)
					GUICtrlSetState($Radio8, $GUI_DISABLE)
					GUICtrlSetState($Radio9, $GUI_UNCHECKED)
					GUICtrlSetState($Radio9, $GUI_HIDE)
					GUICtrlSetState($Radio9, $GUI_DISABLE)
					GUICtrlSetState($Button14, $GUI_HIDE)
					GUICtrlSetState($Button14, $GUI_DISABLE)
					GUICtrlSetState($Group1, $GUI_HIDE)
					GUICtrlSetState($Group1, $GUI_DISABLE)
					GUISetState(@SW_HIDE, $Form3_1)
					GUISwitch($Form1_1)
					GUICtrlSetState($Checkbox8, $GUI_UNCHECKED)
					GUISetState(@SW_SHOW, $Form1_1)

			EndSwitch

		Case $Form5
			Switch $nMsg[0]
				Case $GUI_EVENT_CLOSE
					_GUICtrlListBox_ResetContent($List1)
					For $ytr = 1 To $gogo Step 1
						GUICtrlSetData($List1, BinaryToString(decry(IniRead($storepath, "Company " & $ytr, "Company name", "Null"))))
					Next
					GUICtrlSetState($Checkbox32, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox32, $GUI_HIDE)
					GUICtrlSetState($Checkbox32, $GUI_DISABLE)
					GUICtrlSetState($Checkbox33, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox33, $GUI_HIDE)
					GUICtrlSetState($Checkbox33, $GUI_DISABLE)
					GUICtrlSetState($Checkbox34, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox34, $GUI_HIDE)
					GUICtrlSetState($Checkbox34, $GUI_DISABLE)
					GUICtrlSetState($Checkbox52, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox52, $GUI_HIDE)
					GUICtrlSetState($Checkbox52, $GUI_DISABLE)
					GUICtrlSetState($Checkbox53, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox53, $GUI_HIDE)
					GUICtrlSetState($Checkbox53, $GUI_DISABLE)
					GUICtrlSetState($Checkbox54, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox54, $GUI_HIDE)
					GUICtrlSetState($Checkbox54, $GUI_DISABLE)
					GUICtrlSetState($Checkbox55, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox55, $GUI_HIDE)
					GUICtrlSetState($Checkbox55, $GUI_DISABLE)
					GUICtrlSetState($Radio12, $GUI_UNCHECKED)
					GUICtrlSetState($Radio12, $GUI_HIDE)
					GUICtrlSetState($Radio12, $GUI_DISABLE)
					GUICtrlSetState($Radio13, $GUI_UNCHECKED)
					GUICtrlSetState($Radio13, $GUI_HIDE)
					GUICtrlSetState($Radio13, $GUI_DISABLE)
					GUICtrlSetState($Group3, $GUI_HIDE)
					GUICtrlSetState($Group3, $GUI_DISABLE)
					GUICtrlSetState($Radio10, $GUI_UNCHECKED)
					GUICtrlSetState($Radio10, $GUI_HIDE)
					GUICtrlSetState($Radio10, $GUI_DISABLE)
					GUICtrlSetState($Radio11, $GUI_UNCHECKED)
					GUICtrlSetState($Radio11, $GUI_HIDE)
					GUICtrlSetState($Radio11, $GUI_DISABLE)
					GUICtrlSetState($Group4, $GUI_HIDE)
					GUICtrlSetState($Group4, $GUI_DISABLE)
					GUICtrlSetState($Group3, $GUI_HIDE)
					GUICtrlSetState($Group3, $GUI_DISABLE)
					GUICtrlSetState($Checkbox41, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox41, $GUI_HIDE)
					GUICtrlSetState($Checkbox41, $GUI_DISABLE)
					GUICtrlSetState($Checkbox42, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox42, $GUI_HIDE)
					GUICtrlSetState($Checkbox42, $GUI_DISABLE)
					GUICtrlSetState($Checkbox43, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox43, $GUI_HIDE)
					GUICtrlSetState($Checkbox43, $GUI_DISABLE)
					GUICtrlSetState($Checkbox44, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox44, $GUI_HIDE)
					GUICtrlSetState($Checkbox44, $GUI_DISABLE)
					GUICtrlSetState($Button20, $GUI_HIDE)
					GUICtrlSetState($Button20, $GUI_DISABLE)
					GUICtrlSetState($Button19, $GUI_HIDE)
					GUICtrlSetState($Button19, $GUI_DISABLE)
					;GUICtrlSetData ( $List1,
					GUISetState(@SW_HIDE, $Form5)
					GUISwitch($Form1_1)
					GUICtrlSetState($Checkbox5, $GUI_UNCHECKED)
					GUISetState(@SW_SHOW, $Form1_1)

				Case $List1
					$arraythree = _GUICtrlListBox_GetSelItems($List1)
					If $arraythree[0] = 0 Then
						GUICtrlSetState($Checkbox32, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox32, $GUI_HIDE)
						GUICtrlSetState($Checkbox32, $GUI_DISABLE)
						GUICtrlSetState($Checkbox33, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox33, $GUI_HIDE)
						GUICtrlSetState($Checkbox33, $GUI_DISABLE)
						GUICtrlSetState($Checkbox34, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox34, $GUI_HIDE)
						GUICtrlSetState($Checkbox34, $GUI_DISABLE)
						GUICtrlSetState($Checkbox52, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox52, $GUI_HIDE)
						GUICtrlSetState($Checkbox52, $GUI_DISABLE)
						GUICtrlSetState($Checkbox53, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox53, $GUI_HIDE)
						GUICtrlSetState($Checkbox53, $GUI_DISABLE)
						GUICtrlSetState($Checkbox54, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox54, $GUI_HIDE)
						GUICtrlSetState($Checkbox54, $GUI_DISABLE)
						GUICtrlSetState($Checkbox55, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox55, $GUI_HIDE)
						GUICtrlSetState($Checkbox55, $GUI_DISABLE)
						GUICtrlSetState($Radio12, $GUI_UNCHECKED)
						GUICtrlSetState($Radio12, $GUI_HIDE)
						GUICtrlSetState($Radio12, $GUI_DISABLE)
						GUICtrlSetState($Radio13, $GUI_UNCHECKED)
						GUICtrlSetState($Radio13, $GUI_HIDE)
						GUICtrlSetState($Radio13, $GUI_DISABLE)
						GUICtrlSetState($Group3, $GUI_HIDE)
						GUICtrlSetState($Group3, $GUI_DISABLE)
						GUICtrlSetState($Radio10, $GUI_UNCHECKED)
						GUICtrlSetState($Radio10, $GUI_HIDE)
						GUICtrlSetState($Radio10, $GUI_DISABLE)
						GUICtrlSetState($Radio11, $GUI_UNCHECKED)
						GUICtrlSetState($Radio11, $GUI_HIDE)
						GUICtrlSetState($Radio11, $GUI_DISABLE)
						GUICtrlSetState($Group4, $GUI_HIDE)
						GUICtrlSetState($Group4, $GUI_DISABLE)
						GUICtrlSetState($Group3, $GUI_HIDE)
						GUICtrlSetState($Group3, $GUI_DISABLE)
						GUICtrlSetState($Checkbox41, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox41, $GUI_HIDE)
						GUICtrlSetState($Checkbox41, $GUI_DISABLE)
						GUICtrlSetState($Checkbox42, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox42, $GUI_HIDE)
						GUICtrlSetState($Checkbox42, $GUI_DISABLE)
						GUICtrlSetState($Checkbox43, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox43, $GUI_HIDE)
						GUICtrlSetState($Checkbox43, $GUI_DISABLE)
						GUICtrlSetState($Checkbox44, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox44, $GUI_HIDE)
						GUICtrlSetState($Checkbox44, $GUI_DISABLE)
						GUICtrlSetState($Button20, $GUI_HIDE)
						GUICtrlSetState($Button20, $GUI_DISABLE)
						GUICtrlSetState($Button19, $GUI_HIDE)
						GUICtrlSetState($Button19, $GUI_DISABLE)
					Else
						GUICtrlSetState($Checkbox32, $GUI_SHOW)
						GUICtrlSetState($Checkbox32, $GUI_ENABLE)
						GUICtrlSetState($Checkbox33, $GUI_SHOW)
						GUICtrlSetState($Checkbox33, $GUI_ENABLE)
						GUICtrlSetState($Checkbox34, $GUI_SHOW)
						GUICtrlSetState($Checkbox34, $GUI_ENABLE)
						GUICtrlSetState($Checkbox52, $GUI_SHOW)
						GUICtrlSetState($Checkbox52, $GUI_ENABLE)
						GUICtrlSetState($Checkbox53, $GUI_SHOW)
						GUICtrlSetState($Checkbox53, $GUI_ENABLE)
						GUICtrlSetState($Checkbox54, $GUI_SHOW)
						GUICtrlSetState($Checkbox54, $GUI_ENABLE)
						GUICtrlSetState($Checkbox55, $GUI_SHOW)
						GUICtrlSetState($Checkbox55, $GUI_ENABLE)
						GUICtrlSetState($Button20, $GUI_SHOW)
						GUICtrlSetState($Button20, $GUI_ENABLE)
						GUICtrlSetState($Button19, $GUI_SHOW)
						GUICtrlSetState($Button19, $GUI_ENABLE)
					EndIf
				Case $Checkbox32
					If GUICtrlRead($Checkbox32) = 1 Then
						GUICtrlSetState($Radio10, $GUI_ENABLE)
						GUICtrlSetState($Radio10, $GUI_SHOW)
						GUICtrlSetState($Radio11, $GUI_ENABLE)
						GUICtrlSetState($Radio11, $GUI_SHOW)
						GUICtrlSetState($Group3, $GUI_SHOW)
						GUICtrlSetState($Group3, $GUI_ENABLE)
					Else
						GUICtrlSetState($Radio10, $GUI_UNCHECKED)
						GUICtrlSetState($Radio10, $GUI_DISABLE)
						GUICtrlSetState($Radio10, $GUI_HIDE)
						GUICtrlSetState($Radio11, $GUI_UNCHECKED)
						GUICtrlSetState($Radio11, $GUI_DISABLE)
						GUICtrlSetState($Radio11, $GUI_HIDE)
						GUICtrlSetState($Group3, $GUI_HIDE)
						GUICtrlSetState($Group3, $GUI_DISABLE)
						GUICtrlSetState($Group4, $GUI_DISABLE)
						GUICtrlSetState($Group4, $GUI_HIDE)
						GUICtrlSetState($Checkbox41, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox41, $GUI_DISABLE)
						GUICtrlSetState($Checkbox41, $GUI_HIDE)
						GUICtrlSetState($Checkbox42, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox42, $GUI_DISABLE)
						GUICtrlSetState($Checkbox42, $GUI_HIDE)
						GUICtrlSetState($Checkbox43, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox43, $GUI_DISABLE)
						GUICtrlSetState($Checkbox43, $GUI_HIDE)
						GUICtrlSetState($Checkbox44, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox44, $GUI_DISABLE)
						GUICtrlSetState($Checkbox44, $GUI_HIDE)
						GUICtrlSetState($Radio12, $GUI_UNCHECKED)
						GUICtrlSetState($Radio12, $GUI_HIDE)
						GUICtrlSetState($Radio12, $GUI_DISABLE)
						GUICtrlSetState($Radio13, $GUI_UNCHECKED)
						GUICtrlSetState($Radio13, $GUI_HIDE)
						GUICtrlSetState($Radio13, $GUI_DISABLE)
					EndIf

				Case $Checkbox33
				Case $Checkbox34
				Case $Radio10
					If GUICtrlRead($Radio10) = 1 Then
						GUICtrlSetState($Checkbox41, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox41, $GUI_DISABLE)
						GUICtrlSetState($Checkbox41, $GUI_HIDE)
						GUICtrlSetState($Checkbox42, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox42, $GUI_DISABLE)
						GUICtrlSetState($Checkbox42, $GUI_HIDE)
						GUICtrlSetState($Checkbox43, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox43, $GUI_DISABLE)
						GUICtrlSetState($Checkbox43, $GUI_HIDE)
						GUICtrlSetState($Checkbox44, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox44, $GUI_DISABLE)
						GUICtrlSetState($Checkbox44, $GUI_HIDE)
						GUICtrlSetState($Radio12, $GUI_SHOW)
						GUICtrlSetState($Radio12, $GUI_ENABLE)
						GUICtrlSetState($Radio13, $GUI_SHOW)
						GUICtrlSetState($Radio13, $GUI_ENABLE)
						GUICtrlSetState($Group4, $GUI_ENABLE)
						GUICtrlSetState($Group4, $GUI_SHOW)
					Else
						GUICtrlSetState($Radio12, $GUI_HIDE)
						GUICtrlSetState($Radio12, $GUI_DISABLE)
						GUICtrlSetState($Radio13, $GUI_HIDE)
						GUICtrlSetState($Radio13, $GUI_DISABLE)
					EndIf


				Case $Radio11
					If GUICtrlRead($Radio11) = 1 Then
						GUICtrlSetState($Checkbox41, $GUI_ENABLE)
						GUICtrlSetState($Checkbox41, $GUI_SHOW)
						GUICtrlSetState($Checkbox42, $GUI_ENABLE)
						GUICtrlSetState($Checkbox42, $GUI_SHOW)
						GUICtrlSetState($Checkbox43, $GUI_ENABLE)
						GUICtrlSetState($Checkbox43, $GUI_SHOW)
						GUICtrlSetState($Checkbox44, $GUI_ENABLE)
						GUICtrlSetState($Checkbox44, $GUI_SHOW)
						GUICtrlSetState($Group4, $GUI_ENABLE)
						GUICtrlSetState($Group4, $GUI_SHOW)
						GUICtrlSetState($Radio12, $GUI_UNCHECKED)
						GUICtrlSetState($Radio12, $GUI_HIDE)
						GUICtrlSetState($Radio12, $GUI_DISABLE)
						GUICtrlSetState($Radio13, $GUI_UNCHECKED)
						GUICtrlSetState($Radio13, $GUI_HIDE)
						GUICtrlSetState($Radio13, $GUI_DISABLE)
					Else
						GUICtrlSetState($Checkbox41, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox41, $GUI_DISABLE)
						GUICtrlSetState($Checkbox41, $GUI_HIDE)
						GUICtrlSetState($Checkbox42, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox42, $GUI_DISABLE)
						GUICtrlSetState($Checkbox42, $GUI_HIDE)
						GUICtrlSetState($Checkbox43, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox43, $GUI_DISABLE)
						GUICtrlSetState($Checkbox43, $GUI_HIDE)
						GUICtrlSetState($Checkbox44, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox44, $GUI_DISABLE)
						GUICtrlSetState($Checkbox44, $GUI_HIDE)
					EndIf
				Case $Checkbox41
				Case $Checkbox42
				Case $Checkbox43
				Case $Checkbox44
				Case $Button20
					$complist = _GUICtrlListBox_GetSelItemsText($List1)
					$astore = 0
					Local $storecomp[$complist[0]]
					For $reep = 1 To Int(IniRead($storepath, "Hold Num", "Company number", "Null")) Step 1
						For $tor = 1 To $complist[0] Step 1
							If StringCompare(BinaryToString(decry(IniRead($storepath, "Company " & $reep, "Company Name", "NULL"))), $complist[$tor]) = 0 Then
								$storecomp[$astore] = "Company " & $reep
								$astore = $astore + 1
							EndIf
						Next
					Next
					For $iu = 0 To $astore - 1 Step 1
						$Listinput59 = GUICtrlCreateListViewItem("Company name|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company name", "Null"))), $ListView1)
						GUICtrlSetFont(-1, 12, $FW_BOLD)
						If GUICtrlRead($Checkbox32) = 1 And GUICtrlRead($Radio10) = 1 Then
							If GUICtrlRead($Radio13) = 1 Then
								$Listinput60 = GUICtrlCreateListViewItem("Street address|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company street address", "Null"))), $ListView1)
								$Listinput61 = GUICtrlCreateListViewItem("City|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company city", "Null"))), $ListView1)
								$Listinput62 = GUICtrlCreateListViewItem("State|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company state", "Null"))), $ListView1)
								$Listinput63 = GUICtrlCreateListViewItem("ZIP|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company ZIP", "Null"))), $ListView1)
							EndIf
							If GUICtrlRead($Radio12) = 1 Then
								$Listinput84 = GUICtrlCreateListViewItem("Address|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company street address", "Null"))) & ", " & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company city", "Null"))) & ", " & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company state", "Null"))) & " " & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company ZIP", "Null"))), $ListView1)
							EndIf
							If GUICtrlRead($Radio12) = 0 And GUICtrlRead($Radio13) = 0 Then
								$Listinput60 = GUICtrlCreateListViewItem("Street address|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company street address", "Null"))), $ListView1)
								$Listinput61 = GUICtrlCreateListViewItem("City|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company city", "Null"))), $ListView1)
								$Listinput62 = GUICtrlCreateListViewItem("State|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company state", "Null"))), $ListView1)
								$Listinput63 = GUICtrlCreateListViewItem("ZIP|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company ZIP", "Null"))), $ListView1)
							EndIf

						ElseIf GUICtrlRead($Checkbox32) = 1 And GUICtrlRead($Radio11) = 1 Then
							If GUICtrlRead($Checkbox41) = 1 Then
								$Listinput64 = GUICtrlCreateListViewItem("Street Address|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company street address", "Null"))), $ListView1)
							EndIf
							If GUICtrlRead($Checkbox42) = 1 Then
								$Listinput65 = GUICtrlCreateListViewItem("City|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company city", "Null"))), $ListView1)
							EndIf
							If GUICtrlRead($Checkbox43) = 1 Then
								$Listinput66 = GUICtrlCreateListViewItem("State|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company state", "Null"))), $ListView1)
							EndIf
							If GUICtrlRead($Checkbox44) = 1 Then
								$Listinput67 = GUICtrlCreateListViewItem("ZIP|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company ZIP", "Null"))), $ListView1)
							EndIf
						EndIf
						If GUICtrlRead($Checkbox33) = 1 Then
							$Listinput68 = GUICtrlCreateListViewItem("Phone number|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company phone", "Null"))), $ListView1)
						EndIf
						If GUICtrlRead($Checkbox34) = 1 Then
							$Listinput69 = GUICtrlCreateListViewItem("Title|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company title", "Null"))), $ListView1)
						EndIf
						If GUICtrlRead($Checkbox52) = 1 Then
							$Listinput85 = GUICtrlCreateListViewItem("Job Description|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company job description", "Not configured"))), $ListView1)
						EndIf
						If GUICtrlRead($Checkbox53) = 1 Then
							$Listinput86 = GUICtrlCreateListViewItem("Job Start Date|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company start", "Not configured"))), $ListView1)
							$Listinput87 = GUICtrlCreateListViewItem("Job End Date|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company end", "Not configured"))), $ListView1)
						EndIf
						If GUICtrlRead($Checkbox54) = 1 Then
							$Listinput88 = GUICtrlCreateListViewItem("Job salary|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company salary", "Not configured"))), $ListView1)
						EndIf
						If GUICtrlRead($Checkbox55) = 1 Then
							$Listinput89 = GUICtrlCreateListViewItem("Reasons for leaving|" & BinaryToString(decry(IniRead($storepath, $storecomp[$iu], "Company reason left", "Not configured"))), $ListView1)
						EndIf
					Next
					_GUICtrlListBox_ResetContent($List1)
					For $ytr = 1 To $gogo Step 1
						GUICtrlSetData($List1, BinaryToString(decry(IniRead($storepath, "Company " & $ytr, "Company name", "Null"))))
					Next
					GUICtrlSetState($Checkbox32, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox32, $GUI_HIDE)
					GUICtrlSetState($Checkbox32, $GUI_DISABLE)
					GUICtrlSetState($Checkbox33, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox33, $GUI_HIDE)
					GUICtrlSetState($Checkbox33, $GUI_DISABLE)
					GUICtrlSetState($Checkbox34, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox34, $GUI_HIDE)
					GUICtrlSetState($Checkbox34, $GUI_DISABLE)
					GUICtrlSetState($Checkbox52, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox52, $GUI_HIDE)
					GUICtrlSetState($Checkbox52, $GUI_DISABLE)
					GUICtrlSetState($Checkbox53, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox53, $GUI_HIDE)
					GUICtrlSetState($Checkbox53, $GUI_DISABLE)
					GUICtrlSetState($Checkbox54, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox54, $GUI_HIDE)
					GUICtrlSetState($Checkbox54, $GUI_DISABLE)
					GUICtrlSetState($Checkbox55, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox55, $GUI_HIDE)
					GUICtrlSetState($Checkbox55, $GUI_DISABLE)
					GUICtrlSetState($Radio12, $GUI_UNCHECKED)
					GUICtrlSetState($Radio12, $GUI_HIDE)
					GUICtrlSetState($Radio12, $GUI_DISABLE)
					GUICtrlSetState($Radio13, $GUI_UNCHECKED)
					GUICtrlSetState($Radio13, $GUI_HIDE)
					GUICtrlSetState($Radio13, $GUI_DISABLE)
					GUICtrlSetState($Group3, $GUI_HIDE)
					GUICtrlSetState($Group3, $GUI_DISABLE)
					GUICtrlSetState($Radio10, $GUI_UNCHECKED)
					GUICtrlSetState($Radio10, $GUI_HIDE)
					GUICtrlSetState($Radio10, $GUI_DISABLE)
					GUICtrlSetState($Radio11, $GUI_UNCHECKED)
					GUICtrlSetState($Radio11, $GUI_HIDE)
					GUICtrlSetState($Radio11, $GUI_DISABLE)
					GUICtrlSetState($Group4, $GUI_HIDE)
					GUICtrlSetState($Group4, $GUI_DISABLE)
					GUICtrlSetState($Group3, $GUI_HIDE)
					GUICtrlSetState($Group3, $GUI_DISABLE)
					GUICtrlSetState($Checkbox41, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox41, $GUI_HIDE)
					GUICtrlSetState($Checkbox41, $GUI_DISABLE)
					GUICtrlSetState($Checkbox42, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox42, $GUI_HIDE)
					GUICtrlSetState($Checkbox42, $GUI_DISABLE)
					GUICtrlSetState($Checkbox43, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox43, $GUI_HIDE)
					GUICtrlSetState($Checkbox43, $GUI_DISABLE)
					GUICtrlSetState($Checkbox44, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox44, $GUI_HIDE)
					GUICtrlSetState($Checkbox44, $GUI_DISABLE)
					GUICtrlSetState($Button20, $GUI_HIDE)
					GUICtrlSetState($Button20, $GUI_DISABLE)
					GUICtrlSetState($Button19, $GUI_HIDE)
					GUICtrlSetState($Button19, $GUI_DISABLE)
					;GUICtrlSetData ( $List1,
					GUISetState(@SW_HIDE, $Form5)
					GUISwitch($Form1_1)
					GUICtrlSetState($Checkbox5, $GUI_UNCHECKED)
					GUISetState(@SW_SHOW, $Form1_1)


				Case $Button19
					_GUICtrlListBox_ResetContent($List1)
					For $ytr = 1 To $gogo Step 1
						GUICtrlSetData($List1, BinaryToString(decry(IniRead($storepath, "Company " & $ytr, "Company name", "Null"))))
					Next
					GUICtrlSetState($Checkbox32, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox32, $GUI_HIDE)
					GUICtrlSetState($Checkbox32, $GUI_DISABLE)
					GUICtrlSetState($Checkbox33, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox33, $GUI_HIDE)
					GUICtrlSetState($Checkbox33, $GUI_DISABLE)
					GUICtrlSetState($Checkbox34, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox34, $GUI_HIDE)
					GUICtrlSetState($Checkbox34, $GUI_DISABLE)
					GUICtrlSetState($Checkbox52, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox52, $GUI_HIDE)
					GUICtrlSetState($Checkbox52, $GUI_DISABLE)
					GUICtrlSetState($Checkbox53, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox53, $GUI_HIDE)
					GUICtrlSetState($Checkbox53, $GUI_DISABLE)
					GUICtrlSetState($Checkbox54, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox54, $GUI_HIDE)
					GUICtrlSetState($Checkbox54, $GUI_DISABLE)
					GUICtrlSetState($Checkbox55, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox55, $GUI_HIDE)
					GUICtrlSetState($Checkbox55, $GUI_DISABLE)
					GUICtrlSetState($Radio12, $GUI_UNCHECKED)
					GUICtrlSetState($Radio12, $GUI_HIDE)
					GUICtrlSetState($Radio12, $GUI_DISABLE)
					GUICtrlSetState($Radio13, $GUI_UNCHECKED)
					GUICtrlSetState($Radio13, $GUI_HIDE)
					GUICtrlSetState($Radio13, $GUI_DISABLE)
					GUICtrlSetState($Group3, $GUI_HIDE)
					GUICtrlSetState($Group3, $GUI_DISABLE)
					GUICtrlSetState($Radio10, $GUI_UNCHECKED)
					GUICtrlSetState($Radio10, $GUI_HIDE)
					GUICtrlSetState($Radio10, $GUI_DISABLE)
					GUICtrlSetState($Radio11, $GUI_UNCHECKED)
					GUICtrlSetState($Radio11, $GUI_HIDE)
					GUICtrlSetState($Radio11, $GUI_DISABLE)
					GUICtrlSetState($Group4, $GUI_HIDE)
					GUICtrlSetState($Group4, $GUI_DISABLE)
					GUICtrlSetState($Group3, $GUI_HIDE)
					GUICtrlSetState($Group3, $GUI_DISABLE)
					GUICtrlSetState($Checkbox41, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox41, $GUI_HIDE)
					GUICtrlSetState($Checkbox41, $GUI_DISABLE)
					GUICtrlSetState($Checkbox42, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox42, $GUI_HIDE)
					GUICtrlSetState($Checkbox42, $GUI_DISABLE)
					GUICtrlSetState($Checkbox43, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox43, $GUI_HIDE)
					GUICtrlSetState($Checkbox43, $GUI_DISABLE)
					GUICtrlSetState($Checkbox44, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox44, $GUI_HIDE)
					GUICtrlSetState($Checkbox44, $GUI_DISABLE)
					GUICtrlSetState($Button20, $GUI_HIDE)
					GUICtrlSetState($Button20, $GUI_DISABLE)
					GUICtrlSetState($Button19, $GUI_HIDE)
					GUICtrlSetState($Button19, $GUI_DISABLE)
					;GUICtrlSetData ( $List1,
					GUISetState(@SW_HIDE, $Form5)
					GUISwitch($Form1_1)
					GUICtrlSetState($Checkbox5, $GUI_UNCHECKED)
					GUISetState(@SW_SHOW, $Form1_1)

			EndSwitch

		Case $Form3
			Switch $nMsg[0]
				Case $GUI_EVENT_CLOSE
					_GUICtrlListBox_ResetContent($List4)
					For $prep2 = 1 To $too Step 1
						GUICtrlSetData($List4, BinaryToString(decry(IniRead($storepath, "Reference " & $prep2, "Name", "Null"))))
					Next
					GUICtrlSetState($Checkbox35, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox35, $GUI_HIDE)
					GUICtrlSetState($Checkbox35, $GUI_DISABLE)
					GUICtrlSetState($Checkbox36, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox36, $GUI_HIDE)
					GUICtrlSetState($Checkbox36, $GUI_DISABLE)
					GUICtrlSetState($Checkbox37, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox37, $GUI_HIDE)
					GUICtrlSetState($Checkbox37, $GUI_DISABLE)
					GUICtrlSetState($Checkbox38, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox38, $GUI_HIDE)
					GUICtrlSetState($Checkbox38, $GUI_DISABLE)
					GUICtrlSetState($Checkbox39, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox39, $GUI_HIDE)
					GUICtrlSetState($Checkbox39, $GUI_DISABLE)
					GUICtrlSetState($Checkbox40, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox40, $GUI_HIDE)
					GUICtrlSetState($Checkbox40, $GUI_DISABLE)
					GUICtrlSetState($Button21, $GUI_HIDE)
					GUICtrlSetState($Button21, $GUI_DISABLE)
					GUICtrlSetState($Button22, $GUI_HIDE)
					GUICtrlSetState($Button22, $GUI_DISABLE)
					GUISetState(@SW_HIDE, $Form3)
					GUISwitch($Form1_1)
					GUICtrlSetState($Checkbox11, $GUI_UNCHECKED)
					GUISetState(@SW_SHOW, $Form1_1)

				Case $List4
					$arrayfour = _GUICtrlListBox_GetSelItems($List4)
					If $arrayfour[0] = 0 Then
						GUICtrlSetState($Checkbox35, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox35, $GUI_HIDE)
						GUICtrlSetState($Checkbox35, $GUI_DISABLE)
						GUICtrlSetState($Checkbox36, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox36, $GUI_HIDE)
						GUICtrlSetState($Checkbox36, $GUI_DISABLE)
						GUICtrlSetState($Checkbox37, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox37, $GUI_HIDE)
						GUICtrlSetState($Checkbox37, $GUI_DISABLE)
						GUICtrlSetState($Checkbox38, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox38, $GUI_HIDE)
						GUICtrlSetState($Checkbox38, $GUI_DISABLE)
						GUICtrlSetState($Checkbox39, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox39, $GUI_HIDE)
						GUICtrlSetState($Checkbox39, $GUI_DISABLE)
						GUICtrlSetState($Checkbox40, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox40, $GUI_HIDE)
						GUICtrlSetState($Checkbox40, $GUI_DISABLE)
						GUICtrlSetState($Button21, $GUI_HIDE)
						GUICtrlSetState($Button21, $GUI_DISABLE)
						GUICtrlSetState($Button22, $GUI_HIDE)
						GUICtrlSetState($Button22, $GUI_DISABLE)
					Else
						GUICtrlSetState($Checkbox35, $GUI_SHOW)
						GUICtrlSetState($Checkbox35, $GUI_ENABLE)
						GUICtrlSetState($Checkbox36, $GUI_SHOW)
						GUICtrlSetState($Checkbox36, $GUI_ENABLE)
						GUICtrlSetState($Checkbox37, $GUI_SHOW)
						GUICtrlSetState($Checkbox37, $GUI_ENABLE)
						GUICtrlSetState($Checkbox38, $GUI_SHOW)
						GUICtrlSetState($Checkbox38, $GUI_ENABLE)
						GUICtrlSetState($Checkbox39, $GUI_SHOW)
						GUICtrlSetState($Checkbox39, $GUI_ENABLE)
						GUICtrlSetState($Checkbox40, $GUI_SHOW)
						GUICtrlSetState($Checkbox40, $GUI_ENABLE)
						GUICtrlSetState($Button21, $GUI_SHOW)
						GUICtrlSetState($Button21, $GUI_ENABLE)
						GUICtrlSetState($Button22, $GUI_SHOW)
						GUICtrlSetState($Button22, $GUI_ENABLE)
					EndIf

				Case $Checkbox35
				Case $Checkbox36
				Case $Checkbox37
				Case $Checkbox38
				Case $Checkbox39
				Case $Checkbox40
				Case $Button21
					$reflist = _GUICtrlListBox_GetSelItemsText($List4)
					$lalala = 0
					Local $storeref[$reflist[0]]
					For $g = 1 To Int(IniRead($storepath, "Hold Num", "Reference Number", "NA")) Step 1
						For $see = 1 To $reflist[0] Step 1
							If StringCompare(BinaryToString(decry(IniRead($storepath, "Reference " & $g, "Name", "NA"))), $reflist[$see]) = 0 Then
								$storeref[$lalala] = "Reference " & $g
								$lalala = $lalala + 1
							EndIf
						Next
					Next
					For $reer = 0 To $lalala - 1 Step 1
						$Listinput70 = GUICtrlCreateListViewItem("Reference Name|" & BinaryToString(decry(IniRead($storepath, $storeref[$reer], "Name", "Null"))), $ListView1)
						GUICtrlSetFont(-1, 12, $FW_BOLD)
						If GUICtrlRead($Checkbox35) = 1 Then
							$Listinput71 = GUICtrlCreateListViewItem("Company|" & BinaryToString(decry(IniRead($storepath, $storeref[$reer], "Company", "Null"))), $ListView1)
						EndIf
						If GUICtrlRead($Checkbox36) = 1 Then
							$Listinput72 = GUICtrlCreateListViewItem("Title|" & BinaryToString(decry(IniRead($storepath, $storeref[$reer], "Title", "Null"))), $ListView1)
						EndIf
						If GUICtrlRead($Checkbox37) = 1 Then
							$Listinput73 = GUICtrlCreateListViewItem("Phone number|" & BinaryToString(decry(IniRead($storepath, $storeref[$reer], "Phone number", "Null"))), $ListView1)
						EndIf
						If GUICtrlRead($Checkbox38) = 1 Then
							$Listinput74 = GUICtrlCreateListViewItem("Relationship|" & BinaryToString(decry(IniRead($storepath, $storeref[$reer], "Relationship", "Null"))), $ListView1)
						EndIf
						If GUICtrlRead($Checkbox39) = 1 Then
							$Listinput75 = GUICtrlCreateListViewItem("Email|" & BinaryToString(decry(IniRead($storepath, $storeref[$reer], "Email", "Null"))), $ListView1)
						EndIf
						If GUICtrlRead($Checkbox40) = 1 Then
							$Listinput76 = GUICtrlCreateListViewItem("Years known|" & BinaryToString(decry(IniRead($storepath, $storeref[$reer], "Years Known", "Null"))), $ListView1)
						EndIf
					Next
					_GUICtrlListBox_ResetContent($List4)
					For $prep2 = 1 To $too Step 1
						GUICtrlSetData($List4, BinaryToString(decry(IniRead($storepath, "Reference " & $prep2, "Name", "Null"))))
					Next
					GUICtrlSetState($Checkbox35, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox35, $GUI_HIDE)
					GUICtrlSetState($Checkbox35, $GUI_DISABLE)
					GUICtrlSetState($Checkbox36, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox36, $GUI_HIDE)
					GUICtrlSetState($Checkbox36, $GUI_DISABLE)
					GUICtrlSetState($Checkbox37, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox37, $GUI_HIDE)
					GUICtrlSetState($Checkbox37, $GUI_DISABLE)
					GUICtrlSetState($Checkbox38, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox38, $GUI_HIDE)
					GUICtrlSetState($Checkbox38, $GUI_DISABLE)
					GUICtrlSetState($Checkbox39, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox39, $GUI_HIDE)
					GUICtrlSetState($Checkbox39, $GUI_DISABLE)
					GUICtrlSetState($Checkbox40, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox40, $GUI_HIDE)
					GUICtrlSetState($Checkbox40, $GUI_DISABLE)
					GUICtrlSetState($Button21, $GUI_HIDE)
					GUICtrlSetState($Button21, $GUI_DISABLE)
					GUICtrlSetState($Button22, $GUI_HIDE)
					GUICtrlSetState($Button22, $GUI_DISABLE)
					GUISetState(@SW_HIDE, $Form3)
					GUISwitch($Form1_1)
					GUICtrlSetState($Checkbox11, $GUI_UNCHECKED)
					GUISetState(@SW_SHOW, $Form1_1)

				Case $Button22
					_GUICtrlListBox_ResetContent($List4)
					For $prep2 = 1 To $too Step 1
						GUICtrlSetData($List4, BinaryToString(decry(IniRead($storepath, "Reference " & $prep2, "Name", "Null"))))
					Next
					GUICtrlSetState($Checkbox35, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox35, $GUI_HIDE)
					GUICtrlSetState($Checkbox35, $GUI_DISABLE)
					GUICtrlSetState($Checkbox36, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox36, $GUI_HIDE)
					GUICtrlSetState($Checkbox36, $GUI_DISABLE)
					GUICtrlSetState($Checkbox37, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox37, $GUI_HIDE)
					GUICtrlSetState($Checkbox37, $GUI_DISABLE)
					GUICtrlSetState($Checkbox38, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox38, $GUI_HIDE)
					GUICtrlSetState($Checkbox38, $GUI_DISABLE)
					GUICtrlSetState($Checkbox39, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox39, $GUI_HIDE)
					GUICtrlSetState($Checkbox39, $GUI_DISABLE)
					GUICtrlSetState($Checkbox40, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox40, $GUI_HIDE)
					GUICtrlSetState($Checkbox40, $GUI_DISABLE)
					GUICtrlSetState($Button21, $GUI_HIDE)
					GUICtrlSetState($Button21, $GUI_DISABLE)
					GUICtrlSetState($Button22, $GUI_HIDE)
					GUICtrlSetState($Button22, $GUI_DISABLE)
					GUISetState(@SW_HIDE, $Form3)
					GUISwitch($Form1_1)
					GUICtrlSetState($Checkbox11, $GUI_UNCHECKED)
					GUISetState(@SW_SHOW, $Form1_1)
			EndSwitch

		Case $Form4
			Switch $nMsg[0]
				Case $GUI_EVENT_CLOSE, $Button24
					_GUICtrlListBox_ResetContent($List5)
					For $ytp = 1 To $hell Step 1
						GUICtrlSetData($List5, BinaryToString(decry(IniRead($storepath, "Address " & $ytp, "Name", "Null"))))
					Next
					GUICtrlSetState($Checkbox45, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox45, $GUI_DISABLE)
					GUICtrlSetState($Checkbox45, $GUI_HIDE)
					GUICtrlSetState($Checkbox46, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox46, $GUI_DISABLE)
					GUICtrlSetState($Checkbox46, $GUI_HIDE)
					GUICtrlSetState($Checkbox47, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox47, $GUI_DISABLE)
					GUICtrlSetState($Checkbox47, $GUI_HIDE)
					GUICtrlSetState($Checkbox48, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox48, $GUI_DISABLE)
					GUICtrlSetState($Checkbox48, $GUI_HIDE)
					GUICtrlSetState($Checkbox49, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox49, $GUI_DISABLE)
					GUICtrlSetState($Checkbox49, $GUI_HIDE)
					GUICtrlSetState($Button23, $GUI_DISABLE)
					GUICtrlSetState($Button23, $GUI_HIDE)
					GUISetState(@SW_HIDE, $Form4)
					GUISetState(@SW_DISABLE, $Form4)
					GUISwitch($Form1_1)
					GUICtrlSetState($Checkbox6, $GUI_UNCHECKED)
					GUISetState(@SW_ENABLE, $Form1_1)
					GUISetState(@SW_SHOW, $Form1_1)
				Case $List5
					$arrayfive = _GUICtrlListBox_GetSelItems($List5)
					If $arrayfive[0] = 0 Then
						GUICtrlSetState($Checkbox45, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox45, $GUI_DISABLE)
						GUICtrlSetState($Checkbox45, $GUI_HIDE)
						GUICtrlSetState($Checkbox46, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox46, $GUI_DISABLE)
						GUICtrlSetState($Checkbox46, $GUI_HIDE)
						GUICtrlSetState($Checkbox47, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox47, $GUI_DISABLE)
						GUICtrlSetState($Checkbox47, $GUI_HIDE)
						GUICtrlSetState($Checkbox48, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox48, $GUI_DISABLE)
						GUICtrlSetState($Checkbox48, $GUI_HIDE)
						GUICtrlSetState($Checkbox49, $GUI_UNCHECKED)
						GUICtrlSetState($Checkbox49, $GUI_DISABLE)
						GUICtrlSetState($Checkbox49, $GUI_HIDE)
						GUICtrlSetState($Button23, $GUI_DISABLE)
						GUICtrlSetState($Button23, $GUI_HIDE)
					Else
						GUICtrlSetState($Checkbox45, $GUI_ENABLE)
						GUICtrlSetState($Checkbox45, $GUI_SHOW)
						GUICtrlSetState($Checkbox46, $GUI_ENABLE)
						GUICtrlSetState($Checkbox46, $GUI_SHOW)
						GUICtrlSetState($Checkbox47, $GUI_ENABLE)
						GUICtrlSetState($Checkbox47, $GUI_SHOW)
						GUICtrlSetState($Checkbox48, $GUI_ENABLE)
						GUICtrlSetState($Checkbox48, $GUI_SHOW)
						GUICtrlSetState($Checkbox49, $GUI_ENABLE)
						GUICtrlSetState($Checkbox49, $GUI_SHOW)
						GUICtrlSetState($Button23, $GUI_ENABLE)
						GUICtrlSetState($Button23, $GUI_SHOW)
					EndIf

				Case $Checkbox45
				Case $Checkbox46
				Case $Checkbox47
				Case $Checkbox48
				Case $Checkbox49
				Case $Button23
					$addlist = _GUICtrlListBox_GetSelItemsText($List5)
					$fool = 0
					Local $storeadd[$addlist[0]]
					For $coo = 1 To Int(IniRead($storepath, "Hold Num", "Address", "NA")) Step 1
						For $took = 1 To $addlist[0] Step 1
							If StringCompare(BinaryToString(decry(IniRead($storepath, "Address " & $coo, "Name", "NA"))), $addlist[$took]) = 0 Then
								$storeadd[$fool] = "Address " & $coo
								$fool += 1
							EndIf
						Next
					Next
					For $cop = 0 To $fool - 1 Step 1
						$apthere = False
						$testapt = IniReadSection($storepath, $storeadd[$cop])
						For $tree = 1 To $testapt[0][0] Step 1
							If StringCompare($testapt[$tree][0], "Apt") = 0 Then
								$apthere = True
								ExitLoop
							EndIf
						Next

						$Listinput82 = GUICtrlCreateListViewItem("Name|" & BinaryToString(decry(IniRead($storepath, $storeadd[$cop], "Name", "NA"))), $ListView1)
						If GUICtrlRead($Checkbox45) = 1 Then
							$Listinput77 = GUICtrlCreateListViewItem("Street Address|" & BinaryToString(decry(IniRead($storepath, $storeadd[$cop], "Street", "NA"))), $ListView1)
							If $apthere = True Then
								$listinput91 = GUICtrlCreateListViewItem("Apartment #|" & BinaryToString(decry(IniRead($storepath, $storeadd[$cop], "Apt", "NA"))), $ListView1)
							EndIf
						EndIf
						If GUICtrlRead($Checkbox46) = 1 Then
							$Listinput78 = GUICtrlCreateListViewItem("Address City|" & BinaryToString(decry(IniRead($storepath, $storeadd[$cop], "City", "NA"))), $ListView1)
						EndIf
						If GUICtrlRead($Checkbox47) = 1 Then
							$Listinput79 = GUICtrlCreateListViewItem("Address State|" & BinaryToString(decry(IniRead($storepath, $storeadd[$cop], "State", "NA"))), $ListView1)
						EndIf
						If GUICtrlRead($Checkbox48) = 1 Then
							$Listinput80 = GUICtrlCreateListViewItem("Address ZIP|" & BinaryToString(decry(IniRead($storepath, $storeadd[$cop], "Zip", "NA"))), $ListView1)
						EndIf
						If GUICtrlRead($Checkbox49) = 1 Then
							If $apthere = True Then
								$Listinput81 = GUICtrlCreateListViewItem("Whole address|" & BinaryToString(decry(IniRead($storepath, $storeadd[$cop], "Street", "NA"))) & " " & BinaryToString(decry(IniRead($storepath, $storeadd[$cop], "Apt", "NA"))) & ", " & BinaryToString(decry(IniRead($storepath, $storeadd[$cop], "City", "NA"))) & ", " & BinaryToString(decry(IniRead($storepath, $storeadd[$cop], "State", "NA"))) & " " & BinaryToString(decry(IniRead($storepath, $storeadd[$cop], "Zip", "NA"))), $ListView1)
							Else
								$Listinput81 = GUICtrlCreateListViewItem("Whole address|" & BinaryToString(decry(IniRead($storepath, $storeadd[$cop], "Street", "NA"))) & ", " & BinaryToString(decry(IniRead($storepath, $storeadd[$cop], "City", "NA"))) & ", " & BinaryToString(decry(IniRead($storepath, $storeadd[$cop], "State", "NA"))) & " " & BinaryToString(decry(IniRead($storepath, $storeadd[$cop], "Zip", "NA"))), $ListView1)
							EndIf

						EndIf
					Next
					_GUICtrlListBox_ResetContent($List5)
					For $ytp = 1 To $hell Step 1
						GUICtrlSetData($List5, BinaryToString(decry(IniRead($storepath, "Address " & $ytp, "Name", "Null"))))
					Next
					GUICtrlSetState($Checkbox45, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox45, $GUI_DISABLE)
					GUICtrlSetState($Checkbox45, $GUI_HIDE)
					GUICtrlSetState($Checkbox46, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox46, $GUI_DISABLE)
					GUICtrlSetState($Checkbox46, $GUI_HIDE)
					GUICtrlSetState($Checkbox47, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox47, $GUI_DISABLE)
					GUICtrlSetState($Checkbox47, $GUI_HIDE)
					GUICtrlSetState($Checkbox48, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox48, $GUI_DISABLE)
					GUICtrlSetState($Checkbox48, $GUI_HIDE)
					GUICtrlSetState($Checkbox49, $GUI_UNCHECKED)
					GUICtrlSetState($Checkbox49, $GUI_DISABLE)
					GUICtrlSetState($Checkbox49, $GUI_HIDE)
					GUICtrlSetState($Button23, $GUI_DISABLE)
					GUICtrlSetState($Button23, $GUI_HIDE)
					GUISetState(@SW_HIDE, $Form4)
					GUISetState(@SW_DISABLE, $Form4)
					GUISwitch($Form1_1)
					GUICtrlSetState($Checkbox6, $GUI_UNCHECKED)
					GUISetState(@SW_ENABLE, $Form1_1)
					GUISetState(@SW_SHOW, $Form1_1)

			EndSwitch
		Case $Form2
			Switch $nMsg[0]
				Case $GUI_EVENT_CLOSE, $Button17
					;If GUICtrlRead ( $Button16
					ToolTip("")
					_GUICtrlListView_DeleteAllItems($ListView2)
					;_GUICtrlListView_DeleteAllItems($ListView2)
					GUICtrlSetState($Checkbox51, $GUI_UNCHECKED)
					_GUIListViewEx_Close()
					GUISetState(@SW_HIDE, $Form2)
					GUISwitch($Form1_1)
					GUISetState(@SW_SHOW, $Form1_1)
					Global $iLVIndex_1 = _GUIListViewEx_Init($ListView2)
				Case $ListView2
					$listitem = GUICtrlRead($ListView2)
					ToolTip("")
					#cs
						$pastetest1 = GUICtrlRead($listitem);GUICtrlRead(GUICtrlRead($ListView2))
						$pastearray1 = StringSplit($pastetest1, "|")
					#ce
				Case $Button16
					listSend()

					#cs
					Case $Button17
						ToolTip("")
						_GUICtrlListView_DeleteAllItems($ListView2)
						GUICtrlSetState($Checkbox51, $GUI_UNCHECKED)
						GUISetState(@SW_HIDE, $Form2)
						GUISwitch($Form1_1)
						GUISetState(@SW_SHOW, $Form1_1)
					#ce
				Case $Button25
					pasteList()

			EndSwitch
			#cs
				Case $Form7
				Switch $nMsg[0]
				Case $GUI_EVENT_CLOSE
				addReturn()
				Case $List6
				_SpellingSuggestions()
				Case $List7
				GUICtrlSetState ( $Button33, $GUI_ENABLE )
				Case $Button32
				addReturn($oRange.Text)
				Case $Button33
				Case $Button34
				addReturn()
				EndSwitch
			#ce
	EndSwitch
	$vRet = _GUIListViewEx_EventMonitor()
	If @error Then
		MsgBox($MB_SYSTEMMODAL, "Error", "Event error: " & @error)
	EndIf
	;If @extended <> 0 Then
	;	MsgBox ( 1, "", @extended )
	;EndIf

	Switch @extended
		Case 9
			$logfile = FileOpen(@TempDir & "\thelog.txt", 1)
			ConsoleWrite("Array contains:" & @CRLF)
			FileWriteLine($logfile, "Array contains:")
			For $mf = 0 To UBound($vRet) - 1 Step 1
				ConsoleWrite($vRet & @CRLF)
				FileWriteLine($logfile, $vRet)
			Next
			ConsoleWrite(@CRLF & @CRLF & @CRLF)
			FileWriteLine($logfile, "")
			FileWriteLine($logfile, "")
			FileWriteLine($logfile, "")
			FileClose($logfile)
	EndSwitch

WEnd
Func _SetLanguage()
	$sLang = "English"
	$oWordApp.CheckLanguage = False
	$WdLangID = Number(1033)

	If $WdLangID Then
		With $oRange
			.LanguageID = $WdLangID
			.NoProofing = False
		EndWith

	EndIf
EndFunc   ;==>_SetLanguage
Func start()
	$exist = True
	$storepath = IniRead($path & "\infostore.ini", "location", "info", "Not found")
	If $storepath == "Not found" Or Not FileExists($storepath) Then
		#Region --- CodeWizard generated code Start ---

		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Default Button=Second, Icon=None
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_DEFBUTTON2, "Cannot find Information file", 'If this is your first time running the program or you deleted your info file, select "no" and you will be asked to enter your information.  If you have run this program and generated a file containing your information, please select "yes" and open the file.')
		Select
			Case $iMsgBoxAnswer = $IDYES
				$exist = True
				$file = FileOpenDialog("Select your info file here.", @MyDocumentsDir, "Ini File (*.ini)", 3, "login.ini")
				IniWrite($path & "\infostore.ini", "location", "info", $file)
				$storepath = IniRead($path & "\infostore.ini", "location", "info", "Not found")

			Case $iMsgBoxAnswer = $IDNO
				$exist = False
				$file = FileSaveDialog("create your file", @MyDocumentsDir, "Ini files (*.ini)", 18, "login.ini")
				IniWrite($path & "\infostore.ini", "location", "info", $file)
				$storepath = IniRead($path & "\infostore.ini", "location", "info", "Not found")

		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
	EndIf

	Local $readhold = IniReadSectionNames($storepath)
	$entercomp = False
	$enterref = False
	$entered = False

	$seafile = @ScriptDir & "\1_ClipboardHelpAndSpell.ico"
	$tune = False
	names(True)
	emailadd(True)
	usernames(True)
	passx(True)
	addradd(True)
	phoneadd(True)
	addwebsite(True)
	If TrayItemGetState($settings1) = 68 Then
		#Region --- CodeWizard generated code Start ---

		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "Education", "Do you have any educational institutions you want to input into the form filler?")
		Select
			Case $iMsgBoxAnswer = $IDYES
				$entered = True

			Case $iMsgBoxAnswer = $IDNO
				$entered = False

		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
	EndIf

	If $entered = True Then
		Edadd(True)
	EndIf
	If TrayItemGetState($settings1) = 68 Then
		#Region --- CodeWizard generated code Start ---

		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "Work History?", "Do you want to add past work history to the form filler?")
		Select
			Case $iMsgBoxAnswer = $IDYES
				$entercomp = True

			Case $iMsgBoxAnswer = $IDNO
				$entercomp = False

		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
	EndIf


	If $entercomp = True Then
		compadd()
		refadd(True)
	EndIf

	Local $numusername = IniReadSection($storepath, "User Names")
	Local $numpass = IniReadSection($storepath, "Password")
	Local $numemail = IniReadSection($storepath, "Email")
	Local $numphone = IniReadSection($storepath, "Phone number")
	EnvUpdate()
	If TrayItemGetState($settings1) = 68 Then
		#Region --- CodeWizard generated code Start ---

		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=None
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO, "Restart", "You must close then relaunch this program in order for the additions/changes you have made to display.  Would you like to auto-restart the program now?")
		Select
			Case $iMsgBoxAnswer = $IDYES
				Exit 3

			Case $iMsgBoxAnswer = $IDNO

		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
	ElseIf TrayItemGetState($settings1) = 65 Then
		Exit 3
	Else
	EndIf

EndFunc   ;==>start


Func names($hodd)
	$errr = False
	#Region --- CodeWizard generated code Start ---
	;InputBox features: Title=Yes, Prompt=Yes, Default Text=No, Mandatory
	If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
	$sInputBoxAnswer = InputBox("Name", "Please enter your first and last name.", "", " M")
	Select
		Case @error = 0
			$Namearray = StringSplit($sInputBoxAnswer, " ")
			If $Namearray[0] >= 2 And $Namearray[2] <> "" Then
				IniWrite($storepath, "Name", "First", encry($Namearray[1]))
				IniWrite($storepath, "Name", "Last", encry($Namearray[2]))

			Else
				#Region --- CodeWizard generated code Start ---

				;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Critical
				If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
				$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONHAND, "an error occured", "Did you put input your full name separated by space?  Do you want to try again?")
				Select
					Case $iMsgBoxAnswer = $IDYES
						names(True)
					Case $iMsgBoxAnswer = $IDNO
						$errr = True
				EndSelect
				#EndRegion --- CodeWizard generated code Start ---
			EndIf

		Case @error = 1 ;The Cancel button was pushed
			$errr = True
		Case @error = 3 ;The InputBox failed to open
			$errr = True
	EndSelect
	#EndRegion --- CodeWizard generated code Start ---
	If $hodd = False And $errr = False And TrayItemGetState($settings1) = 68 Then

		#Region --- CodeWizard generated code Start ---

		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=None
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO, "Restart", "You must close then relaunch this program in order for the additions/changes you have made to display.  Would you like to auto-restart the program now?")
		Select
			Case $iMsgBoxAnswer = $IDYES
				Exit 3

			Case $iMsgBoxAnswer = $IDNO

		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
	EndIf

EndFunc   ;==>names
Func usernames($hohoho)
	$usernum = Int(IniRead($storepath, "Hold Num", "User number", "0"))
	$usernamestore = ""
	While 1
		$errr = False
		$usernum = $usernum + 1
		#Region --- CodeWizard generated code Start ---
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=Yes, Mandatory
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("User ID", "Input the user ID you want to store", "", " M")
		Select
			Case @error = 0 And $sInputBoxAnswer <> "" ;OK - The string returned is valid
				$usernamestore = $sInputBoxAnswer


			Case Else ;The Cancel button was pushed
				$errr = True
				$usernum -= 1
				ExitLoop
		EndSelect


		#EndRegion --- CodeWizard generated code Start ---
		If checkDuplicates($usernamestore, "User Names") Then
			If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONHAND, "Duplicate", "The username you entered already exists.  Do you want to try again?")
			Select
				Case $iMsgBoxAnswer = $IDYES
					$usernum = $usernum - 1
					ContinueLoop
				Case $iMsgBoxAnswer = $IDNO
					$usernum = $usernum - 1
					ExitLoop
			EndSelect
		EndIf


		#Region --- CodeWizard generated code Start ---

		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "Add more?", "Do you want to add another user name?")
		Select
			Case $iMsgBoxAnswer = $IDYES
				IniWrite($storepath, "User Names", "User name " & $usernum, encry($usernamestore))
				ContinueLoop

			Case $iMsgBoxAnswer = $IDNO
				IniWrite($storepath, "User Names", "User name " & $usernum, encry($usernamestore))
				ExitLoop

		EndSelect
		#EndRegion --- CodeWizard generated code Start ---


	WEnd
	IniWrite($storepath, "Hold Num", "User number", $usernum)
	EnvUpdate()
	If IsDeclared("Combo1") = 1 Or IsDeclared("Combo1") = -1 Then
		_GUICtrlComboBox_ResetContent($Combo1)
		Local $numusername2 = IniReadSection($storepath, "User Names")
		If $numusername2[0][0] > 1 Then
			For $count1 = 1 To $numusername2[0][0] Step 1
				GUICtrlSetData($Combo1, BinaryToString(decry($numusername2[$count1][1])))
			Next
		Else
			GUICtrlSetData($Combo1, BinaryToString(decry($numusername2[1][1])))
		EndIf
	EndIf
EndFunc   ;==>usernames
Func passx($pig)
	$passstore = ""
	$harp = Int(IniRead($storepath, "Hold Num", "Password Number", "0"))
	While 1
		$errr = False
		$harp = $harp + 1
		#Region --- CodeWizard generated code Start ---
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=Yes, Pwd Char=*
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("Input Password", "Input password", "Input Here", "*M")
		Select
			Case @error = 0 And $sInputBoxAnswer <> "" ;OK - The string returned is valid
				$passstore = $sInputBoxAnswer

			Case Else ;The Cancel button was pushed
				$errr = True
				$harp -= 1
				ExitLoop
		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
		If Not checkDuplicates($passstore, "Password") Then

			;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
			If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "Add more?", "Do you want to add another password?")
			Select
				Case $iMsgBoxAnswer = $IDYES
					IniWrite($storepath, "Password", "Password " & $harp, encry($passstore))
					ContinueLoop

				Case $iMsgBoxAnswer = $IDNO
					IniWrite($storepath, "Password", "Password " & $harp, encry($passstore))
					ExitLoop

			EndSelect
			#EndRegion ### START Koda GUI section ### Form=C:\Users\whiggs\seafile\always script\form\final.kxf
		Else

			If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONHAND, "Duplicate", "The password you entered already exists.  Do you want to try again?")
			Select
				Case $iMsgBoxAnswer = $IDYES
					$harp = $harp - 1
					ContinueLoop
				Case $iMsgBoxAnswer = $IDNO
					$harp = $harp - 1
					ExitLoop
			EndSelect
		EndIf

	WEnd
	IniWrite($storepath, "Hold Num", "Password Number", $harp)
	EnvUpdate()
	If IsDeclared("Combo3") = 1 Or IsDeclared("Combo3") = -1 Then
		_GUICtrlComboBox_ResetContent($Combo3)
		Local $numpass2 = IniReadSection($storepath, "Password")
		If $numpass2[0][0] > 1 Then
			For $ghg = 1 To $numpass2[0][0] Step 1
				GUICtrlSetData($Combo3, BinaryToString(decry($numpass2[$ghg][1])))
			Next
		Else
			GUICtrlSetData($Combo3, BinaryToString(decry($numpass2[1][1])))
		EndIf
	EndIf
EndFunc   ;==>passx
Func emailadd($up)
	$emailstore = ""
	$hark = Int(IniRead($storepath, "Hold Num", "Email number", "0"))
	While 1
		$errr = False
		$hark = $hark + 1
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=Yes, Pwd Char=*
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("Input email", "Input email", "", " M")
		Select
			Case @error = 0 And StringRegExp($sInputBoxAnswer, "^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)*)\.([A-Za-z]{2,})$") = 1 ;"^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$") = 1;OK - The string returned is valid
				$emailstore = $sInputBoxAnswer


			Case @error = 1 ;The Cancel button was pushed
				$errr = True
				$hark -= 1
				ExitLoop

			Case @error = 3 ;The InputBox failed to open
				$errr = True
				$hark -= 1
				ExitLoop
			Case Else
				#Region --- CodeWizard generated code Start ---

				;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Critical
				If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
				$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONHAND, "Invalid input", "The input you havd provided is invalid.  Try again?")
				Select
					Case $iMsgBoxAnswer = $IDYES
						$hark = $hark - 1
						ContinueLoop

					Case $iMsgBoxAnswer = $IDNO
						$errr = True
						$hark = $hark - 1
						ExitLoop

				EndSelect
				#EndRegion --- CodeWizard generated code Start ---


		EndSelect
		#Region --- CodeWizard generated code Start ---
		If checkDuplicates($emailstore, "Email") Then
			If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONHAND, "Duplicate", "The email you entered already exists.  Do you want to try again?")
			Select
				Case $iMsgBoxAnswer = $IDYES
					$hark = $hark - 1
					ContinueLoop
				Case $iMsgBoxAnswer = $IDNO
					$hark = $hark - 1
					ExitLoop
			EndSelect
		EndIf

		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "Add more?", "Do you want to add another email?")
		Select
			Case $iMsgBoxAnswer = $IDYES
				IniWrite($storepath, "Email", "Email " & $hark, encry($emailstore))
				ContinueLoop

			Case $iMsgBoxAnswer = $IDNO
				IniWrite($storepath, "Email", "Email " & $hark, encry($emailstore))
				ExitLoop

		EndSelect
		#EndRegion --- CodeWizard generated code Start ---

	WEnd
	IniWrite($storepath, "Hold Num", "Email number", $hark)
	EnvUpdate()
	If IsDeclared("Combo2") = 1 Or IsDeclared("Combo2") = -1 Then
		_GUICtrlComboBox_ResetContent($Combo2)
		$nummail = IniReadSection($storepath, "Email")
		If $nummail[0][0] > 1 Then
			For $count2 = 1 To $nummail[0][0] Step 1
				GUICtrlSetData($Combo2, BinaryToString(decry($nummail[$count2][1])))
			Next
		Else
			GUICtrlSetData($Combo2, BinaryToString(decry($nummail[1][1])))
		EndIf
	EndIf
EndFunc   ;==>emailadd
Func addradd($flop)
	$uname = ""
	$ustreet = ""
	$ucity = ""
	$ustate = ""
	$uzip = ""
	$crud = Int(IniRead($storepath, "Hold Num", "Address", "0"))
	While 1

		$persadd = _MLInputBox("Personal address entry", Default, "Please input an address where you have previously lived/are living.  Your input should be formatted as indicated below.", "Display name of address entry" & @CRLF & "Street Address" & @CRLF & "Optional Suite/Apt. #" & @CRLF & "City, State ZIP", Default, $Form1_1)
		If @error Then
			SetError(0)
			ExitLoop
		Else
			$persadd = SpellGUI(StringReplace($persadd, "\n", @CRLF))
			If @error Then
				SetError(0)
				ExitLoop
			Else

				$addsplit = StringSplit($persadd, "\n", $STR_ENTIRESPLIT)
				If @error Or $addsplit[0] > 4 Or $addsplit[0] < 3 Then
					SetError(0)
					MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The string is not formatted correctly.  Try again.")
					ExitLoop
				Else
					If $addsplit[0] = 3 Then
						$uname = StringStripWS($addsplit[1], 3)
						If checkDuplicates($uname, "Address") Then
							If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
							$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONHAND, "Duplicate", "The address you entered already exists.  Do you want to try again?")
							Select
								Case $iMsgBoxAnswer = $IDYES
									ContinueLoop
								Case $iMsgBoxAnswer = $IDNO
									ExitLoop
							EndSelect
						EndIf

						$ustreet = StringStripWS($addsplit[2], 3)
						$addsplit2 = StringSplit($addsplit[3], ",")

						If @error Then
							SetError(0)
							MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Try again.")
							ExitLoop
						Else
							$ucity = StringStripWS($addsplit2[1], 3)
							$addsplit3 = StringSplit(StringStripWS($addsplit2[2], 3), " ")
							If @error Then
								SetError(0)
								MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Try again.")
								ExitLoop
							Else
								$uzip = $addsplit3[$addsplit3[0]]
								If $addsplit3[0] = 2 Then
									$ustate = $addsplit3[1]
								Else
									$ustate = $addsplit3[1] & " " & $addsplit3[2]
								EndIf
								$errr = False
								$crud += 1
								IniWrite($storepath, "Address " & $crud, "Name", encry($uname))
								IniWrite($storepath, "Address " & $crud, "Street", encry($ustreet))
								IniWrite($storepath, "Address " & $crud, "City", encry($ucity))
								IniWrite($storepath, "Address " & $crud, "State", encry($ustate))
								IniWrite($storepath, "Address " & $crud, "Zip", encry($uzip))
							EndIf
						EndIf

					Else
						$uname = StringStripWS($addsplit[1], 3)
						If checkDuplicates($uname, "Address") Then
							If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
							$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONHAND, "Duplicate", "The address you entered already exists.  Do you want to try again?")
							Select
								Case $iMsgBoxAnswer = $IDYES
									ContinueLoop
								Case $iMsgBoxAnswer = $IDNO
									ExitLoop
							EndSelect
						EndIf
						$ustreet = StringStripWS($addsplit[2], 3)
						$uapt = StringStripWS($addsplit[3], 3)
						$addsplit2 = StringSplit(StringStripWS($addsplit[4], 3), ",")

						If @error Then
							SetError(0)
							MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Try again.")
							ExitLoop
						Else
							$ucity = StringStripWS($addsplit2[1], 3)
							$addsplit3 = StringSplit(StringStripWS($addsplit2[2], 3), " ")
							If @error Then
								SetError(0)
								MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Try again.")
								ExitLoop
							Else
								$uzip = $addsplit3[$addsplit3[0]]
								If $addsplit3[0] = 2 Then
									$ustate = $addsplit3[1]
								Else
									$ustate = $addsplit3[1] & " " & $addsplit3[2]
								EndIf
								$errr = False
								$crud += 1
								IniWrite($storepath, "Address " & $crud, "Name", encry($uname))
								IniWrite($storepath, "Address " & $crud, "Street", encry($ustreet))
								IniWrite($storepath, "Address " & $crud, "Apt", encry($uapt))
								IniWrite($storepath, "Address " & $crud, "City", encry($ucity))
								IniWrite($storepath, "Address " & $crud, "State", encry($ustate))
								IniWrite($storepath, "Address " & $crud, "Zip", encry($uzip))
							EndIf
						EndIf
					EndIf
					;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "Add more?", "Do you want to add another address?")
					Select
						Case $iMsgBoxAnswer = $IDYES

							ContinueLoop

						Case $iMsgBoxAnswer = $IDNO
							ExitLoop
					EndSelect



				EndIf
			EndIf
		EndIf

	WEnd
	IniWrite($storepath, "Hold Num", "Address", $crud)
	EnvUpdate()
	If IsDeclared("List5") = 1 Or IsDeclared("List5") = -1 Then
		_GUICtrlListBox_ResetContent($List5)
		$hell = Int(IniRead($storepath, "Hold Num", "Address", "0"))
		For $fra = 1 To $hell Step 1
			GUICtrlSetData($List5, BinaryToString(decry(IniRead($storepath, "Address " & $fra, "Name", ""))))
		Next
	EndIf

EndFunc   ;==>addradd

Func phoneadd($rob)
	$hart = Int(IniRead($storepath, "Hold Num", "Phone number", "0"))
	Local $newarray[10]
	$phonestring = ""
	$araystore = 0
	While 1
		$errr = False
		$hart = $hart + 1
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=Yes, Pwd Char=*
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("Input Phone number", "Input phone number", "", " M")
		Select
			Case @error = 0             ;OK- The string returned is valid
				$phonestore = StringSplit($sInputBoxAnswer, "")
				For $cro = 1 To $phonestore[0] Step 1
					If StringIsInt($phonestore[$cro]) Then
						$phonestring = $phonestring & $phonestore[$cro]
					Else
						ContinueLoop
					EndIf
				Next
				If StringLen($phonestring) <> 10 Then
					#Region --- CodeWizard generated code Start ---

					;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Warning
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONEXCLAMATION, "Not valid phone number", "A valid phone number contains 10 digits.  Whatever you typed in, it was not a valid phone number and will not be saved.  Would you like to try to re-enter your phone number?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							$hart = $hart - 1
							ContinueLoop


						Case $iMsgBoxAnswer = $IDNO
							$errr = True
							$hart = $hart - 1
							ExitLoop

					EndSelect
					#EndRegion --- CodeWizard generated code Start ---
				Else
					If checkDuplicates($phonestring, "Phone number") Then
						If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
						$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONHAND, "Duplicate", "The phone number you entered already exists.  Do you want to try again?")
						Select
							Case $iMsgBoxAnswer = $IDYES
								$hart = $hart - 1
								ContinueLoop
							Case $iMsgBoxAnswer = $IDNO
								$hart = $hart - 1
								ExitLoop
						EndSelect
					Else
						IniWrite($storepath, "Phone number", "Phone number " & $hart, encry($phonestring))
					EndIf

				EndIf


			Case @error = 1             ;The Cancel button was pushed
				$errr = True
				$hart -= 1
				ExitLoop
			Case @error = 3             ;The InputBox failed to open
				$errr = True
				$hart -= 1
				ExitLoop
		EndSelect
		#Region --- CodeWizard generated code Start ---

		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "Add more?", "Do you want to add another phone number?")
		Select
			Case $iMsgBoxAnswer = $IDYES
				ContinueLoop

			Case $iMsgBoxAnswer = $IDNO
				ExitLoop

		EndSelect
		#EndRegion --- CodeWizard generated code Start ---

	WEnd
	IniWrite($storepath, "Hold Num", "Phone number", $hart)
	EnvUpdate()
	If IsDeclared("Combo5") = 1 Or IsDeclared("Combo5") = -1 Then
		_GUICtrlComboBox_ResetContent($Combo5)
		Local $numphone = IniReadSection($storepath, "Phone number")
		For $why = 1 To $numphone[0][0] Step 1
			GUICtrlSetData($Combo5, BinaryToString(decry($numphone[$why][1])))
		Next
	EndIf
EndFunc   ;==>phoneadd

Func compadd()
	$numcomp = Int(IniRead($storepath, "Hold Num", "Company number", "0"))


	$compstore = ""
	$compaddr = ""
	$compaddr2 = ""
	$compaddr3 = ""
	$compaddr4 = ""
	$compaddr5 = ""
	$compph = ""
	$hassuite = False
	$comptitle = ""
	$compstart = ""
	$compend = ""
	$comppay = ""
	$compdescribe = ""
	$compreason = ""
	;If $pud = True Then
	While 1
		$errr = False

		;InputBox features: Title=Yes, Prompt=Yes, Default Text=Yes, Pwd Char=*
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("Input Company name", "Input company name", "", " M")
		Select
			Case @error = 0 And $sInputBoxAnswer <> ""             ;OK - The string returned is valid
				$compstore = SpellGUI(StringReplace($sInputBoxAnswer, "\n", @CRLF))
				If @error Then
					SetError(0)
					ExitLoop
				EndIf
			Case Else             ;The Cancel button was pushed
				$errr = True
				ExitLoop
		EndSelect
		If checkDuplicates($compstore, "Company") Then
			If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONHAND, "Duplicate", "The company you entered already exists.  Do you want to try again?")
			Select
				Case $iMsgBoxAnswer = $IDYES
					ContinueLoop
				Case $iMsgBoxAnswer = $IDNO
					ExitLoop
			EndSelect
		EndIf

		$tempadd = _MLInputBox("Company Address", Default, "Please input the address of the company.  Your input should be formatted as indicated below.", "Street Address" & @CRLF & "Optional Suite/Apt. #" & "City, State ZIP", Default, $Form1_1)
		If @error Then
			SetError(0)
			ExitLoop
		Else
			$tempadd = SpellGUI(StringReplace($tempadd, "\n", @CRLF))
			If @error Then
				SetError(0)
				ExitLoop
			Else

				$addsplit4 = StringSplit($tempadd, "\n", $STR_ENTIRESPLIT)
				If @error Or $addsplit4[0] < 2 Or $addsplit4[0] > 3 Then
					SetError(0)
					MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The string is not formatted correctly.  Try again.")
					ExitLoop
				Else
					If $addsplit4[0] = 2 Then
						$hassuite = False
						$compaddr = StringStripWS($addsplit4[1], 3)
						$addsplit5 = StringSplit($addsplit4[2], ",")
						If @error Then
							SetError(0)
							MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Try again.")
							ExitLoop
						Else
							$compaddr2 = StringStripWS($addsplit5[1], 3)
							$addsplit6 = StringSplit(StringStripWS($addsplit5[2], 3), " ")
							If @error Then
								SetError(0)
								MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Try again.")
								ExitLoop
							Else
								$compaddr4 = $addsplit6[$addsplit6[0]]
								If $addsplit6[0] = 2 Then
									$compaddr3 = $addsplit6[1]
								Else
									$compaddr3 = $addsplit6[1] & " " & $addsplit6[2]
								EndIf
							EndIf
						EndIf
					Else
						$hassuite = True
						$compaddr = StringStripWS($addsplit4[1], 3)
						$compaddr2 = StringStripWS($addsplit4[2], 3)
						$addsplit5 = StringSplit($addsplit4[3], ",")
						If @error Then
							SetError(0)
							MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Try again.")
							ExitLoop
						Else
							$compaddr3 = StringStripWS($addsplit5[1], 3)
							$addsplit6 = StringSplit(StringStripWS($addsplit5[2], 3), " ")
							If @error Then
								SetError(0)
								MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Try again.")
								ExitLoop
							Else
								$compaddr5 = $addsplit6[$addsplit6[0]]
								If $addsplit6[0] = 2 Then
									$compaddr4 = $addsplit6[1]
								Else
									$compaddr4 = $addsplit6[1] & " " & $addsplit6[2]
								EndIf
							EndIf
						EndIf
					EndIf

				EndIf
			EndIf
		EndIf

		$compph = otherPhone()
		If @error Then
			SetError(0)
			$errr = True
			ExitLoop
		EndIf
		#Region --- CodeWizard generated code Start ---
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=No
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("Title at company", "What title did you hold while working at the company?", "", " M")
		Select
			Case @error = 0 And $sInputBoxAnswer <> ""             ;OK - The string returned is valid
				$comptitle = SpellGUI(StringReplace($sInputBoxAnswer, "\n", @CRLF))
				If @error Then
					SetError(0)
					ExitLoop
				EndIf
			Case Else             ;The Cancel button was pushed
				$errr = True
				ExitLoop
		EndSelect

		#Region --- CodeWizard generated code Start ---
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=No
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("Start Date", "When did you start working at the company?", "", " M")
		Select
			Case @error = 0 And $sInputBoxAnswer <> ""             ;OK - The string returned is valid
				$compstart = $sInputBoxAnswer

			Case Else             ;The Cancel button was pushed
				$errr = True
				ExitLoop
		EndSelect
		#Region --- CodeWizard generated code Start ---

		#Region --- CodeWizard generated code Start ---
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=No
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("End Date", 'When did you stop working at the company?  Put "NA" if you still work at the company.', "", " M")
		Select
			Case @error = 0 And $sInputBoxAnswer <> ""             ;OK - The string returned is valid
				$compend = $sInputBoxAnswer

			Case Else             ;The Cancel button was pushed
				$errr = True
				ExitLoop
		EndSelect
		#Region --- CodeWizard generated code Start ---

		#Region --- CodeWizard generated code Start ---
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=No
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("Salary", "What was your salary while working at the company?", "", " M")
		Select
			Case @error = 0 And $sInputBoxAnswer <> ""             ;OK - The string returned is valid
				$comppay = $sInputBoxAnswer

			Case Else             ;The Cancel button was pushed
				$errr = True
				ExitLoop
		EndSelect
		#Region --- CodeWizard generated code Start ---

		$compdescribe = _MLInputBox("Description of duties", Default, "Describe the tasks performed while working for this company.", "", Default, $Form1_1)
		If @error Then
			SetError(0)
			$errr = True
			ExitLoop
		Else
			$compdescribe = SpellGUI(StringReplace($compdescribe, "\n", @CRLF))
			If @error Then
				SetError(0)
				ExitLoop
			EndIf
		EndIf

		$compreason = _MLInputBox("Reason left", Default, "Explain the circumstances regarding your leaving the company.", "", Default, $Form1_1)
		If @error Then
			SetError(0)
			ExitLoop
		Else
			$compreason = SpellGUI(StringReplace($compreason, "\n", @CRLF))
			If @error Then
				SetError(0)
				ExitLoop
			EndIf
		EndIf

		$numcomp = $numcomp + 1
		IniWrite($storepath, "Company " & $numcomp, "Company name", encry($compstore))
		IniWrite($storepath, "Company " & $numcomp, "Company street address", encry($compaddr))
		If $hassuite = False Then
			IniWrite($storepath, "Company " & $numcomp, "Company city", encry($compaddr2))
			IniWrite($storepath, "Company " & $numcomp, "Company state", encry($compaddr3))
			IniWrite($storepath, "Company " & $numcomp, "Company ZIP", encry($compaddr4))
		Else
			IniWrite($storepath, "Company " & $numcomp, "Company suite number", encry($compaddr2))
			IniWrite($storepath, "Company " & $numcomp, "Company city", encry($compaddr3))
			IniWrite($storepath, "Company " & $numcomp, "Company state", encry($compaddr4))
			IniWrite($storepath, "Company " & $numcomp, "Company ZIP", encry($compaddr5))
		EndIf

		IniWrite($storepath, "Company " & $numcomp, "Company phone", encry($compph))
		IniWrite($storepath, "Company " & $numcomp, "Company title", encry($comptitle))
		IniWrite($storepath, "Company " & $numcomp, "Company start", encry($compstart))
		IniWrite($storepath, "Company " & $numcomp, "Company end", encry($compend))
		IniWrite($storepath, "Company " & $numcomp, "Company salary", encry($comppay))
		IniWrite($storepath, "Company " & $numcomp, "Company job description", encry($compdescribe))
		IniWrite($storepath, "Company " & $numcomp, "Company reason left", encry($compreason))
		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "Add more?", "Do you want to add information on another company?")
		Select
			Case $iMsgBoxAnswer = $IDYES

				ContinueLoop

			Case $iMsgBoxAnswer = $IDNO
				ExitLoop

		EndSelect
		#EndRegion --- CodeWizard generated code Start ---

	WEnd
	IniWrite($storepath, "Hold Num", "Company number", $numcomp)
	If IsDeclared("List1") = 1 Or IsDeclared("List1") = -1 Then
		_GUICtrlListBox_ResetContent($List1)
		$gogo = Int(IniRead($storepath, "Hold Num", "Company number", "Problem somewhere"))
		For $ytr = 1 To $gogo Step 1
			GUICtrlSetData($List1, BinaryToString(decry(IniRead($storepath, "Company " & $ytr, "Company name", "Null"))))
		Next
	EndIf

EndFunc   ;==>compadd

Func refadd($rec)
	$numref = Int(IniRead($storepath, "Hold Num", "Reference Number", "0"))

	$refstore = ""
	$refemail = ""
	$refcomp = ""
	$refphone = ""
	$reftitle = ""
	$refyears = 0
	$refrelat = ""
	While 1
		$errr = False

		#Region --- CodeWizard generated code Start ---
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=No
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("Reference name", "Please input the full name of your reference.", "", " M")
		Select
			Case @error = 0 And $sInputBoxAnswer <> ""             ;OK - The string returned is valid
				$refstore = $sInputBoxAnswer

			Case Else             ;The Cancel button was pushed
				$errr = True
				ExitLoop
		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
		If checkDuplicates($refstore, "Reference") Then
			If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONHAND, "Duplicate", "The reference you entered already exists.  Do you want to try again?")
			Select
				Case $iMsgBoxAnswer = $IDYES
					ContinueLoop
				Case $iMsgBoxAnswer = $IDNO
					ExitLoop
			EndSelect
		EndIf

		#Region --- CodeWizard generated code Start ---
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=No
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("Reference company", "Please input the company for which the reference works.", "", " M")
		Select
			Case @error = 0 And $sInputBoxAnswer <> ""             ;OK - The string returned is valid
				$refcomp = SpellGUI(StringReplace($sInputBoxAnswer, "\n", @CRLF))
				If @error Then
					SetError(0)
					ExitLoop
				EndIf

			Case Else             ;The Cancel button was pushed
				$errr = True
				ExitLoop

		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
		#Region --- CodeWizard generated code Start ---
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=No
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("Title", "Input this reference's title", "", " M")
		Select
			Case @error = 0 And $sInputBoxAnswer <> ""             ;OK - The string returned is valid
				$reftitle = SpellGUI(StringReplace($sInputBoxAnswer, "\n", @CRLF))
				If @error Then
					SetError(0)
					ExitLoop
				EndIf

			Case Else             ;The Cancel button was pushed
				$errr = True
				ExitLoop

		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
		$refphone = otherPhone()
		If @error Then
			SetError(0)
			$errr = True
			ExitLoop
		EndIf
		$refemail = otherEmail()
		If @error Then
			SetError(0)
			$errr = True
			ExitLoop
		EndIf
		#Region --- CodeWizard generated code Start ---
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=No
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("Relationship", "What is the reference's relationship to you?", "", " M")
		Select
			Case @error = 0 And $sInputBoxAnswer <> ""             ;OK - The string returned is valid
				$refrelat = SpellGUI(StringReplace($sInputBoxAnswer, "\n", @CRLF))
				If @error Then
					SetError(0)
					ExitLoop
				EndIf

			Case Else
				$errr = True
				ExitLoop
		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
		#Region --- CodeWizard generated code Start ---
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=No
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("Years", "How many years have you known the reference?", "", " M")
		Select
			Case @error = 0 And $sInputBoxAnswer <> ""             ;OK - The string returned is valid
				$refyears = $sInputBoxAnswer

			Case Else             ;The Cancel button was pushed
				$errr = True
				ExitLoop


		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
		#Region --- CodeWizard generated code Start ---

		$numref = $numref + 1
		IniWrite($storepath, "Reference " & $numref, "Name", encry($refstore))
		IniWrite($storepath, "Reference " & $numref, "Company", encry($refcomp))
		IniWrite($storepath, "Reference " & $numref, "Title", encry($reftitle))
		IniWrite($storepath, "Reference " & $numref, "Phone number", encry($refphone))
		IniWrite($storepath, "Reference " & $numref, "Email", encry($refemail))
		IniWrite($storepath, "Reference " & $numref, "Relationship", encry($refrelat))
		IniWrite($storepath, "Reference " & $numref, "Years Known", encry($refyears))
		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "Add more?", "Do you want to add information on another reference?")
		Select
			Case $iMsgBoxAnswer = $IDYES

				ContinueLoop

			Case $iMsgBoxAnswer = $IDNO
				ExitLoop

		EndSelect
		#EndRegion --- CodeWizard generated code Start ---

	WEnd

	IniWrite($storepath, "Hold Num", "Reference Number", $numref)
	If IsDeclared("List4") = 1 Or IsDeclared("List4") = -1 Then
		_GUICtrlListBox_ResetContent($List4)
		$too = Int(IniRead($storepath, "Hold Num", "Reference Number", "Problem"))
		For $prep = 1 To $too Step 1
			GUICtrlSetData($List4, BinaryToString(decry(IniRead($storepath, "Reference " & $prep, "Name", "Null"))))
		Next
	EndIf
EndFunc   ;==>refadd

Func Edadd($cut)
	$numed = Int(IniRead($storepath, "Hold Num", "Education number", "0"))
	$choice = False
	$storeed = ""
	$edadd1 = ""
	$edadd2 = ""
	$edadd3 = ""
	$edadd4 = ""
	$edgpa = ""
	$edphone = ""
	$eddegree = ""
	While 1
		$errr = False
		#Region --- CodeWizard generated code Start ---
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=No
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("Name", "What is the name of the educational institution?", "", " M")
		Select
			Case @error = 0 And $sInputBoxAnswer <> ""             ;OK - The string returned is valid
				$storeed = SpellGUI(StringReplace($sInputBoxAnswer, "\n", @CRLF))
				If @error Then
					SetError(0)
					ExitLoop
				EndIf
			Case Else             ;The Cancel button was pushed
				$errr = True
				ExitLoop
		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
		If checkDuplicates($storeed, "Education history") Then
			If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONHAND, "Duplicate", "The school you entered already exists.  Do you want to try again?")
			Select
				Case $iMsgBoxAnswer = $IDYES
					ContinueLoop
				Case $iMsgBoxAnswer = $IDNO
					ExitLoop
			EndSelect
		EndIf



		#Region --- CodeWizard generated code Start ---

		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=None
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO, "Education level", 'Select "yes" if this is a college educational facility.  Select "no" if this is a high school educational facility')
		Select
			Case $iMsgBoxAnswer = $IDYES
				$choice = True

			Case $iMsgBoxAnswer = $IDNO
				$choice = False

		EndSelect
		#EndRegion --- CodeWizard generated code Start ---

		#Region --- CodeWizard generated code Start ---
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=No
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("Degree?", "What degree did you receive at the school?", "", " M")
		Select
			Case @error = 0 And $sInputBoxAnswer <> ""             ;OK - The string returned is valid
				$eddegree = SpellGUI(StringReplace($sInputBoxAnswer, "\n", @CRLF))
				If @error Then
					SetError(0)
					ExitLoop
				EndIf

			Case Else             ;The Cancel button was pushed
				$errr = True
				ExitLoop
		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
		#Region --- CodeWizard generated code Start ---
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=No
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("GPA", "What was/is your gpa at the educational institution?", "", " M")
		Select
			Case @error = 0 And $sInputBoxAnswer <> ""             ;OK - The string returned is valid
				$edgpa = $sInputBoxAnswer

			Case Else             ;The Cancel button was pushed
				$errr = True
				ExitLoop
		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
		$edphone = otherPhone()
		If @error Then
			SetError(0)
			$errr = True
			ExitLoop
		EndIf
		$resadd = _MLInputBox("Educational Institution Address", Default, "Please input the address of the educational institution.  Your input should be formatted as indicated below.", "Street Address" & @CRLF & "City, State ZIP", Default, $Form1_1)
		If @error Then
			SetError(0)
			ExitLoop
		Else
			$resadd = SpellGUI(StringReplace($resadd, "\n", @CRLF))
			If @error Then
				SetError(0)
				ExitLoop
			Else

				$addsplit4 = StringSplit($resadd, "\n", $STR_ENTIRESPLIT)
				If @error Or $addsplit4[0] > 2 Then
					SetError(0)
					MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The string is not formatted correctly.  Try again.")
					ExitLoop
				Else
					$edadd1 = StringStripWS($addsplit4[1], 3)
					$addsplit5 = StringSplit($addsplit4[2], ",")
					If @error Then
						SetError(0)
						MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Try again.")
						ExitLoop
					Else
						$edadd2 = StringStripWS($addsplit5[1], 3)
						$addsplit6 = StringSplit(StringStripWS($addsplit5[2], 3), " ")
						If @error Then
							SetError(0)
							MsgBox($MB_OK + $MB_ICONHAND, "Incorrect format", "The second line of the string is not formatted correctly.  Try again.")
							ExitLoop
						Else
							$edadd4 = $addsplit6[$addsplit6[0]]
							If $addsplit6[0] = 2 Then
								$edadd3 = $addsplit6[1]
							Else
								$edadd3 = $addsplit6[1] & " " & $addsplit6[2]
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf

		#Region --- CodeWizard generated code Start ---
		$numed = $numed + 1
		IniWrite($storepath, "Education history " & $numed, "Name", encry($storeed))
		If $choice = True Then
			IniWrite($storepath, "Education history " & $numed, "Education Level", encry("College"))
		Else
			IniWrite($storepath, "Education history " & $numed, "Education Level", encry("High school"))
		EndIf
		IniWrite($storepath, "Education history " & $numed, "Degree", encry($eddegree))
		IniWrite($storepath, "Education history " & $numed, "GPA", encry($edgpa))
		IniWrite($storepath, "Education history " & $numed, "Phone number", encry($edphone))
		IniWrite($storepath, "Education history " & $numed, "Street Address", encry($edadd1))
		IniWrite($storepath, "Education history " & $numed, "City", encry($edadd2))
		IniWrite($storepath, "Education history " & $numed, "State", encry($edadd3))
		IniWrite($storepath, "Education history " & $numed, "Zip code", encry($edadd4))
		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "More schools?", "Are there more schools you would like to enter?")
		Select
			Case $iMsgBoxAnswer = $IDYES

				ContinueLoop

			Case $iMsgBoxAnswer = $IDNO
				ExitLoop

		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
	WEnd
	IniWrite($storepath, "Hold Num", "Education number", $numed)
	If (IsDeclared("List2") = 1 Or IsDeclared("List2") = -1) And (IsDeclared("List3") = 1 Or IsDeclared("List3") = -1) Then
		_GUICtrlListBox_ResetContent($List2)
		_GUICtrlListBox_ResetContent($List3)
		$thee = Int(IniRead($storepath, "Hold Num", "Education Number", "Null"))
		For $rer = 1 To $thee Step 1
			If BinaryToString(decry(IniRead($storepath, "Education history " & $rer, "Education Level", "null"))) == "College" Then
				GUICtrlSetData($List3, BinaryToString(decry(IniRead($storepath, "Education history " & $rer, "Name", "null"))))
			Else
				GUICtrlSetData($List2, BinaryToString(decry(IniRead($storepath, "Education history " & $rer, "Name", "null"))))
			EndIf
		Next
	EndIf
EndFunc   ;==>Edadd
Func otherPhone()
	Local $pharray[10]
	$newint = 0
	$newst = ""
	$toi = 0

	#Region --- CodeWizard generated code Start ---
	;InputBox features: Title=Yes, Prompt=Yes, Default Text=No, Mandatory
	If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
	$sInputBoxAnswer = InputBox("Phone number", "Please provide a phone number for contact", "", " M")
	Select
		Case @error = 0             ;OK - The string returned is valid
			$oth = StringSplit($sInputBoxAnswer, "")
			For $hh = 1 To $oth[0] Step 1
				$newint = Int($oth[$hh])
				If $newint = 0 And $oth[$hh] <> "0" Then
					ContinueLoop
				Else
					If $toi = 10 Then
						SetError(3)
						ExitLoop
					Else
						$pharray[$toi] = $newint
						$toi += 1
					EndIf
				EndIf
			Next
			If @error Then
				SetError(0)
				;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=None
				If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
				$iMsgBoxAnswer = MsgBox($MB_YESNO, "Invalid input", "Standard phone numbers are 10 digits long.  It does not matter what separators you use to separate the numbers, but the phone number has to have 10 digits to be a valid selection.  If you do not enter a valid phone number, the data for the entry you were working on will be lost.  Try again?")
				Select
					Case $iMsgBoxAnswer = $IDYES
						otherPhone()
					Case $iMsgBoxAnswer = $IDNO
						SetError(5)
				EndSelect
				#EndRegion --- CodeWizard generated code Start ---
			Else
				For $tod = 0 To UBound($pharray) - 1 Step 1
					$newst &= $pharray[$tod]
				Next

				Return $newst


			EndIf

		Case @error = 1             ;The Cancel button was pushed

		Case @error = 3             ;The InputBox failed to open

	EndSelect
	#EndRegion --- CodeWizard generated code Start ---
EndFunc   ;==>otherPhone
Func otherEmail()
	#Region --- CodeWizard generated code Start ---
	;InputBox features: Title=Yes, Prompt=Yes, Default Text=No, Mandatory
	If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
	$sInputBoxAnswer = InputBox("Email address", "Enter the email address", "", " M")
	Select
		Case @error = 0 And StringRegExp($sInputBoxAnswer, "^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)*)\.([A-Za-z]{2,})$") = 1             ;OK - The string returned is valid
			Return $sInputBoxAnswer

		Case Else
			#Region --- CodeWizard generated code Start ---

			;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Critical
			If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONHAND, "Invalid email format", "Whatever you put in the prompt, it did not meet the criteria for an email address.  Try again or don't, I really don't care.")
			Select
				Case $iMsgBoxAnswer = $IDYES
					otherEmail()
				Case $iMsgBoxAnswer = $IDNO
					SetError(6)
			EndSelect
			#EndRegion --- CodeWizard generated code Start ---


	EndSelect
	#EndRegion --- CodeWizard generated code Start ---

EndFunc   ;==>otherEmail
Func addwebsite($input5)
	$webstore = ""
	$hopp = Int(IniRead($storepath, "Hold Num", "Website", "0"))
	While 1
		$hopp += 1
		$errr = False
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=Yes, Pwd Char=*
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
		$sInputBoxAnswer = InputBox("Input Website address", "Input URL to the website to include.", "", " M")
		Select
			Case @error = 0 And $sInputBoxAnswer <> ""             ;OK- The string returned is valid
				If checkDuplicates($sInputBoxAnswer, "Websites") Then
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONHAND, "Duplicate", "The website you entered already exists.  Do you want to try again?")
					Select
						Case $iMsgBoxAnswer = $IDYES
							$hopp = $hopp - 1
							ContinueLoop
						Case $iMsgBoxAnswer = $IDNO
							$hopp = $hopp - 1
							ExitLoop
					EndSelect
				Else
					IniWrite($storepath, "Websites", "Website " & $hopp, encry($sInputBoxAnswer))
				EndIf


			Case Else             ;The Cancel button was pushed
				$errr = True
				$hopp -= 1
				ExitLoop
		EndSelect
		#Region --- CodeWizard generated code Start ---

		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Question
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONQUESTION, "Add more?", "Do you want to add another website?")
		Select
			Case $iMsgBoxAnswer = $IDYES
				ContinueLoop

			Case $iMsgBoxAnswer = $IDNO
				ExitLoop

		EndSelect
		#EndRegion --- CodeWizard generated code Start ---

	WEnd
	IniWrite($storepath, "Hold Num", "Website", $hopp)
	EnvUpdate()
	If IsDeclared("Combo6") = 1 Or IsDeclared("Combo6") = -1 Then
		_GUICtrlComboBox_ResetContent($Combo6)
		Local $numwebsite = IniReadSection($storepath, "Websites")
		For $whh = 1 To $numwebsite[0][0] Step 1
			GUICtrlSetData($Combo6, BinaryToString(decry($numwebsite[$whh][1])))
		Next
	EndIf
EndFunc   ;==>addwebsite
Func encry($input2)
	_Crypt_Startup()
	$sret = _Crypt_EncryptData($input2, $key, $CALG_USERKEY)
	_Crypt_Shutdown()
	Return $sret
EndFunc   ;==>encry
Func decry($input)
	_Crypt_Startup()
	$rret = _Crypt_DecryptData($input, $key, $CALG_USERKEY)
	_Crypt_Shutdown()
	Return $rret
EndFunc   ;==>decry

Func checkDuplicates($check, $cate)
	$duppres = False
	$seeif = IniReadSection($storepath, $cate)
	If @error Then
		SetError(0)
		$sectnames = IniReadSectionNames($storepath)
		For $ly = 1 To $sectnames[0] Step 1
			If StringLeft($sectnames[$ly], Int(StringLen($cate))) = $cate Then
				$seeif = IniReadSection($storepath, $sectnames[$ly])
				For $tp = 1 To $seeif[0][0] Step 1
					If StringInStr($seeif[$tp][0], "name") > 0 Then
						If StringCompare($check, BinaryToString(decry($seeif[$tp][1]))) = 0 Then
							$duppres = True
							ExitLoop 2
						Else
							ContinueLoop 2
						EndIf
					EndIf
				Next
			EndIf
		Next
	Else
		For $tp = 1 To $seeif[0][0] Step 1
			If StringCompare($check, BinaryToString(decry($seeif[$tp][1]))) = 0 Then
				$duppres = True
				ExitLoop
			Else
				ContinueLoop
			EndIf
		Next
	EndIf
	Return $duppres
EndFunc   ;==>checkDuplicates

Func refresh()
	If @exitCode = 3 Then
		$some = FileGetShortName(@ScriptFullPath)
		ShellExecute(@ComSpec, '/c timeout 3 & "' & @ScriptFullPath & '"', '"' & @ScriptFullPath & '"', "", @SW_HIDE)
	Else


		;$procc = Run ( $path & "\relaunch.bat", "", @SW_SHOW ) ;$STDIN_CHILD )
		;StdinWrite ( $procc, @ScriptFullPath )
	EndIf

EndFunc   ;==>refresh
Func listSend()
	$finterrupt = 0
	WinMove($Form2, "", 0, 0)
	If _GUICtrlListView_GetSelectedCount($ListView2) = 0 Then
		#Region --- CodeWizard generated code Start ---
		;ToolTip features: Text=Yes, X Coordinate=Default, Y Coordinate=Default, Title=Yes, Error icon
		If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
		$sToolTipAnswer = ToolTip("You need to select a valid choice in order to submit this request.", Default, Default, "Make a selection", 3, 0)
		#EndRegion --- CodeWizard generated code Start ---
	Else
		ToolTip("")
		;$pastetest1 = GUICtrlRead(GUICtrlRead($ListView2))
		;$pastearray1 = StringSplit($pastetest1, "|")

		$selected = _GUICtrlListView_GetSelectedIndices($ListView2, True)

		$pastearray1 = _GUICtrlListView_GetItemText($ListView2, $selected[1], 1)
		GUICtrlSetState($Button17, $GUI_DISABLE)
		GUICtrlSetState($Button25, $GUI_DISABLE)
		GUICtrlSetData($Button16, "Stop")
		;WinSetTrans("Form2", "", 200)
		;Clipboard($pastearray1[2])
		$activewin = 0
		While 1
			Switch $finterrupt
				Case 0
				Case 1
					#cs
						$listwin = WinList ()
						For $pop = 1 To $listwin[0][0] Step 1
						$thestate = WinGetState ( $listwin[$pop][1] )
						If BitAND ( $thestate, 8 ) And $listwin[$pop][1] <> WinGetHandle ( $Form2 ) Then
						$activewin = $listwin[$pop][1]
						ExitLoop
						ElseIf BitAND ( $thestate, 8 ) And $listwin[$pop][1] = WinGetHandle ( $Form2 ) Then
						ContinueLoop
						Else
						ContinueLoop
						EndIf
						Next
					#ce
					$activewin = WinGetHandle("[ACTIVE]")
					Send("{TAB}", 0)
					WinActivate($Form2)
					GUICtrlSetState($ListView2, $GUI_FOCUS)
					$index = _GUICtrlListView_GetSelectedIndices($ListView2, False)
					If Int($index) = 0 Then
						#Region --- CodeWizard generated code Start ---
						;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Critical, Timeout=2 ss
						If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
						$iMsgBoxAnswer = MsgBox($MB_OK + $MB_ICONHAND, "Invalid", "You are already at the beginning of the list.", 2)
						#EndRegion --- CodeWizard generated code Start ---
					Else
						$newindex = Int($index) - 1
						_GUICtrlListView_SetItemSelected($ListView2, $newindex)
					EndIf
					$selected = _GUICtrlListView_GetSelectedIndices($ListView2, True)
					If StringCompare($pastearray1, _GUICtrlListView_GetItemText($ListView2, $selected[1], 1)) <> 0 Then
						$pastearray1 = _GUICtrlListView_GetItemText($ListView2, $selected[1], 1)
					EndIf
					$pastearray1 = StringReplace($pastearray1, "!", "{!}", 0)
					$pastearray1 = StringReplace($pastearray1, "+", "{+}", 0)
					$pastearray1 = StringReplace($pastearray1, "^", "{^}", 0)
					$pastearray1 = StringReplace($pastearray1, "\n", "{ENTER}", 0)
					$pastearray1 = StringReplace($pastearray1, @TAB, "     ", 0)
					WinActivate($activewin)
					WinWaitActive($activewin)
					Send($pastearray1, 0)

					$finterrupt = 0
				Case 2
					$activewin = WinGetHandle("[ACTIVE]")
					Send("{TAB}", 0)
					WinActivate($Form2)
					GUICtrlSetState($ListView2, $GUI_FOCUS)
					$index = _GUICtrlListView_GetSelectedIndices($ListView2, False)
					If $index = _GUICtrlListView_GetItemCount($ListView2) - 1 Then
						#Region --- CodeWizard generated code Start ---
						;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Critical, Timeout=2 ss
						If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
						$iMsgBoxAnswer = MsgBox($MB_OK + $MB_ICONHAND, "Invalid", "You are already at the end of the list.", 2)
						#EndRegion --- CodeWizard generated code Start ---
					Else
						$newindex = Int($index) + 1
						_GUICtrlListView_SetItemSelected($ListView2, $newindex)
					EndIf
					$selected = _GUICtrlListView_GetSelectedIndices($ListView2, True)
					If StringCompare($pastearray1, _GUICtrlListView_GetItemText($ListView2, $selected[1], 1)) <> 0 Then
						$pastearray1 = _GUICtrlListView_GetItemText($ListView2, $selected[1], 1)
					EndIf
					$pastearray1 = StringReplace($pastearray1, "!", "{!}", 0)
					$pastearray1 = StringReplace($pastearray1, "+", "{+}", 0)
					$pastearray1 = StringReplace($pastearray1, "^", "{^}", 0)
					$pastearray1 = StringReplace($pastearray1, "\n", "{ENTER}", 0)
					WinActivate($activewin)
					WinWaitActive($activewin)
					Send($pastearray1, 0)
					$finterrupt = 0
			EndSwitch
			$selected = _GUICtrlListView_GetSelectedIndices($ListView2, True)
			If $selected[0] = 0 Then
				_GUICtrlListView_SetItemSelected($ListView2, 0, True, True)
				$selected = _GUICtrlListView_GetSelectedIndices($ListView2, True)
			EndIf
			If ClipGet() <> _GUICtrlListView_GetItemText($ListView2, $selected[1], 1) Then
				ClipPut(_GUICtrlListView_GetItemText($ListView2, $selected[1], 1))
			EndIf

			If StringCompare($pastearray1, _GUICtrlListView_GetItemText($ListView2, $selected[1], 1)) <> 0 Then
				$pastearray1 = _GUICtrlListView_GetItemText($ListView2, $selected[1], 1)
			EndIf
			If _IsPressed(01) And MouseGetCursor() = 5 And WinActive("Form2", "Stop") = 0 Then
				$pastearray1 = StringReplace($pastearray1, "!", "{!}", 0)
				$pastearray1 = StringReplace($pastearray1, "+", "{+}", 0)
				$pastearray1 = StringReplace($pastearray1, "^", "{^}", 0)
				$pastearray1 = StringReplace($pastearray1, "\n", "{ENTER}", 0)
				$pastearray1 = StringReplace($pastearray1, @TAB, "   ", 0)
				;If $char[$et] == "!" Or $char[$et] == "^" Or $char[$et] == "+" Then

				;EndIf
				While _IsPressed(01)
					Sleep(70)
				WEnd

				If GUICtrlRead($Checkbox51) = 1 Then
					Send("^a" & "{BS}" & $pastearray1, 0)
				Else
					Send($pastearray1, 0)
				EndIf
				$newlistind = _GUICtrlListView_GetNextItem($ListView2)
				_GUICtrlListView_SetItemSelected($ListView2, $newlistind + 1)
			EndIf
			If GUIGetMsg() = $Button16 Then             ;_IsPressed ( 02 ) Then
				ExitLoop
			EndIf


			Sleep(50)
		WEnd
		GUICtrlSetData($Button16, "Start")
		GUICtrlSetState($Button17, $GUI_ENABLE)
		GUICtrlSetState($Button25, $GUI_ENABLE)

	EndIf
EndFunc   ;==>listSend
Func pasteList()
	WinMove($Form2, "", 0, 0)
	FileInstall("C:\Users\whiggs\OneDrive\always script\PasteButton.exe", $path & "\pastemac.exe")
	Run(@ComSpec & " /c " & '"' & $path & "\pastemac.exe" & '"', "", @SW_HIDE)
	If _GUICtrlListView_GetSelectedCount($ListView2) = 0 Then
		#Region --- CodeWizard generated code Start ---
		;ToolTip features: Text=Yes, X Coordinate=Default, Y Coordinate=Default, Title=Yes, Error icon
		If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
		$sToolTipAnswer = ToolTip("You need to select a valid choice in order to submit this request.", Default, Default, "Make a selection", 3, 0)
		#EndRegion --- CodeWizard generated code Start ---
	Else
		GUICtrlSetState($Button16, $GUI_DISABLE)
		GUICtrlSetState($Button17, $GUI_DISABLE)
		GUICtrlSetImage($Button25, $path & "\Aha-Soft-Software-Cancel.ico")
		$selected1 = _GUICtrlListView_GetSelectedIndices($ListView2, True)
		If $selected1[0] = 0 Then
			_GUICtrlListView_SetItemSelected($ListView2, 0, True, True)
			$selected1 = _GUICtrlListView_GetSelectedIndices($ListView2, True)
		EndIf
		$pastearray2 = _GUICtrlListView_GetItemText($ListView2, $selected1[1], 1)
		If StringInStr($pastearray2, "\n") > 0 Then
			$spree = StringSplit($pastearray2, "\n", $STR_ENTIRESPLIT)
			$pastearray2 = ""
			For $bee = 1 To $spree[0] Step 1
				$pastearray2 = $pastearray2 & $spree[$bee] & @CRLF
			Next
		EndIf
		ClipPut($pastearray2)
		While 1
			ToolTip("")
			;$pastetest1 = GUICtrlRead(GUICtrlRead($ListView2))
			;$pastearray1 = StringSplit($pastetest1, "|")

			$selected1 = _GUICtrlListView_GetSelectedIndices($ListView2, True)
			If StringCompare($pastearray2, _GUICtrlListView_GetItemText($ListView2, $selected1[1], 1)) <> 0 Then
				$pastearray2 = _GUICtrlListView_GetItemText($ListView2, $selected1[1], 1)
				If StringInStr($pastearray2, "\n") > 0 Then
					$spree = StringSplit($pastearray2, "\n", $STR_ENTIRESPLIT)
					$pastearray2 = ""
					For $bee = 1 To $spree[0] Step 1
						$pastearray2 = $pastearray2 & $spree[$bee] & @CRLF
					Next
				EndIf

				ClipPut($pastearray2)
			EndIf
			If GUIGetMsg() = $Button25 Then
				ExitLoop
			EndIf

			Sleep(50)
		WEnd
		Do
			ProcessClose("pastemac.exe")
		Until Not ProcessExists("pastemac.exe")

		GUICtrlSetState($Button16, $GUI_ENABLE)
		GUICtrlSetState($Button17, $GUI_ENABLE)
		GUICtrlSetImage($Button25, $path & "\1_ClipboardHelpAndSpell.ico")
	EndIf
EndFunc   ;==>pasteList

Func progUpdate()
	$size = InetGetSize("http://192.168.1.10/passw.exe", 1)
	If FileGetSize(@ScriptFullPath) <> $size And $size <> 0 Then
		#Region --- CodeWizard generated code Start ---

		;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=Info
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox($MB_YESNO + $MB_ICONASTERISK, "Update", "There is an update available.  Would you like to download it?")
		Select
			Case $iMsgBoxAnswer = $IDYES
				$down = InetGet("http://192.168.1.10/passw.exe", @ScriptDir & "\passwnew.exe", 1)
				InetClose($down)
				Exit 2

			Case $iMsgBoxAnswer = $IDNO

		EndSelect
		#EndRegion --- CodeWizard generated code Start ---
	EndIf
EndFunc   ;==>progUpdate
Func PreviousSelection()
	$finterrupt = 1
EndFunc   ;==>PreviousSelection
Func NextSelection()
	$finterrupt = 2
EndFunc   ;==>NextSelection
Func SetTransparent()
	$handle1 = WinGetHandle($Form1_1)
	$handle2 = WinGetHandle($Form2)
	$handle3 = WinGetHandle($Form3)
	$handle4 = WinGetHandle($Form3_1)
	$handle5 = WinGetHandle($Form4)
	$handle6 = WinGetHandle($Form5)
	$staate = WinGetState($nMsg[1])
	If BitAND(WinGetState($handle1), 2) Then
		$handle = $handle1
	ElseIf BitAND(WinGetState($handle2), 2) Then
		$handle = $handle2
	ElseIf BitAND(WinGetState($handle3), 2) Then
		$handle = $handle3
	ElseIf BitAND(WinGetState($handle4), 2) Then
		$handle = $handle4
	ElseIf BitAND(WinGetState($handle5), 2) Then
		$handle = $handle5
	ElseIf BitAND(WinGetState($handle6), 2) Then
		$handle = $handle6
	Else
		MsgBox(1, "", "?")
	EndIf
	If $transp = False Then
		$currstate = GUIGetStyle($handle)
		GUISetStyle(-1, Int($currstate[1]) + 32, $handle)
		WinSetTrans($handle, "", 100)
		$transp = True
	Else
		$currstate = GUIGetStyle($handle)
		GUISetStyle(-1, Int($currstate[1]) - 32, $handle)
		WinSetTrans($handle, "", 255)
		$transp = False
	EndIf
	Return $transp
EndFunc   ;==>SetTransparent
Func _GetFilename($sFilePath)
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & "." & "\root\cimv2")
	Local $oColFiles = $oWMIService.ExecQuery("Select * From CIM_Datafile Where Name = '" & StringReplace($sFilePath, "\", "\\") & "'")
	If IsObj($oColFiles) Then
		For $oObjectFile In $oColFiles
			Return $oObjectFile.FileName
		Next
	EndIf
	Return SetError(1, 1, 0)
EndFunc   ;==>_GetFilename

Func _GetFilenameExt($sFilePath)
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & "." & "\root\cimv2")
	Local $oColFiles = $oWMIService.ExecQuery("Select * From CIM_Datafile Where Name = '" & StringReplace($sFilePath, "\", "\\") & "'")
	If IsObj($oColFiles) Then
		For $oObjectFile In $oColFiles
			Return $oObjectFile.Extension
		Next
	EndIf
	Return SetError(1, 1, 0)
EndFunc   ;==>_GetFilenameExt

Func _GetFilenameInt($sFilePath)
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & "." & "\root\cimv2")
	Local $oColFiles = $oWMIService.ExecQuery("Select * From CIM_Datafile Where Name = '" & StringReplace($sFilePath, "\", "\\") & "'")
	If IsObj($oColFiles) Then
		For $oObjectFile In $oColFiles
			Return $oObjectFile.Name
		Next
	EndIf
	Return SetError(1, 1, 0)
EndFunc   ;==>_GetFilenameInt

Func _GetFilenameDrive($sFilePath)
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & "." & "\root\cimv2")
	Local $oColFiles = $oWMIService.ExecQuery("Select * From CIM_Datafile Where Name = '" & StringReplace($sFilePath, "\", "\\") & "'")
	If IsObj($oColFiles) Then
		For $oObjectFile In $oColFiles
			Return StringUpper($oObjectFile.Drive)
		Next
	EndIf
	Return SetError(1, 1, 0)
EndFunc   ;==>_GetFilenameDrive

Func _GetFilenamePath($sFilePath)
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & "." & "\root\cimv2")
	Local $oColFiles = $oWMIService.ExecQuery("Select * From CIM_Datafile Where Name = '" & StringReplace($sFilePath, "\", "\\") & "'")
	If IsObj($oColFiles) Then
		For $oObjectFile In $oColFiles
			Return $oObjectFile.Path
		Next
	EndIf
	Return SetError(1, 1, 0)
EndFunc   ;==>_GetFilenamePath
Func templateFill()
	$totalarr = IniReadSectionNames($storepath)
	For $pug = 1 To $totalarr[0] Step 1
		If StringLeft($totalarr[$pug], 8) = "Template" Then
			GUICtrlSetData($Combo7, IniRead($storepath, $totalarr[$pug], "Template Name", "NA"))
		Else
			ContinueLoop
		EndIf
	Next
EndFunc   ;==>templateFill
Func importTemplate($templname)
	_GUICtrlListView_DeleteAllItems($ListView1)
	$totalarr2 = IniReadSectionNames($storepath)
	$thesection = ""
	For $pug2 = 1 To $totalarr2[0] Step 1
		If StringCompare(IniRead($storepath, $totalarr2[$pug2], "Template Name", "NA"), $templname) = 0 Then
			$thesection = $totalarr2[$pug2]
			ExitLoop
		Else
			ContinueLoop
		EndIf
	Next
	$imparray = IniReadSection($storepath, $thesection)
	_ArrayDelete($imparray, "0-1")
	For $bb = 0 To UBound($imparray) - 1 Step 1
		$imparray[$bb][1] = BinaryToString(decry($imparray[$bb][1]))
	Next
	_GUICtrlListView_AddArray($ListView1, $imparray)
EndFunc   ;==>importTemplate
Func _MLInputBox($title, $prompt, $promptag, $textedit = "", $timeOut = 0, $hWnd = 0)
	Global $Edit1
	Local $Label7, $Combo9, $Label8, $Button31, $hCancel
	Local $text = ""
	Local $error = 0
	Local $select = 0
	Local $edbool = False
	Local $userbool = False
	Local $passbool = False
	Local $phonebool = False
	Local $webbool = False
	Local $emailbool = False
	Local $adbool = False
	Local $refbool = False
	Local $compbool = False
	Local $sec, $comp, $ref, $ed, $edarr, $refarr, $comparr
	If $prompt <> Default Then
		$sec = IniReadSectionNames($storepath)
		$comp = _ArrayFindAll($sec, "Company", Default, Default, Default, 1)
		$ref = _ArrayFindAll($sec, "Reference", Default, Default, Default, 1)
		$ed = _ArrayFindAll($sec, "Education", Default, Default, Default, 1)
		$ad = _ArrayFindAll($sec, "Address", Default, Default, Default, 1)
		Local $edarr[UBound($ed)][2]
		Local $refarr[UBound($ref)][2]
		Local $comparr[UBound($comp)][2]
		Local $addarray[UBound($ad)][2]
		For $i = 0 To UBound($comp) - 1 Step 1
			$comparr[$i][0] = $sec[$comp[$i]]
			$comparr[$i][1] = BinaryToString(decry(IniRead($storepath, $sec[$comp[$i]], "Company name", "Not here")))
		Next
		For $i = 0 To UBound($ref) - 1 Step 1
			$refarr[$i][0] = $sec[$ref[$i]]
			$refarr[$i][1] = BinaryToString(decry(IniRead($storepath, $sec[$ref[$i]], "Name", "Not here")))
		Next
		For $i = 0 To UBound($ed) - 1 Step 1
			$edarr[$i][0] = $sec[$ed[$i]]
			$edarr[$i][1] = BinaryToString(decry(IniRead($storepath, $sec[$ed[$i]], "Name", "Not here")))
		Next
		For $i = 0 To UBound($ad) - 1 Step 1
			$addarray[$i][0] = $sec[$ad[$i]]
			$addarray[$i][1] = BinaryToString(decry(IniRead($storepath, $sec[$ad[$i]], "Name", "Not here")))
		Next
	EndIf
	Local $Formpro = GUICreate($title, 391, 267, 192, 124, 0x00C00000 + 0x00080000, 0, $hWnd)
	If @error Then
		$error = 3
	Else
		If $prompt <> Default Then
			$Label7 = GUICtrlCreateLabel($prompt, 1, 10, 390, 30, $SS_CENTER)
			GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
			$Combo9 = GUICtrlCreateCombo("", 71, 48, 249, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			If StringInStr($prompt, "company") > 0 Then
				$compbool = True
				For $i = 0 To UBound($comparr) - 1 Step 1
					GUICtrlSetData($Combo9, $comparr[$i][1])
				Next
			ElseIf StringInStr($prompt, "reference") > 0 Then
				$refbool = True
				For $i = 0 To UBound($refarr) - 1 Step 1
					GUICtrlSetData($Combo9, $refarr[$i][1])
				Next
			ElseIf StringInStr($prompt, "educational") > 0 Then
				$edbool = True
				For $i = 0 To UBound($edarr) - 1 Step 1
					GUICtrlSetData($Combo9, $edarr[$i][1])
				Next
			ElseIf StringInStr($prompt, "personal email address") > 0 Then
				$emailbool = True
				$emailcombo = IniReadSection($storepath, "Email")
				For $i = 1 To $emailcombo[0][0] Step 1
					GUICtrlSetData($Combo9, BinaryToString(decry($emailcombo[$i][1])))
				Next
			ElseIf StringInStr($prompt, "user name") > 0 Then
				$userbool = True
				$usercombo = IniReadSection($storepath, "User Names")
				For $i = 1 To $usercombo[0][0] Step 1
					GUICtrlSetData($Combo9, BinaryToString(decry($usercombo[$i][1])))
				Next
			ElseIf StringInStr($prompt, "password") > 0 Then
				$passbool = True
				$passcombo = IniReadSection($storepath, "Password")
				For $i = 1 To $passcombo[0][0] Step 1
					GUICtrlSetData($Combo9, BinaryToString(decry($passcombo[$i][1])))
				Next
			ElseIf StringInStr($prompt, "personal phone number") > 0 Then
				$phonebool = True
				$phonecombo = IniReadSection($storepath, "Phone number")
				For $i = 1 To $phonecombo[0][0] Step 1
					GUICtrlSetData($Combo9, BinaryToString(decry($phonecombo[$i][1])))
				Next
			ElseIf StringInStr($prompt, "personal address") > 0 Then
				$adbool = True
				For $i = 0 To UBound($addarray) - 1 Step 1
					GUICtrlSetData($Combo9, $addarray[$i][1])
				Next
			ElseIf StringInStr($prompt, "website") > 0 Then
				$webbool = True
				$webcombo = IniReadSection($storepath, "Websites")
				For $i = 1 To $webcombo[0][0] Step 1
					GUICtrlSetData($Combo9, BinaryToString(decry($webcombo[$i][1])))
				Next
			Else
				$error = 3
			EndIf
		Else
			GUICtrlSetState($Label7, $GUI_DISABLE)
			GUICtrlSetState($Label7, $GUI_HIDE)
			GUICtrlSetState($Combo9, $GUI_DISABLE)
			GUICtrlSetState($Combo9, $GUI_HIDE)
		EndIf


		$Label8 = GUICtrlCreateLabel($promptag, 1, 75, 390, 35, $SS_CENTER)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
		If $prompt <> Default Then
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
		EndIf

		$Edit1 = GUICtrlCreateEdit($textedit, 45, 112, 297, 113, BitOR($ES_AUTOVSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
		If $prompt <> Default Then
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
		EndIf

		$Button31 = GUICtrlCreateButton("Submit", 96, 230, 73, 25, $BS_NOTIFY)
		GUICtrlSetState(-1, $GUI_DISABLE)
		If $prompt <> Default Then
			GUICtrlSetState(-1, $GUI_HIDE)
		EndIf
		GUICtrlSetCursor(-1, 0)
		$hCancel = GUICtrlCreateButton("Cancel", 216, 230, 73, 25, $BS_NOTIFY)
		GUICtrlSetCursor(-1, 0)
		GUISetState(@SW_SHOW)
		$aRect = _GUICtrlEdit_GetRECT($Edit1)
		$aRect[0] += 10
		$aRect[1] += 10
		$aRect[2] -= 10
		$aRect[3] -= 10
		_GUICtrlEdit_SetRECT($Edit1, $aRect)
		GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
		Do
			If _GUICtrlEdit_GetTextLen($Edit1) = 0 And BitAND(GUICtrlGetState($Button31), 64) Then
				GUICtrlSetState($Button31, $GUI_DISABLE)
			EndIf
			If _GUICtrlEdit_GetTextLen($Edit1) > 0 And BitAND(GUICtrlGetState($Button31), 128) Then
				GUICtrlSetState($Button31, $GUI_ENABLE)
			EndIf

			$msg = GUIGetMsg(1)
			If $msg[1] = $Formpro Then
				Switch $msg[0]
					Case 0xFFFFFFFD, $hCancel             ; 0xFFFFFFFD = $GUI_EVENT_CLOSE
						$error = 1
						ExitLoop
					Case $Combo9
						If $prompt <> Default Then
							Local $ind
							$ind = _GUICtrlComboBox_GetCurSel($Combo9)
							If $compbool = True Then
								$bspl = StringSplit($comparr[$ind][0], " ")
								$select = Int($bspl[$bspl[0]])
								;$mstext = "There is already a value associated with the " & $category & " variable for the company entry you have selected.  Do you want to overwrite this value with a new one?"
							ElseIf $edbool = True Then
								$bspl = StringSplit($edarr[$ind][0], " ")
								$select = Int($bspl[$bspl[0]])
								;$mstext = "There is already a value associated with the " & $category & " variable for the education entry you have selected.  Do you want to overwrite this value with a new one?"
							ElseIf $refbool = True Then
								$bspl = StringSplit($refarr[$ind][0], " ")
								$select = Int($bspl[$bspl[0]])
								;$mstext = "There is already a value associated with the " & $category & " variable for the reference entry you have selected.  Do you want to overwrite this value with a new one?"
							ElseIf $emailbool = True Then
								$bspl = StringSplit($emailcombo[$ind][0], " ")
								$select = Int($bspl[$bspl[0]])
							ElseIf $userbool = True Then
								$bspl = StringSplit($usercombo[$ind][0], " ")
								$select = Int($bspl[$bspl[0]])
							ElseIf $passbool = True Then
								$bspl = StringSplit($passcombo[$ind][0], " ")
								$select = Int($bspl[$bspl[0]])
							ElseIf $phonebool = True Then
								$bspl = StringSplit($phonecombo[$ind][0], " ")
								$select = Int($bspl[$bspl[0]])
							ElseIf $webbool = True Then
								$webmat = IniReadSection($storepath, "Websites")
								For $tyu = 1 To $webmat[0][0] Step 1
									If BinaryToString(decry($webmat[$tyu][1])) = GUICtrlRead($Combo9) Then
										$bspl = StringSplit($webmat[$tyu][0], " ")
										$select = Int($bspl[$bspl[0]])
										ExitLoop
									Else
										ContinueLoop
									EndIf
								Next

							ElseIf $adbool = True Then
								$bspl = StringSplit($addarray[$ind][0], " ")
								$select = Int($bspl[$bspl[0]])
							Else
								$error = 3
							EndIf
							GUICtrlSetState($Label8, $GUI_ENABLE)
							GUICtrlSetState($Label8, $GUI_SHOW)
							GUICtrlSetState($Edit1, $GUI_ENABLE)
							GUICtrlSetState($Edit1, $GUI_SHOW)
							GUICtrlSetState($Button31, $GUI_SHOW)
						EndIf
					Case $Button31
						ExitLoop
				EndSwitch
			EndIf

		Until $error
		If Not $error Then
			$text = StringReplace(_GUICtrlEdit_GetText($Edit1), @CRLF, "\n")
		EndIf


		GUIDelete($Formpro)
	EndIf
	SetError($error, $select)
	$extend = $select
	If Not $error Then
		Return $text
	EndIf
EndFunc   ;==>_MLInputBox

Func SpellGUI($thetext)
	If $thetext = "" Then
		SetError(4)
	Else

		Local $returntext = $thetext
		Local $error2 = 0
		If StringIsAlNum(StringRight($returntext, 1)) Then
			$returntext = $returntext & " "
		EndIf

		$oRange.Delete
		$oRange.InsertAfter($returntext)
		_SetLanguage()
		$oSpellCollection = $oRange.SpellingErrors
		If $oSpellCollection.Count > 0 Then
			Local $Form7 = GUICreate("Spell Check", 450, 337, 254, 124, 0x00C00000 + 0x00080000, 0, $Form1_1)
			If @error Then
				$error2 = 3
			Else

				Local $Label9 = GUICtrlCreateLabel("Spelling errors", 160, 10, 129, 29)
				GUICtrlSetFont(-1, 16, 400, 0, "MS Sans Serif")
				Local $Label10 = GUICtrlCreateLabel("Misspelled word", 28, 38, 145, 35)
				GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
				Local $Label11 = GUICtrlCreateLabel("Correction", 305, 38, 145, 35)
				GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
				Local $List6 = GUICtrlCreateList("", 16, 70, 161, 185, BitOR($LBS_NOTIFY, $LBS_EXTENDEDSEL, $LBS_HASSTRINGS, $WS_VSCROLL))
				Local $List7 = GUICtrlCreateList("", 272, 70, 161, 185, BitOR($LBS_NOTIFY, $LBS_EXTENDEDSEL, $LBS_HASSTRINGS, $WS_VSCROLL))
				Local $Button32 = GUICtrlCreateButton("Submit", 24, 280, 113, 33, $BS_NOTIFY)
				GUICtrlSetCursor(-1, 0)
				Local $Button33 = GUICtrlCreateButton("Correct Spelling", 168, 280, 105, 33, $BS_NOTIFY)
				GUICtrlSetState(-1, $GUI_DISABLE)
				GUICtrlSetCursor(-1, 0)
				Local $Button34 = GUICtrlCreateButton("Cancel", 304, 280, 105, 33, $BS_NOTIFY)
				GUICtrlSetCursor(-1, 0)
				GUISetState(@SW_SHOW, $Form7)
				If @error Then
					$error2 = 3
				EndIf

				_GUICtrlListBox_ResetContent($List6)
				_GUICtrlListBox_ResetContent($List7)

				For $pp = 1 To $oSpellCollection.Count
					_GUICtrlListBox_AddString($List6, $oSpellCollection.Item($pp).Text)
				Next
				Do
					$newmsg = GUIGetMsg(1)
					If $newmsg[1] = $Form7 Then
						Switch $newmsg[0]
							Case $GUI_EVENT_CLOSE, $Button34
								$error2 = 3
								ExitLoop
							Case $List6
								_GUICtrlListBox_ResetContent($List7)
								GUICtrlSetState($Button33, $GUI_DISABLE)
								$iWord = _GUICtrlListBox_GetCurSel($List6) + 1
								$ssWord = $oSpellCollection.Item($iWord).Text
								$oAlternateWords = $oWordApp.GetSpellingSuggestions($ssWord)
								If $oAlternateWords.Count > 0 Then
									For $vv = 1 To $oAlternateWords.Count
										_GUICtrlListBox_AddString($List7, $oAlternateWords.Item($vv).Name)
									Next
								Else
									_GUICtrlListBox_AddString($List7, "No suggestions.")
								EndIf
							Case $List7
								If _GUICtrlListBox_GetSelCount($List7) = 1 Then
									GUICtrlSetState($Button33, $GUI_ENABLE)
								Else
									GUICtrlSetState($Button33, $GUI_DISABLE)
								EndIf
							Case $Button32
								ExitLoop
							Case $Button33
								$iWord = _GUICtrlListBox_GetCurSel($List6) + 1
								$iNewWord = _GUICtrlListBox_GetCurSel($List7) + 1
								If $iWord == $LB_ERR Or $iNewWord == $LB_ERR Then
									;MsgBox(48, "Error", "You must first select a word to replace, then a replacement word.")
									;Return
								Else
									;$returntext = StringReplace($returntext, $iWord, $iNewWord, 1)
									$oSpellCollection.Item($iWord).Text = $oAlternateWords.Item($iNewWord).Name
									$oSpellCollection = $oRange.SpellingErrors
									If $oSpellCollection.Count > 0 Then
										_GUICtrlListBox_ResetContent($List6)
										_GUICtrlListBox_ResetContent($List7)
										For $ii = 1 To $oSpellCollection.Count
											_GUICtrlListBox_AddString($List6, $oSpellCollection.Item($ii).Text)
										Next
									Else
										ExitLoop
									EndIf

								EndIf
						EndSwitch
					EndIf
				Until $error2
				GUIDelete($Form7)
			EndIf
		EndIf
		If Not $error2 Then
			$returntext = StringReplace($oRange.Text, @CR, @CRLF)
			$returntext = StringReplace(StringStripWS($returntext, 3), @CRLF, "\n")
		EndIf
		SetError($error2)
		If Not $error2 Then
			Return $returntext
		EndIf
	EndIf


EndFunc   ;==>SpellGUI

Func WM_COMMAND($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg
	Local $hWndFrom, $iIDFrom, $iCode, $hWndEdit
	If Not IsHWnd($Edit1) Then $hWndEdit = GUICtrlGetHandle($Edit1)
	$hWndFrom = $lParam
	$iIDFrom = _WinAPI_LoWord($wParam)
	$iCode = _WinAPI_HiWord($wParam)
	Switch $hWndFrom
		Case $Edit1, $hWndEdit
			Switch $iCode
				Case $EN_SETFOCUS
					; Insert your code here
					If _GUICtrlEdit_GetText($Edit1) = "Street address and suite/apartment number" & @CRLF & "City, State Zip" Then
						_GUICtrlEdit_SetText($Edit1, "")
					EndIf


			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND
Func _WordExit()
	_Word_Quit($oWordApp)
EndFunc   ;==>_WordExit
Func _Getiniinfo($inipath, $inisection)
	$list = IniReadSection($inipath, $inisection)
	For $rooba = 1 To $list[0][0] Step 1
		$list[$rooba][1] = BinaryToString(decry($list[$rooba][1]))
	Next
	Return $list
EndFunc   ;==>_Getiniinfo



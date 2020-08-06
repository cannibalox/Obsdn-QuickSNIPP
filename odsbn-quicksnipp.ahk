;==============================================================================
;======= AiO ahk tools for Obsidian by _Ph / www.hpx1.com 
;======= WebSNIPP : create Block references in Obsidian 
;======= AutoSNIPP : create Block references in Obsidian 
;======= QuickSNIPP : write stuff in the scratchpad 
;======= www.github.com/cannibalox
;======= v20200802
;==============================================================================
;======= !!!!!!!  use AutoHotkey Unicode !!!!!!! ==============================
;======= search for `CONFIG` to define your own settings / shortcuts ==========

#NoEnv 							; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force			; Skips dialog box and replaces old instance automatically.
#Persistent     			 	; Keeps a script permanently running (until user closes it or ExitApp Command).
SendMode Input              	; Recommended for new scripts due to its superior speed and reliability.

;======= CONFIG : LOCATION OF INCLUDES ========================================
#Include C:\_ppApps\_tools\autohotkey_L\_includes\WinClipAPI.ahk 		; [Class] WinClip by Deo http://www.apathysoftworks.com/ahk/index.html
#Include C:\_ppApps\_tools\autohotkey_L\_includes\WinClip.ahk
#Include C:\_ppApps\_tools\autohotkey_L\_includes\createFormData.ahk 	; by tmplinshi mod by SKAN https://www.autohotkey.com/boards/viewtopic.php?p=85687#p85687
Menu, Tray, Icon, hpx1_64.png

;==============================================================================
;======= CONFIG : DEFINE YOUR SAVE FOLDER BELOW ===============================
; First, create a folder under your obsidian vault to store the snippets. 
; Then point to that folder. The script will create subfolders based on the 
; current year & month : /snippets/YYYYMM/

Snipdir := "P:\phi\obsidian\obsdn-vault\snippets" ; !!! change this to your own folder !!!

; =========================== [ GUI ] =========================================

Gui, Font, s11 cfafafa
Gui, Add, Edit, vMyEdit w340 r6 y23, WebSNIPP           CTRL+F9 : save webpage`n   CTRL+ALT+X / C : web to .md / clipboard`nAutoSNIPP`n    CTRL+SHIFT+X / C : extract/clone block to file`nQuickSNIPP`n    CAPSLOCK x2 : show scratchpad

Gui +AlwaysOnTop +Resize MinSize355x52 
Gui, -Caption 					; hide windows title
Gui, Show, x0 y814, QuickSNIPP 	; show the main window at x0 y812 SW corner of the screen

; BUTTONS
Gui Color, cccccc, 323947
Gui, Font, c0022aa s6, Segoe 
Gui, Add, Button, xm w1 h1 x1 y1
Gui, Add, Button, xm w20 h20 x+1 y1 gMainMenu, >
Gui, Add, Button, xm w50 h20 x+1 y1 gSaveSPad, SaveNote
Gui, Add, Button, xm w50 h20 x+1 y1 vclear gCLEAR, CLEAR 

; DRAG
Gui, Add, Text, xm w100 h20 x+1 y5 center gDRAG_MOVE, DragWindow

; ALWAYS ON TOP
Gui, Font, c000000 s6, Segoe
Gui, add, text, x+5 y5, OnTop
Gui, Add, Radio, x+5 y5 Checked Group v_Rad1 gALWAYS_ON_TOP, Y
Gui, Add, Radio, x+ y5 v_Rad2 gALWAYS_ON_TOP, N

; HIDE GUI BUTTON
Gui, Add, button, x+16 h20 y1 gGuiClose,X 

; MENUS
Menu, SubMenu, Add, Calculator, Calculator
Menu, MMenu, Add, Calculator,
Menu, MMenu, Add, HelpAbout
Menu, MMenu, Add, Exit, FileExit

; Tooltips
OnMessage(0x200, "WM_MOUSEMOVE") ; tooltips on hover buttons
	SaveNote_TT := "save current scratchpad in \snippets\xx_YYYYMMDD..."
	CLEAR_TT := "Clear the scratchpad"
	DragWindow_TT := "handle to move the window"
	X_TT :="Hide the scratchpad`nCAPSLOCKx2 to show"
return


;============================================================================
;================== CONFIG : DEFINE SHORTCUTS================================
;============================================================================

^+c::		 	 ; CTRL+SHIFT+C to create clone file+link (AutoSnipp)
	Clipboard :=""	 ; Clear the clipboard
	send ^c		 ; COPY selection
	ClipWait	 ; wait for the clipboard to contain data.
	gosub AutoSnipp
return

^+x::			 ; CTRL+SHIFT+X to create instance file+link (AutoSnipp)
	Clipboard :=""	 ; Clear the clipboard
	send ^x		 ; CUT selection
	ClipWait	 ; wait for the clipboard to contain data.
	gosub AutoSnipp
return

^!c::			 ; CTRL+ALT+C to copy html to md clipboard (WebSnipp) 
	Clipboard :=""	 ; Clear the clipboard
	send ^c		 ; copy selection
	ClipWait	 ; wait for the clipboard to contain data.
	gosub WebSnipp
return

^!x::			; CTRL ALT X to save html as a md file (WebSave)
	Clipboard :=""	 ; Clear the clipboard
	send ^c		 ; copy selection
	ClipWait	 ; wait for the clipboard to contain data.
	gosub WebSave
return

^F9::			; CTRL F9: convert URL to md file 
	Clipboard :=""
	send !d		 ; send ALT D select urlbar
	send ^c		 ; copy selection
	ClipWait	 ; wait for the clipboard to contain data.
	gosub UrlPageSave
return

$CapsLock::		 ; CAPSLOCK x 2 - display scratchpad (QuickSnipp)
  If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500)
    Gui, Show,, QuickSNIPP  
return

^!p::Pause   	 ; Pause script with Ctrl+Alt+P

;============================================================================
; ============ functions ====================================================

; strip header info
GetHTML(in)	{
	 in:=RegExReplace(in,"iUs)^.*<htm","<htm") ; strip all before <htm
	 in:=StrReplace(in,"<!--StartFragment-->")
	 in:=StrReplace(in,"<!--EndFragment-->")
	 return in
}

; retrieve the source page for the web clipper
GetSource(in) {
	 in:=RegExReplace(in,"iUs)^.*SourceURL:") 
	 in:=RegExReplace(in,"iUs)<html>.*</html>")
	 return in
}

;tooltips
WM_MOUSEMOVE() {	
    static CurrControl, PrevControl, _TT  ; _TT is kept blank for use by the ToolTip command below.
    CurrControl := A_GuiControl
    If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
    {
        ToolTip  ; Turn off any previous tooltip.
        SetTimer, DisplayToolTip, 200
        PrevControl := CurrControl
    }
    return

    DisplayToolTip:
	try{
		SetTimer, DisplayToolTip, Off
		ToolTip % %CurrControl%_TT  
		SetTimer, RemoveToolTip, 3000
	}
	return

    RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
    return
}

; retrieve windows title 
GetTitle() { 
	WinGetActiveTitle, Title	
	; windows title beautification - remove the ending part with the program name e.g. - Firefox
	StringGetPos,pos,Title,%A_space%-,R
	if (pos != -1)
		Title := SubStr(Title,1,pos)
	return Title
}

; save md files in the vault\snipdir
SaveSnipp(Content,Snipdir,Title) {
	; ===== CONFIG : create folder vault\snippets\yyyyMM ======
	FormatTime, thismonth,, yyyyMM
	FileID = xx_%A_Now%-%A_Msec%_%Title%   ; CONFIG naming convention
	IfNotExist, %Snipdir%\%thismonth%\
		FileCreateDir, %Snipdir%\%thismonth%\

	; ===== replace illegal chars ===========================
	BadChars := "+=!@#$%^&*?'()|""/\,><};:{"	; list invalid characters
	;loop trough all the characters that need to be replaced in filename
	Loop, Parse, BadChars
		{
			;if a bad character is found, remove it
			StringReplace, FileID, FileID, %A_LoopField%,, All
		}

	; ====== create a new .md file with clipboard contents =======
    FileEncoding UTF-8-RAW
	FileAppend, %Content%, %Snipdir%\%thismonth%\%FileID%.md	
	ClipWait
	
	; ====== create the transclusion link, put it in the clipboard =======
	Clipboard = ![[%FileID%]]	
	return FileID
}


;====================== UriEncode/UriDecode functions by imGuest ====================================	
; ======== https://autohotkey.com/board/topic/75390-ahk-l-unicode-uri-encode-url-encode-function/

; modified from jackieku's code (http://www.autohotkey.com/forum/post-310959.html#310959)
UriEncode(Uri, Enc = "UTF-8")
{
	StrPutVar(Uri, Var, Enc)
	f := A_FormatInteger
	SetFormat, IntegerFast, H
	Loop
	{
		Code := NumGet(Var, A_Index - 1, "UChar")
		If (!Code)
			Break
		If (Code >= 0x30 && Code <= 0x39 ; 0-9
			|| Code >= 0x41 && Code <= 0x5A ; A-Z
			|| Code >= 0x61 && Code <= 0x7A) ; a-z
			Res .= Chr(Code)
		Else
			Res .= "%" . SubStr(Code + 0x100, -1)
	}
	SetFormat, IntegerFast, %f%
	Return, Res
}

UriDecode(Uri, Enc = "UTF-8")
{
	Pos := 1
	Loop
	{
		Pos := RegExMatch(Uri, "i)(?:%[\da-f]{2})+", Code, Pos++)
		If (Pos = 0)
			Break
		VarSetCapacity(Var, StrLen(Code) // 3, 0)
		StringTrimLeft, Code, Code, 1
		Loop, Parse, Code, `%
			NumPut("0x" . A_LoopField, Var, A_Index - 1, "UChar")
		StringReplace, Uri, Uri, `%%Code%, % StrGet(&Var, Enc), All
	}
	Return, Uri
}

StrPutVar(Str, ByRef Var, Enc = "")
{
	Len := StrPut(Str, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1)
	VarSetCapacity(Var, Len, 0)
	Return, StrPut(Str, &Var, Enc)
}


;================= GOSUBS ============================================================
;=====================================================================================	

;=====================================================================================	
;= WEBSNIPP a webclipper relying on WinClip & FuckyeahMArkdown.com ===================
;=====================================================================================	

WebSnipp:
	
	;================= winclip clipboard==========================================
	ClipData :=GetHTML(WinClip.GetHTML())		;clipboard as html, strip header
	ClipSource :=GetSource(WinClip.GetHTML())	;retrieves source page of selection
    StringTrimRight, ClipSource, ClipSource, 2  ;remove the linebreak
	Clipboard :=""								
	WinClip.Clear()
	WinClip.SetHTML(ClipData)					;push html to clipboard
	Sleep 200									;wait for clipboard to avoid errors
	;MsgBox % ClipData							for debug - display clipboard						
	;MsgBox % ClipSource						for debug - display source

	;==========create formdata for POST using CreateFrmData ahk ==============
    CData:= {"html": ClipData} 						; array
    CreateFormData(postData, hdr_ContentType, CData)  

	;==============POST data http://fuckyeahmarkdown.com to convert the HTML into Markdown =======================
    try{ 															; try - in case of errors or timeouts
        whr := ComObjCreate("WinHttp.WinHttpRequest.5.1") 			; create WinHttp object
        whr.Open("POST", "http://fuckyeahmarkdown.com/go/", true) 	; open a post event to markdownifier API
        whr.SetRequestHeader("Content-Type", hdr_ContentType) 		; set content header
        whr.SetRequestHeader("Referer", "http://fuckyeahmarkdown.com/go/") ; set content header
        whr.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko") ; set content header
        whr.Send(postData) 											; send request with the html data to be converted
        whr.WaitForResponse()
        raw:= whr.ResponseText										; store the returned data in raw
        
    } catch e {
        MsgBox 64, %A_ScriptName% - Row %A_LineNumber%, % e.message	; if error return error message from server
    }

	;============== fill clipboard with source + content =========================
    Clipboard := "<small>source: " . ClipSource . "</small>`r`r" . raw . "----"
    ;MsgBox , 64,, Snipped and ready to paste, 2 
	
	;============== Display HUD confirmation text with auto timout ========
	CustomColor = 121212 			; bg color 
	Gui, 2:Color, %CustomColor%		; create a new GUI
	Gui, 2:Font, S18, Arial Black	; set font properties
	Gui, 2:Add, Text, , Done !	; text shadows	
	Gui, 2:Add, Text, xp-1 yp-1 c44FF6F, Done !	; text color
	Gui 2:+LastFound +AlwaysOnTop +ToolWindow -Caption	; GUI settings
	WinSet, Transparent, 200 		; transparent HUD 200 
	Gui, 2:Show, x90 y500 NoActivate ; draw the text
	SetTimer, CloseGui , 1000		; set timeout
return

CloseGui:							; timer for HUD
	SetTimer, , Off  				; the timer turns itself off 
	Gui, 2:Cancel					; close the HUD
return

;=======WebSNIPP : copy selected HTML to a markdown file in the vault ========

WebSave:

	gosub WebSNIPP				; copy html and convert to md
	Title := GetTitle()			; get title of window/source
	SaveSnipp(Clipboard,Snipdir,Title)	; save file to vault/snippets and create link

return

;======= convert current web page to a markdown file in the vault and get transclusion link ========

UrlPageSave:

	Clipboard := UriEncode(Clipboard)
	goGET := "http://fuckyeahmarkdown.com/go/?u=" . Clipboard

	;========= GET request to http://fuckyeahmarkdown.com to convert the HTML into Markdown =======================
    try{ 															; try - in case of errors or timeouts
        whr := ComObjCreate("WinHttp.WinHttpRequest.5.1") 			; create WinHttp object
        whr.Open("GET", goGET, true) 	; make GET request to markdownifier API
        whr.Send() 										
        whr.WaitForResponse()
        raw:= whr.ResponseText										; store the returned data in raw   
    } catch e {
        MsgBox 64, %A_ScriptName% - Row %A_LineNumber%, % e.message	; if error return error message from server
    }

	;============== fill clipboard with source + content =========================
    Clipboard := raw
	Title := GetTitle()	
	FileID := SaveSnipp(Clipboard,Snipdir,Title)					; save the snippet as a file and create a link
	MsgBox saved in \snippets\%thismonth%\%FileID%.md`nLink %Clipboard% is ready to be pasted  
return

;=============================================================================
;=======AutoSNIPP : create Block reference in Obsidian by extracting  ========
;=======			text into a new file and automatically get the    ========
;=======	        the formatted link ready for transclusion.        ========
;=============================================================================

AutoSnipp:
  
    ClipData := WinClip.GetText()               	; get text
	Sleep 200	
    Title := GetTitle()								; retrieves Active Window Title
	FileID := SaveSnipp(Clipboard,Snipdir,Title)	; save the snippet as a file and create a link
	MsgBox saved selection in \snippets\%thismonth%\%FileID%.md`nTransclusion link ready to be pasted ; remove this line for faster operation

return


;=========================GUI controls functions===============================

HelpAbout:
	Gui, About:+owner1 -Caption ; Make the main window (Gui #1) the owner of the "about box".
	Gui +Disabled  ; Disable main window.
	Gui, About:Add, Text,, Obsdn-QuickSnipp v20200802`nwww.github.com/cannibalox`nwww.hpx1.com
	Gui, About:Add, Button, Default gAboutButtonOK, Close
	Gui, About:Show
return

AboutButtonOK:  ; This section is used by the "about box" above.
	Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
	Gui Destroy  ; Destroy the about box.
return

SaveSPad:
	GuiControlGet, MyEdit  ; Retrieve the contents of the Edit control.
	Title := "ScratchPad"
	FileID := SaveSnipp(MyEdit,Snipdir,Title)	; call save function
	MsgBox saved selection in \snippets\%thismonth%\%FileID%.md`nTransclusion link ready to be pasted
return

FileExit:     ; User chose "Exit" from the File menu.
	ExitApp

DRAG_MOVE:
  PostMessage, 0xA1, 2,,, A
Return

CLEAR:
  SendInput, {Tab 3}
  Sleep, 50
  SendInput, ^a{BackSpace}
Return

ALWAYS_ON_TOP:
	Gui, Submit, NoHide
	If(_Rad1==1)
    Gui, +AlwaysOnTop
	else If (_Rad2==1)
    Gui, -AlwaysOnTop
Return

GuiClose:
    Gui Hide
Return

GuiEscape:
	Gui Hide
Return
	
GuiSize: 
	if A_EventInfo = 1  ; The window has been minimized.  No action needed.
		return
	; Otherwise, the window has been resized or maximized. Resize the ListView to match.
	GuiControl, Move, MyEdit, % "W" . (A_GuiWidth - 20) . " H" . (A_GuiHeight - 30)
	GuiControl, Move, Button1, % "y" . (A_GuiHeight - 45)
Return

MainMenu:
	Menu, MMenu, Show
return

Calculator:
	run calc.exe 
return


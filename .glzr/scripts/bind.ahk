
#SingleInstance Force
;#MaxHotkeysPerInterval 100, 1
#UseHook  
;SetKeyDelay, -1  


; Detects whether you are currently in the task overview
#IfWinActive ahk_class XamlExplorerHostIslandWindow ahk_exe explorer.exe
RButton::
  Send {MButton}
return

!q::
  Send {Delete}
return

!Left::
  Send {Left}
return

!Right::
  Send {Right}
return

!Up::
  Send {Up}
return

!Down::
  Send {Down}
return

!Tab::
  Send {Enter}
return

MButton::
  Send {Blind}{LButton down}{LButton up}
  Run, glazewm command set-fullscreen,,Hide
return

#IfWinActive  ; non overview bind

MButton::
  Run, glazewm command toggle-fullscreen,,Hide
return


; disable win key to open menu,~表示完全匹配单个按键，不然会连组合按键也匹配
~LWin::  
    Send {Blind}{vkE8} 
return

!Tab::  
    Send {LWin down}{Tab down}{LWin up}{Tab up}
return

;~LWin Up::  
;  Send {Blind}{vkE8 up}
;return

^!a::
    Send {PrintScreen}
return


#WheelUp::
  Run, glazewm command focus --prev-active-workspace,,Hide
return

#WheelDown::
  Run, glazewm command focus --next-active-workspace,,Hide
return


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
  ; Run, glazewm command toggle-fullscreen,,Hide
  Send {Blind}!{a}
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
  ; Run, glazewm command focus --prev-active-workspace,,Hide
    Send {Blind}^{F12}
return

#WheelDown::
  ; Run, glazewm command focus --next-active-workspace,,Hide
    Send {Blind}^{F11}
return


!,::SendInput, {Volume_Down}	;Win+下降低音量
!.::SendInput, {Volume_Up}		;Win+上升高音量
^,::Brightness("-2") ; Reduces brightness by 1%
^.::Brightness("+2") ; Increases brightness by 1% 

Brightness(Offset) {
    static wmi := ComObjGet("winmgmts:\\.\root\WMI")
        , last := wmi.ExecQuery("SELECT * FROM WmiMonitorBrightness").ItemIndex(0).CurrentBrightness
    level := Min(100, Max(1, last + Offset))
    if (level != last) {
        last := level
        wmi.ExecQuery("SELECT * FROM WmiMonitorBrightnessMethods").ItemIndex(0).WmiSetBrightness(0, level)
    }
}

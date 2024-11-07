#SingleInstance Force



;要捕获的东西
CoordMode, Mouse

#Persistent
;设置指针移动检测灵敏度
SetTimer, WatchCursor, 0
return

WatchCursor:
GetKeyState, state, LButton 
MouseGetPos, xpos, ypos
;debug时可以看坐标
; CoordMode, Mouse ,Screen
;ToolTip,x:%xpos% y:%ypos% state:%state% flag:%flag% sin:%sin%
if(state = "U" ){
    if(ypos > 10 and xpos > 10){
		flag = 1
    }else if(flag = 1){
		if(ypos <= 10 and xpos <= 10){
			flag = 0
			Send #{Tab}
			; MouseMove, xpos, ypos
		}
    }

}
return
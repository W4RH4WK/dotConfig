#NoTrayIcon

;SetKeyDelay, 200

; Ignore stupid Windows stuff
#q::return
#w::return
#s::return
#f::return
#h::return
#c::return
#m::return
#^!+w::return
#^!+t::return
#^!+y::return
#^!+o::return
#^!+p::return
#^!+d::return
#^!+l::return
#^!+x::return
#^!+n::return
#^!+Space::return

; Hyper -> Win
#^!+1::send #1
#^!+2::send #2
#^!+3::send #3
#^!+4::send #4
#^!+5::send #5
#^!+6::send #6
#^!+e::send #e
#^!+r::send #r

; Emojis
#j::Send 👍
#k::Send 🙄
;#Down::Send 🤞
;#Right::Send 

; Alternative Media keys
;#PgDn::Send {Media_Next}
;#PgUp::Send {Media_Prev}
;#Home::Send {Media_Play_Pause}

; Show / Hide Titlebar
#NumpadSub::
	Winset, Style, ^0xC00000, A
	;Winset, Style, ^0x40000, A
	;WinMove, A,, 50, 50, 1000, 1000
	;ControlMove , 50, 50, 1000, 1000, A
	return

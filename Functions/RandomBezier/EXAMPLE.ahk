; 30/May/2013 03:00h BRT

#Include RandomBezier.ahk

F5:: ToolTip, % "Points: " RandomBezier( 0, 0, 400, 400, "T500 RO RD OT0 OB0 OL0 OR0 P4-20" )
F6:: ToolTip, % "Points: " RandomBezier( 0, 0, 200, 200, "T1000 RO RD")
F7:: ToolTip, % "Points: " RandomBezier( 0, 0, 150, 150, "T1500 RO RD OT150 OB150 OL150 OR150 P6-4" )
F8:: ToolTip, % "Points: " RandomBezier( 0, 0, 200, 0, "T1200 RO RD OT100 OB-100 OL0 OR0 P4-3" )

F9:: ToolTip, % "Points: " RandomBezier( 0, 0, 400, 300, "T1000 RO P5" )
F10:: ToolTip, % "Points: " RandomBezier( 400, 300, 0, 0, "T1000 RD" )

F12::RELOAD
ESC::EXITAPP
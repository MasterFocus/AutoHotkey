; 04/October/2012 02:00h BRT

#Include RandomBezier.ahk

F5:: ToolTip, % "Points: " RandomBezier( 0, 0, 400, 400, "T500 REL OT0 OB0 OL0 OR0 P4-20" )
F6:: ToolTip, % "Points: " RandomBezier( 0, 0, 200, 200, "T1000 REL")
F7:: ToolTip, % "Points: " RandomBezier( 0, 0, 150, 150, "T1500 REL OT150 OB150 OL150 OR150 P6-4" )
F8:: ToolTip, % "Points: " RandomBezier( 0, 0, 200, 0, "T1200 REL OT100 OB-100 OL0 OR0 P4-3" )

F12::RELOAD
ESC::EXITAPP
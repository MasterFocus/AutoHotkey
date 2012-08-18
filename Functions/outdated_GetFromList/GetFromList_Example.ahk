#Include GetFromList.ahk

myList =
(
aa
bbbbb
dddd
egggyy
eeee
tadd
egg
mad
canibal
ddd
rteter
egglo
hhhhhhr
rtrrtrtr
)

MsgBox myList:`n`n%myList%

txt := "GetFromList(   4   ,  myList  )`n-> " GetFromList(4,myList) "`n`n"
txt .= "GetFromList(  ""e""  ,  myList  )`n-> " GetFromList("e",myList) "`n`n"
txt .= "GetFromList(   6   ,  myList  )`n-> " GetFromList(6,myList) "`n`n"
txt .= "GetFromList(  ""d""  ,  myList  )`n-> " GetFromList("d",myList) "`n`n"
txt .= "GetFromList(  ""e""  ,  myList  ,  0  ,  0  ,  ""s""  )`n-> " GetFromList("e",myList,0,0,"s") "`n`n"
txt .= "GetFromList(  ""d""  ,  myList  ,  0  ,  0  ,  ""m""  )`n-> " GetFromList("d",myList,0,0,"m") "`n`n"
txt .= "GetFromList(  ""l""  ,  myList  ,  0  ,  0  ,  ""e""  )`n-> " GetFromList("l",myList,0,0,"e")
MsgBox % txt
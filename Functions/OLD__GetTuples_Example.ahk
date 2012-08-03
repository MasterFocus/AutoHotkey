#Include GetTuples.ahk

MsgBox % "** EXAMPLES **"

Text := "GetTuples(   ""ABCDE""   ):`n`n"
MsgBox % Text GetTuples("ABCDE")

Text := "GetTuples(   ""A|B|C|D|E""   ,   3   ,   ""|""   ,   "",""   ):`n`n"
MsgBox % Text GetTuples("A|B|C|D|E",3,"|",",")

Text := "GetTuples(   ""ABCDE|""   ,   2   ,   """"   ,   ""||""   ):`n`n"
MsgBox % Text GetTuples("ABCDE|",2,"","||")

Text := "GetTuples(   ""A,1,B,2,C""   ,   2   ,   "",""   ):`n`n"
MsgBox % Text GetTuples("A,1,B,2,C",2,",")

Text := "GetTuples(   ""5,3,4,1,2""   ,   2   ,   "",""   ,   ""-->``n""   ):`n`n"
MsgBox % Text GetTuples("5,3,4,1,2",2,",","-->`n")

Text := "GetTuples(   ""5,3,4,1,2""   ,   2   ,   "",""   ,   ""``n-->""   ):`n`n"
MsgBox % Text GetTuples("5,3,4,1,2",2,",","`n-->")

Text := "GetTuples(   ""EDCBA""   ,   2   ,   """"   ,   ""``n******``n""   ):`n`n"
MsgBox % Text GetTuples("EDCBA",2,"","`n******`n")

Text := "GetTuples(   ""ABCDEFGHIJKLMNOPQRSTUVWXYZ§=-+!@#$%&""   ,   2   ,   """"   ,   "",""   ):`n`n"
MsgBox % Text GetTuples("ABCDEFGHIJKLMNOPQRSTUVWXYZ§=-+!@#$%&",2,"",",")

Text := "GetTuples(   ""ABCDEFGHIJ""   ,   2   ,   """"   ,   "",""   ):`n`n"
MsgBox % Text GetTuples("ABCDEFGHIJ",2,"",",")

Text := "GetTuples(   ""ABCDEFGHIJK""   ,   3   ,   """"   ,   "",""   ):`n`n"
MsgBox % Text GetTuples("ABCDEFGHIJK",3,"",",")

Text := "GetTuples(   ""ABCDEFGHIJK""   ,   3   ,   """"   ,   "",""   ,   470   ):`n`n"
MsgBox % Text GetTuples("ABCDEFGHIJK",3,"",",",470)

Text := "GetTuples(   ""ABCDEFGHIJK""   ,   3   ,   """"   ,   "",""   ,   50   ,   7   ):`n`n"
MsgBox % Text GetTuples("ABCDEFGHIJK",3,"",",",50,7)

MsgBox % "** End of EXAMPLES **"
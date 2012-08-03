#Include RandomVar.ahk

MsgBox, All examples will use MinLength 1, MaxLength 10.

var_Types := "alnum,xdigit,!number,upper,!lower,"
var_Types .= "!@lower,@number,@alnum,!@alnum,"
var_Types .= "#alnum,!#number,!,@,#,!none,@none,#none"

Loop, Parse, var_Types, `,
{
  var_result := ""
  Loop, 10
    var_result .= "`n" RandomVar(1,10,A_LoopField)
  MsgBox % "10 results for type '" A_LoopField "':`n" var_result
}
REM  *****  BASIC  *****

Sub Main

End Sub

Sub notifyFilePathChanged
    On Error Goto ErrorHandler
	Dim oSvc as object
	oSvc = createUnoService("com.sun.star.system.SystemShellExecute")
	thisDoc = ThisComponent
	If thisDoc.hasLocation then
		docPath = ConvertFromURL(thisDoc.Url)
     	Rem Notify new file path
		oSvc.execute("/code/open365-services/src/bin/notifyFilePathChanged.sh", docPath, 0)
	EndIf

  ErrorHandler:
      Resume Next ' Continues execution at the command following the error command

End Sub

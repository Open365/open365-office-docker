REM  *****  BASIC  *****

Sub Save

If NOT GlobalScope.BasicLibraries.isLibraryLoaded( "Tools" ) Then
   GlobalScope.BasicLibraries.loadLibrary( "Tools" )
End if
 
 
oDoc = ThisComponent
qqUrl = oDoc.getURL
 
' Check if document has been saved, if it has a filename. If not, initate normal Save As
pos = InStr(qqUrl, "untitled-document")
If pos <> 0 Then
        rem ----------------------------------------------------------------------
        rem define variables
        dim document   as object
        dim dispatcher as object
        rem ----------------------------------------------------------------------
        rem get access to the document
        document   = ThisComponent.CurrentController.Frame
        dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
       
        rem ----------------------------------------------------------------------
        dispatcher.executeDispatch(document, ".uno:SaveAs", "", 0, Array())    
End if
 
'Create variable with initial (current) filename and path
'FileN=GetFileNameWithoutExtension(oDoc.url)
'FileNN=FileN+".odt"
'SaveURL = ConvertToURL(FileNN)
 
'path to save backups to
'sMyPath = "D:\My Dropbox\Backup\"
'sTime = Format( Now(), "--yyyy-mm-dd+HHMM" )
'sFileName = GetFileNameWithoutExtension(oDoc.url,"/")+sTime+".odt"
'sURL = ConvertToURL( sMyPath & sFileName )
 
'Save to backup location
'ThisComponent.storeAsURL( sURL, Array() )
 
'Save to initial location, so the opened document remains the <<original>>, not the backup
'ThisComponent.storeAsURL( SaveURL, Array() )
End Sub

' unzip a zip file

Sub Usage()
    WScript.Echo "Usage: cscript unzip.vbs \path\to\file.zip [destinationfolder]"
    WScript.Echo "Example: cscript unzip.vbs ..\src\foo.zip ..\dest"
    WScript.Echo "NOTE: The .zip file must have a .zip extension, so if"
    WScript.Echo "it does not, a temporary copy will be made with a .zip extension"
    WScript.Echo "If the destinationfolder does not exist, it will be created"
    WScript.Echo "Use '.' for the current directory"
    WScript.Echo "If the destinationfolder is not specified, '.' will be used"
End Sub

' see if args are correct
Set objArgs = WScript.Arguments
If objArgs.Count < 1 then
   Usage
   WScript.Quit(1)
End If

' get our FSO object
Set objFSO = CreateObject("Scripting.FileSystemObject")
' src zip file is arg 0
SRC = objFSO.GetAbsolutePathName(objArgs(0))
' dest folder is arg 1 or "."
If objArgs.Count < 2 then
   DEST = objFSO.GetAbsolutePathName(".")
Else
   DEST = objFSO.GetAbsolutePathName(objArgs(1))
End If
' debugging - print args
' For I = 0 to objArgs.Count - 1
'    WScript.Echo "arg ", I, " ", objArgs(I)
' Next

' create dest folder if it does not exist
If not objFSO.FolderExists(DEST) Then
    objFSO.CreateFolder(DEST)
    WScript.Echo "Created new folder", DEST
End If

' see if file ends in .zip - if not (e.g. .jar) make temp copy
' that ends in .zip
Dim newSRC
newSRC = ""
If not Right(SRC, 4) = ".zip" Then
    newSRC = SRC & ".zip"
    objFSO.CopyFile SRC, newSRC, true
    SRC = newSRC
End If

' get the shell application object used to do the unzip
Set objShell = CreateObject("Shell.Application")
Set objSrc = objShell.Namespace(SRC)
Set objDest = objShell.Namespace(DEST)
' For Each item in objSrc.Items
'     WScript.Echo "item = ", item
' Next
objDest.CopyHere(objSrc.Items)

' remove temp zip, if any
If Len(newSrc) > 0 Then
    objFSO.DeleteFile(newSRC)
End If

WScript.Stdout.Write "Done.  Copied contents of " & SRC & " to " & DEST

' Set WshShell = WScript.CreateObject("WScript.Shell")
' WScript.Echo "CD =", WshShell.CurrentDirectory

' Set objFolder = objFSO.GetFolder(".")
' WScript.Echo "name = ", objFolder.Name

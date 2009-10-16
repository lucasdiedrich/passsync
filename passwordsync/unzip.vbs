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
    Err.Clear
    objFSO.CreateFolder(DEST)
    if Err = 0 Then
        WScript.Echo "Created new folder", DEST
    Else
    	WScript.Echo "Error: could not create new folder " & DEST & _
            " Error: " & Err.Number & ":" & Err.Source & ":" & Err.Description
	Err.Clear
    End If
End If

' see if file ends in .zip - if not (e.g. .jar) make temp copy
' that ends in .zip
Dim newSRC
newSRC = ""
If not Right(SRC, 4) = ".zip" Then
    newSRC = SRC & ".zip"
    Err.Clear
    objFSO.CopyFile SRC, newSRC, true
    if Err = 0 Then
        WScript.Echo "Copied file " & SRC & " to " & newSRC
    Else
    	WScript.Echo "Error: could not copy file " & SRC & " to " & newSRC & _
	    " Error: " & Err.Number & ":" & Err.Source & ":" & Err.Description
	Err.Clear
    End If
    SRC = newSRC
End If

' get the shell application object used to do the unzip
Set objShell = CreateObject("Shell.Application")
Set objSrc = objShell.Namespace(SRC)
WScript.Echo "Set source=", SRC
Set objDest = objShell.Namespace(DEST)
WScript.Echo "Set dest=", DEST

' objDest.CopyHere objSrc.Items
' WScript.Exit 0

For Each item in objSrc.Items
    abspath = objFSO.GetAbsolutePathName(item.Path)
    WScript.Echo "Copying item", abspath, "from", SRC, "to", DEST
    abspath = objFSO.GetAbsolutePathName(DEST & "\\" & item.Path)
    if objFSO.FileExists(abspath) Then
    	WScript.Echo "warning: destination file exists:", abspath
    Else
    	WScript.Echo "destination file does not exist:", abspath
    End If
    if objFSO.FolderExists(abspath) Then
    	WScript.Echo "warning: destination folder exists:", abspath
    Else
    	WScript.Echo "destination folder does not exist:", abspath
    End If
    If item.isFolder Then
        WScript.Echo "Copying folder item", item, "to", DEST
        objDest.CopyHere(item)
    ElseIf item.Size > 0 Then
        WScript.Echo "Copying file item", item, "to", DEST
        objDest.CopyHere(item)
    Else
        WScript.Echo "Skipping item =", item, "type =", item.Type, "path =", item.Path, "parent =", item.Parent, "size =", item.Size
    End If
    if Err <> 0 Then
    	WScript.Echo "Error: could not copy item " & item & " to " & DEST & _
	    " Error: " & Err.Number & ":" & Err.Source & ":" & Err.Description
    Else
        WScript.Echo "Copied item =", item, "type =", item.Type, "path =", abspath, "parent =", item.Parent, "size =", item.Size
    End If
Next

' remove temp zip, if any
If Len(newSrc) > 0 Then
    objFSO.DeleteFile(newSRC)
End If

' Set WshShell = WScript.CreateObject("WScript.Shell")
' WScript.Echo "CD =", WshShell.CurrentDirectory

' Set objFolder = objFSO.GetFolder(".")
' WScript.Echo "name = ", objFolder.Name

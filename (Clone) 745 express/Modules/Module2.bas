Attribute VB_Name = "Module2"

Sub createHtmls()

    Dim aEmailInfo() As Variant, sHub As String, sHtmlPath As String, sPdfPath As String
    Dim i As Long

    Application.Calculation = xlManual
    Application.Calculation = xlAutomatic
    
    aEmailInfo = ThisWorkbook.Sheets("HTML_NAME").Range("A2:F" & getLastRow("HTML_NAME")).Value
    
    For i = 1 To UBound(aEmailInfo)
    
        sHub = aEmailInfo(i, 1)
        sHtmlPath = ThisWorkbook.Path & "\HTML\" & sHub & ".htm"
        
        With ThisWorkbook.PublishObjects.Add(xlSourcePrintArea, sHtmlPath, sHub, "", xlHtmlStatic, "", "")
        .Publish (True)
        .AutoRepublish = False
        End With
        
        
    Next i
End Sub

Function getLastRow(SHEET_NAME As String) As Long
    
    Dim iVert As Long, iHoriz As Long
    
    On Error Resume Next
    With ThisWorkbook.Sheets(SHEET_NAME)
        iVert = .Cells.Find(What:="*", After:=Cells(1, 2), LookIn:=xlValues, LookAt:=xlPart, SearchOrder:=xlByColumns, SearchDirection:=xlPrevious).Row
        iHoriz = .Cells.Find(What:="*", After:=Cells(1, 1), LookIn:=xlValues, LookAt:=xlPart, SearchOrder:=xlByRows, SearchDirection:=xlPrevious).Row
    End With
    On Error GoTo 0
    If iVert > iHoriz Then
        getLastRow = iVert
    Else
        getLastRow = iHoriz
    End If
    
End Function



Attribute VB_Name = "Module1"
Option Explicit
Sub ClearSheet(SHEET_NAME As String)
    ThisWorkbook.Sheets(SHEET_NAME).Cells.ClearContents
End Sub

Sub ImportData(CSV_FILE_PATH As String, SHEET_NAME As String)

    Dim oFSO As FileSystemObject: Set oFSO = New FileSystemObject
    Dim oText As TextStream, sData As String
    Dim aTemp(), aSplit() As String, i As Long, j As Long, iColumnCount As Long
    
    Set oText = oFSO.OpenTextFile(CSV_FILE_PATH) 'Open the txt file
    
    Do While Not oText.AtEndOfStream
        i = i + 1
        sData = oText.ReadLine
        aSplit = Split(sData, ",")
        If i = 1 Then
            iColumnCount = UBound(aSplit) + 1
            ReDim aTemp(1 To iColumnCount, 1 To 100000)
        End If
        
        For j = 1 To iColumnCount
            aTemp(j, i) = aSplit(j - 1)
        Next j
        
    Loop
    
    ReDim Preserve aTemp(1 To iColumnCount, 1 To i)
    Call QuickPaste(SHEET_NAME, aTemp, 1, 1)
    
    Set oFSO = Nothing
    Set oText = Nothing

End Sub

Sub QuickPaste(SHEET_NAME As String, ByRef ARRAY_2_PASTE, START_ROW As Long, START_COL As Long)
    
    Dim iTotalRows2Paste As Long, iTotalPasteGroups As Long, iPasteCount As Long, iPasteStartRow As Long, iPasteEndRow As Long, _
        iArrayStartRow As Long, iArrayEndRow As Long, iRowsToPasteNow As Long, iRowsLeftToPaste As Long
    Dim aPaste() As String, i As Long, j As Long
    Dim START_ARRAY
    
    START_ARRAY = ARRAY_2_PASTE
    
    iTotalRows2Paste = UBound(ARRAY_2_PASTE, 2)
    iTotalPasteGroups = Application.RoundUp(iTotalRows2Paste / 55000, 0) 'find how many times to group 55K rows into sep array for pasting
    iArrayStartRow = 1
    iPasteStartRow = START_ROW
    
    With ThisWorkbook.Sheets(SHEET_NAME)

        For iPasteCount = 1 To iTotalPasteGroups
            
            iRowsLeftToPaste = iTotalRows2Paste - (iPasteCount - 1) * 55000
            If iRowsLeftToPaste > 55000 Then
                iRowsToPasteNow = 55000
            Else
                iRowsToPasteNow = iRowsLeftToPaste
            End If
        
            ReDim aPaste(1 To UBound(ARRAY_2_PASTE), 1 To iRowsToPasteNow)

            iArrayEndRow = iArrayStartRow + iRowsToPasteNow - 1
            iPasteEndRow = iPasteStartRow + iRowsToPasteNow - 1
            
            For i = 1 To UBound(aPaste, 2) 'store the new array with data from the old
                For j = 1 To UBound(aPaste)
                    aPaste(j, i) = ARRAY_2_PASTE(j, iArrayStartRow + i - 1)
                Next j
            Next i
                
            .Range(Cells(iPasteStartRow, START_COL).Address & ":" & Cells(iPasteEndRow, START_COL + UBound(aPaste) - 1).Address) = Application.Transpose(aPaste)
            
            iArrayStartRow = iArrayEndRow + 1
            iPasteStartRow = iPasteEndRow + 1
        
        Next iPasteCount

    End With
    
    ARRAY_2_PASTE = START_ARRAY
    
End Sub




Attribute VB_Name = "Module3"
Sub createPng(PNG_FILE_PATH As String, SHEET_NAME As String)
'Sub createPng()
'    Dim PNG_FILE_PATH As String: PNG_FILE_PATH = "C:\Users\u313575\PycharmProjects\DailyPat\_PNG\test.png"
'    Dim SHEET_NAME As String: SHEET_NAME = "SYSTEM"
    Dim iZoom As Long, rngPrint As Range, oPic
    
    iZoom = 1.25
    Set rngPrint = Sheets(SHEET_NAME).Range(Sheets(SHEET_NAME).PageSetup.PrintArea)
    rngPrint.CopyPicture xlPrinter
    
    
    Set oPic = Sheets(SHEET_NAME).ChartObjects.Add(0, 0, rngPrint.Width * iZoom, rngPrint.Height * iZoom)
    oPic.Chart.Paste
    oPic.Chart.Export PNG_FILE_PATH, "png"
    oPic.Delete
End Sub

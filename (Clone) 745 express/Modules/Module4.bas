Attribute VB_Name = "Module4"
Sub createPdf(PDF_1_PATH As String)
    
    Application.Calculation = xlAutomatic
            
    Debug.Print PDF_1_PATH
    ThisWorkbook.Sheets(Array("PAGE_1")).Select
        ActiveSheet.ExportAsFixedFormat Type:=xlTypePDF, Filename:=PDF_1_PATH, Quality:=xlQualityMinimum, _
        IncludeDocProperties:=True, IgnorePrintAreas:=False, OpenAfterPublish:=False
               
    
End Sub


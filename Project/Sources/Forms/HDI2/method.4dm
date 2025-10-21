Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		btnTrace:=False:C215
		
		InitInfo
		
		Form:C1466.products:=ds:C1482.Products.init()
		Form:C1466.invoices:=ds:C1482.Invoices.init()
		
		//Use (Storage.checks)
		//Storage.checks.openLog:=False
		//Storage.checks.openInvoicesLog:=False
		//End use 
		
		Form:C1466.openLog:=False:C215
		Form:C1466.openInvoicesLog:=False:C215
		
		Form:C1466.invoicesInFailure:=ds:C1482.InvoicesInFailure.all()
		
		Form:C1466.invoicesLogs:=ds:C1482.InvoicesLog.all()
		
		//OBJECT SET VISIBLE(*; "NewProductValue"; False)
		//OBJECT SET VISIBLE(*; "Margin@"; False)
		//OBJECT SET VISIBLE(*; "SaveButton"; False)
		
		
		OBJECT SET ENABLED:C1123(*; "ToDeleteButton"; Form:C1466.selectedInvoice#Null:C1517)
		OBJECT SET ENABLED:C1123(*; "DropButton"; Form:C1466.selectedInvoice#Null:C1517)
		
		
	: (Form event code:C388=On Page Change:K2:54)
		
		//manageTexts
		
		Form:C1466.products:=ds:C1482.Products.init()
		Form:C1466.invoices:=ds:C1482.Invoices.init()
		
	: (Form event code:C388=On Close Box:K2:21)
		If (Is Windows:C1573 && Application info:C1599().SDIMode)
			QUIT 4D:C291
		Else 
			CANCEL:C270
		End if 
		
End case 
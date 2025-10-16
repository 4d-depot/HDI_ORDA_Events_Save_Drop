

If (btnTrace)
	TRACE:C157
End if 


Try
	Form:C1466.status:=Form:C1466.selectedInvoice.drop()
Catch
	OBJECT SET RGB COLORS:C628(*; "Message2"; "#ff0000")
	OBJECT SET RGB COLORS:C628(*; "Info2"; "#ff0000")
End try

If (Form:C1466.status.errors#Null:C1517)
	Form:C1466.info:=Form:C1466.status.errors.first().extraDescription.info
	Form:C1466.message:=Form:C1466.status.errors.first().message
	
	If (Form:C1466.status.errors.first().fatalError=False:C215)
		OBJECT SET RGB COLORS:C628(*; "Message2"; "#ff9933")
		OBJECT SET RGB COLORS:C628(*; "Info2"; "#ff9933")
	End if 
	
Else 
	Form:C1466.message:="The invoice has been successfully dropped"
	Form:C1466.info:="Congratulations!"
	
	Form:C1466.invoices:=Form:C1466.invoices.clean()
	
	If (Form:C1466.selectedInvoice.amount<200)
		Form:C1466.message+=Char:C90(Carriage return:K15:38)+Char:C90(Carriage return:K15:38)+"Nothing has been logged because the amount is < 200"
	End if 
	
	OBJECT SET RGB COLORS:C628(*; "Message2"; "#009933")
	OBJECT SET RGB COLORS:C628(*; "Info2"; "#009933")
End if 

OBJECT SET VISIBLE:C603(*; "Message2"; True:C214)
OBJECT SET VISIBLE:C603(*; "Info2"; True:C214)


Form:C1466.invoicesLogs:=ds:C1482.InvoicesLog.all()
Form:C1466.invoicesInFailure:=ds:C1482.InvoicesInFailure.all()

OBJECT SET ENABLED:C1123(*; "ToDeleteButton"; Form:C1466.selectedInvoice#Null:C1517)
OBJECT SET ENABLED:C1123(*; "DropButton"; Form:C1466.selectedInvoice#Null:C1517)

refreshStatistics






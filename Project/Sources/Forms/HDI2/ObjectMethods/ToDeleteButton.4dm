

var $status : Object


If (btnTrace)
	TRACE:C157
End if 


Form:C1466.selectedInvoice.toDelete:=True:C214

$status:=Form:C1466.selectedInvoice.save()

Form:C1466.invoices:=Form:C1466.invoices

OBJECT SET VISIBLE:C603(*; "Message2"; True:C214)
OBJECT SET VISIBLE:C603(*; "Info2"; True:C214)

Form:C1466.info:="You can now drop this invoice"
Form:C1466.message:=""

OBJECT SET RGB COLORS:C628(*; "Message2"; "#000000")
OBJECT SET RGB COLORS:C628(*; "Info2"; "#000000")

OBJECT SET ENABLED:C1123(*; "ToDeleteButton"; Form:C1466.selectedInvoice#Null:C1517)
OBJECT SET ENABLED:C1123(*; "DropButton"; Form:C1466.selectedInvoice#Null:C1517)









If (btnTrace)
	TRACE:C157
End if 

Form:C1466.product.category:=Form:C1466.category.currentValue

Try
	Form:C1466.status:=Form:C1466.product.save()
Catch
	OBJECT SET RGB COLORS:C628(*; "Message"; "#ff0000")
	OBJECT SET RGB COLORS:C628(*; "Info"; "#ff0000")
	
	OBJECT SET RGB COLORS:C628(*; "Margin@"; "#000000")
	OBJECT SET FONT STYLE:C166(*; "Margin@"; Plain:K14:1)
End try

If (Form:C1466.status.errors#Null:C1517)
	Form:C1466.info:=Form:C1466.status.errors.first().extraDescription.info
	Form:C1466.message:=Form:C1466.status.errors.first().message
	
	If (Form:C1466.status.errors.first().seriousError=False:C215)
		OBJECT SET RGB COLORS:C628(*; "Message"; "#ff9933")
		OBJECT SET RGB COLORS:C628(*; "Info"; "#ff9933")
		OBJECT SET RGB COLORS:C628(*; "Margin@"; "#ff9933")
		OBJECT SET FONT STYLE:C166(*; "Margin@"; Bold:K14:2)
	End if 
	
Else 
	Form:C1466.message:="The product has been created"
	Form:C1466.info:="Congratulations"
	
	OBJECT SET RGB COLORS:C628(*; "Message"; "#009933")
	OBJECT SET RGB COLORS:C628(*; "Info"; "#009933")
	
	OBJECT SET RGB COLORS:C628(*; "Margin@"; "#000000")
	OBJECT SET FONT STYLE:C166(*; "Margin@"; Plain:K14:1)
	
	OBJECT SET VISIBLE:C603(*; "SaveButton"; False:C215)
	//
End if 


OBJECT SET VISIBLE:C603(*; "Message"; True:C214)
OBJECT SET VISIBLE:C603(*; "Info"; True:C214)

Form:C1466.documents:=ds:C1482.Documents.all()
Form:C1466.products:=ds:C1482.Products.all()









Form:C1466.product:=ds:C1482.Products.new()

Form:C1466.category.index:=Form:C1466.category.values.indexOf(Form:C1466.product.category)

OBJECT SET VISIBLE:C603(*; "NewProduct@"; True:C214)

OBJECT SET VISIBLE:C603(*; "SaveButton"; True:C214)

OBJECT SET VISIBLE:C603(*; "Margin@"; True:C214)

OBJECT SET RGB COLORS:C628(*; "Margin@"; "#000000")
OBJECT SET FONT STYLE:C166(*; "Margin@"; Plain:K14:1)

OBJECT SET VISIBLE:C603(*; "Message"; False:C215)
OBJECT SET VISIBLE:C603(*; "Info"; False:C215)

Form:C1466.openLog:=False:C215


Use (Storage:C1525.checks)
	Storage:C1525.checks.openLog:=Bool:C1537(Form:C1466.openLog)
End use 
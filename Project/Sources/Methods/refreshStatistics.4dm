//%attributes = {}

Form:C1466.statistics:={}

Form:C1466.statistics.booksMarginAverage:=ds:C1482.Products.query("category= :1"; "Books").average("margin")
Form:C1466.statistics.stationeryMarginAverage:=ds:C1482.Products.query("category= :1"; "Stationery").average("margin")

Form:C1466.statistics.invoicesAmountAverage:=ds:C1482.Invoices.all().average("amount")
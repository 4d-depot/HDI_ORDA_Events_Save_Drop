Class extends DataClass



exposed Function init() : cs:C1710.InvoicesSelection
	
	var $invoicesFile : 4D:C1709.File
	var $invoicesColl : Collection
	var $notDropped; $invoices : cs:C1710.InvoicesSelection
	
	
	Use (Storage:C1525.checks)
		Storage:C1525.checks.enableEvents:=False:C215
	End use 
	
	$notDropped:=This:C1470.all().drop()
	
	$invoicesFile:=File:C1566("/PACKAGE/Resources/invoices.json")
	$invoicesColl:=JSON Parse:C1218($invoicesFile.getText())
	
	$invoices:=This:C1470.fromCollection($invoicesColl)
	
	Use (Storage:C1525.checks)
		Storage:C1525.checks.enableEvents:=True:C214
	End use 
	
	return $invoices
	
	
	//For Qodly
	//
exposed Function getStatistics() : Object
	
	var $result:={}
	
	$result.invoicesAmountAverage:=ds:C1482.Invoices.all().average("amount")
	
	return $result
	
	
	


var $notDropped : 4D:C1709.EntitySelection


//00_Start

Use (Storage:C1525)
	Storage:C1525.diskInfo:=New shared object:C1526("noSpaceOnDisk"; False:C215)
End use 


ds:C1482.Products.init()
ds:C1482.Invoices.init()


$notDropped:=ds:C1482.InvoicesLog.all().drop()


$notDropped:=ds:C1482.InvoicesInFailure.all().drop()

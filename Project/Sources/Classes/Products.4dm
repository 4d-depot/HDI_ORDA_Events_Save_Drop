Class extends DataClass




exposed Function init() : cs:C1710.ProductsSelection
	
	var $productsFile; $file : 4D:C1709.File
	var $productsColl : Collection
	var $products : cs:C1710.ProductsSelection
	var $notDropped : 4D:C1709.EntitySelection
	var $folder : 4D:C1709.Folder
	
	
	Use (Storage:C1525)
		Storage:C1525.diskInfo:=New shared object:C1526("noSpaceOnDisk"; False:C215)
	End use 
	
	$notDropped:=ds:C1482.Documents.all().drop()
	
	$folder:=Folder:C1567("/PACKAGE/Resources/Files")
	
	For each ($file; $folder.files())
		$file.delete()
	End for each 
	
	$notDropped:=This:C1470.all().drop()
	
	$productsFile:=File:C1566("/PACKAGE/Resources/products.json")
	$productsColl:=JSON Parse:C1218($productsFile.getText())
	
	$products:=This:C1470.fromCollection($productsColl)
	
	return $products
	
	
	//For Qodly
	//
exposed Function getNew() : cs:C1710.ProductsEntity
	return This:C1470.new()
	
exposed Function getStatistics() : Object
	
	var $result:={}
	
	$result.booksMarginAverage:=ds:C1482.Products.query("category= :1"; "Books").average("margin")
	$result.stationeryMarginAverage:=ds:C1482.Products.query("category= :1"; "Stationery").average("margin")
	
	return $result
	
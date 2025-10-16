Class extends DataClass




exposed Function init() : cs:C1710.ProductsSelection
	
	var $productsFile : 4D:C1709.File
	var $productsColl : Collection
	var $notDropped; $products : cs:C1710.ProductsSelection
	
	
	Use (Storage:C1525.checks)
		Storage:C1525.checks.enableEvents:=False:C215
	End use 
	
	$notDropped:=This:C1470.all().drop()
	
	$productsFile:=File:C1566("/PACKAGE/Resources/products.json")
	$productsColl:=JSON Parse:C1218($productsFile.getText())
	
	$products:=This:C1470.fromCollection($productsColl)
	
	Use (Storage:C1525.checks)
		Storage:C1525.checks.enableEvents:=True:C214
	End use 
	
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
	
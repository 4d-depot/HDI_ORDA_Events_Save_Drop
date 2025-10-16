Class extends Entity



exposed Function get producId() : Integer
	
	var $result : Integer
	
	$result:=0
	
	If ((This:C1470.products#Null:C1517) && (This:C1470.products.length#0))
		$result:=This:C1470.products.first().ID
	End if 
	
	
	return $result
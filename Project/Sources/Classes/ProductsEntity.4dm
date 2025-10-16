

Class extends Entity


Class constructor()
	This:C1470.name:="New product"
	This:C1470.costPrice:=100
	This:C1470.retailPrice:=110
	
	
	//
	// SAVE EVENTS
	//
Function event validateSave margin($event : Object) : Object
	
	var $result : Object
	
	If (This:C1470.margin<50)
		$result:={errCode: 1; message: "The validation of this product failed"; \
			extraDescription: {info: "The margin of this product ("+String:C10(This:C1470.margin)+") is lower than 50"}; fatalError: False:C215}
	End if 
	
	return $result
	
	
Function event saving($event : Object) : Object
	
	var $result : Object
	var $userManualFile : 4D:C1709.File
	var $fileCreated : Boolean
	var $doc : cs:C1710.DocumentsEntity
	
	
	$userManualFile:=File:C1566("/PACKAGE/Resources/Files/userManual_"+This:C1470.name+".pdf")
	
	If ($userManualFile.exists)
		$userManualFile.delete()
	End if 
	
	$doc:=ds:C1482.Documents.new()
	$doc.userManualPath:=$userManualFile.path
	$doc.stamp:=Timestamp:C1445()
	$status:=$doc.save()
	
	This:C1470.doc:=$doc
	
	If (Storage:C1525.diskInfo.noSpaceOnDisk)
		$result:={errCode: 1; message: "Error during the save action for this product"; extraDescription: {info: "There is no available space on disk"}}
	Else 
		$fileCreated:=$userManualFile.create()
	End if 
	
	return $result
	
	
Function event afterSave($event : Object)
	
	var $doc : cs:C1710.DocumentsEntity
	var $status : Object
	
	
	If (($event.status.success=False:C215) && ($event.status.errors=Null:C1517))  // $event.status.errors is filled if the error comes from the validateSave event
		
		$doc:=ds:C1482.Documents.query("products is Null").first()
		
		$doc.userManualPath:=""
		$doc.info:="Error when saving the product: "+This:C1470.name+" on "+String:C10(Current date:C33())
		$doc.stamp:=Timestamp:C1445()
		
		$status:=$doc.save()
	End if 
	
	
	//
	//
exposed Function get margin() : Real
	return ((This:C1470.retailPrice-This:C1470.costPrice)*100)/This:C1470.costPrice
	
	
	//For Qodly
exposed Function saveMe($openLog : Boolean) : Object
	
	var $status : Object
	
	Use (Storage:C1525.checks)
		Storage:C1525.checks.openLog:=$openLog
	End use 
	
	Try
		$status:=This:C1470.save()
	Catch
		Web Form:C1735.setError($status.errors.first().message+" - "+$status.errors.first().extraDescription.info)
		return $status
	End try
	
	If ($status.errors#Null:C1517)
		//If (Not($status.errors.first().fatalError))
		Web Form:C1735.setWarning($status.errors.first().message+" - "+$status.errors.first().extraDescription.info)
		//End if 
	Else 
		Web Form:C1735.setMessage("Congratulations! Your product has been created")
	End if 
	
	return $status
	
	
	
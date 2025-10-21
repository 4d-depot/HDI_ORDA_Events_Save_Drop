

Class extends Entity


Class constructor()
	This:C1470.name:="New product"
	This:C1470.costPrice:=100
	This:C1470.retailPrice:=110
	This:C1470.createUserManual:=True:C214
	
	
	//
	// SAVE EVENTS
	//
Function event validateSave margin($event : Object) : Object
	
	var $result : Object
	
	If (This:C1470.margin<50)
		$result:={errCode: 1; message: "The validation of this product failed"; \
			extraDescription: {info: "The margin of this product ("+String:C10(This:C1470.margin)+") is lower than 50"}; seriousError: False:C215}
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
	
	//$doc:=ds.Documents.new()
	//$doc.userManualPath:=$userManualFile.path
	//$doc.stamp:=Timestamp()
	//$status:=$doc.save()
	
	//This.doc:=$doc
	
	$result:=Null:C1517
	
	If (This:C1470.createUserManual)
		Try
			If (Storage:C1525.diskInfo.noSpaceOnDisk)
				throw:C1805(1)
			Else 
				$fileCreated:=$userManualFile.create()
				This:C1470.userManualPath:=$userManualFile.path
				This:C1470.status:="OK"
			End if 
		Catch
			$result:={errCode: 1; message: "Error during the save action for this product"; extraDescription: {info: "There is no available space on disk"}}
		End try
	End if 
	
	return $result
	
	
Function event afterSave($event : Object)
	
	var $doc : cs:C1710.DocumentsEntity
	var $status : Object
	
	
	If (($event.status.success=False:C215) && ($event.status.errors=Null:C1517))  // $event.status.errors is filled if the error comes from the validateSave event
		
		//$doc:=ds.Documents.query("products is Null").first()
		
		//$doc.userManualPath:=""
		//$doc.info:="Error when saving the product: "+This.name+" on "+String(Current date())
		//$doc.stamp:=Timestamp()
		
		//$status:=$doc.save()
		
		This:C1470.status:="Error during the creation of the user manual doc"
		This:C1470.createUserManual:=False:C215
		Try
			$status:=This:C1470.save()
		Catch
		End try
		
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
	
	
	
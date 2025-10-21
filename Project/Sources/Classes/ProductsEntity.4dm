

Class extends Entity


Class constructor()
	This:C1470.name:="New product"
	This:C1470.costPrice:=100
	This:C1470.retailPrice:=110
	This:C1470.status:="OK"
	
	
Function event touched name($event : Object)
	
	This:C1470.userManualPath:="/PACKAGE/Resources/Files/userManual_"+This:C1470.name+".pdf"
	
	
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
	
	
Function event saving userManualPath($event : Object) : Object
	
	var $result : Object
	var $userManualFile : 4D:C1709.File
	var $fileCreated : Boolean
	
	
	$userManualFile:=File:C1566(This:C1470.userManualPath)
	
	If ($userManualFile.exists)
		$userManualFile.delete()
	End if 
	
	Try
		If (Storage:C1525.diskInfo.noSpaceOnDisk)
			throw:C1805(1; "")
		Else 
			$fileCreated:=$userManualFile.create()
		End if 
	Catch
		$result:={errCode: 1; message: "Error during the save action for this product"; extraDescription: {info: "There is no available space on disk to store the user manual"}}
	End try
	
	
	return $result
	
	
Function event afterSave($event : Object)
	
	If (($event.status.success=False:C215) && ($event.status.errors=Null:C1517))  // $event.status.errors is filled if the error comes from the validateSave event
		
		If ($event.savedAttributes.indexOf("userManualPath")=-1)
			This:C1470.userManualPath:=""
			This:C1470.status:="KO"
		End if 
		
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
	
	
	


Class extends Entity


Class constructor()
	This:C1470.name:="New product"
	This:C1470.costPrice:=100
	This:C1470.retailPrice:=110
	This:C1470.status:="OK"
	
	
	// Computed attribute
	//
exposed Function get margin() : Real
	return ((This:C1470.retailPrice-This:C1470.costPrice)*100)/This:C1470.costPrice
	
	
	// Touched event
	//
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
	
	If (This:C1470.userManualPath#"")
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
	End if 
	
	
	return $result
	
	
Function event afterSave($event : Object)
	
	If (($event.status.success=False:C215) && ($event.status.errors=Null:C1517))  // $event.status.errors is filled if the error comes from the validateSave event
		
		If ($event.savedAttributes.indexOf("userManualPath")=-1)
			This:C1470.userManualPath:=""
			This:C1470.status:="KO"
		End if 
		
	End if 
	
	// ------------------------------------------------
	//
	// DROP EVENTS
	//
Function event validateDrop status($event : Object) : Object
	
	var $result : Object
	
	If (This:C1470.status#"TO DELETE")
		$result:={errCode: 1; message: "You can't drop this product"; \
			extraDescription: {info: "This product must be marked as To Delete"}; seriousError: False:C215}
	End if 
	
	return $result
	
	
Function event dropping($event : Object) : Object
	
	var $result : Object
	var $userManualFile : 4D:C1709.File
	
	
	$userManualFile:=File:C1566(This:C1470.userManualPath)
	
	Try
		If (Storage:C1525.diskInfo.errorOnDropFile)
			throw:C1805(1; "")
		Else 
			If ($userManualFile.exists)
				$userManualFile.delete()
			End if 
		End if 
	Catch
		$result:={errCode: 1; message: "Drop failed"; extraDescription: {info: "The user manual can't be dropped"}}
	End try
	
	return $result
	
	
	
Function event afterDrop($event : Object)
	
	var $status : Object
	
	If (($event.status.success=False:C215) && ($event.status.errors=Null:C1517))  // $event.status.errors is filled if the error comes from the validateDrop event
		This:C1470.status:="Check this product - Drop action failed"
		$status:=This:C1470.save()
	End if 
	
	// --------------------------------------------------------------
	//
	//For Qodly
exposed Function saveMe($noSpaceOnDisk : Boolean) : Object
	
	var $status : Object
	
	Use (Storage:C1525.diskInfo)
		Storage:C1525.diskInfo.noSpaceOnDisk:=$noSpaceOnDisk
	End use 
	
	Try
		$status:=This:C1470.save()
	Catch
		Web Form:C1735.setError($status.errors.first().message+" - "+$status.errors.first().extraDescription.info)
		return $status
	End try
	
	If ($status.errors#Null:C1517)
		Web Form:C1735.setWarning($status.errors.first().message+" - "+$status.errors.first().extraDescription.info)
	Else 
		Web Form:C1735.setMessage("Congratulations! Your product has been created")
	End if 
	
	return $status
	
	
	
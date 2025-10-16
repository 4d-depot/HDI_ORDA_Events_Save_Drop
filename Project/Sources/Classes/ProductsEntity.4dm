Class extends Entity


Class constructor()
	This:C1470.name:="New product"
	This:C1470.category:="Books"
	
	//
	// SAVE EVENTS
	//
Function event validateSave margin($event : Object) : Object
	
	var $result : Object
	var $marginAverage : Real
	
	// Events are ignored when importing data with ds.Products.init()
	If (Storage:C1525.checks.enableEvents=True:C214)
		
		$marginAverage:=ds:C1482.Products.query("category= :1"; This:C1470.category).average("margin")
		
		If (This:C1470.margin<$marginAverage)
			$result:={errCode: 1; message: "The margin of this product ("+String:C10(This:C1470.margin)+") is under the average"; \
				extraDescription: {info: "For the "+This:C1470.category+" category the margin average is: "+String:C10($marginAverage)}; fatalError: False:C215}
		End if 
		
	End if 
	
	return $result
	
Function event saving($event : Object) : Object
	
	var $result; $status : Object
	var $log : cs:C1710.Entity
	var $remote; $remoteOK; $remoteKO : 4D:C1709.DataStoreImplementation
	
	// Events are ignored when importing data with ds.Products.init()
	If (Storage:C1525.checks.enableEvents=True:C214)
		
		Try
			
			If (Storage:C1525.checks.openLog)
				$remoteOK:=Open datastore:C1452({hostname: "127.0.0.1:8044"}; "logsOK")  //+String(Storage.checks.seqNumber))
				$remoteOK.authentify()
				$remote:=$remoteOK
			Else 
				$remoteKO:=Open datastore:C1452({hostname: "xxxx.0.0.1"}; "logsKO")
				$remote:=$remoteKO
			End if 
			
			$log:=$remote.Logs.new()
			$log.productId:=This:C1470.ID
			$log.stamp:=Timestamp:C1445
			$log.event:="Created by "+Current user:C182()
			$status:=$log.save()
			
		Catch
			$result:={errCode: Last errors:C1799().last().errCode; message: Last errors:C1799().last().message; extraDescription: {info: "The external Logs can't be reached"}}
		End try
		
	End if 
	
	return $result
	
	
Function event afterSave($event : Object)
	
	var $failure : cs:C1710.ProductsInFailureEntity
	var $status : Object
	
	// Events are ignored when importing data with ds.Products.init()
	If (Storage:C1525.checks.enableEvents=True:C214)
		
		If (($event.status.success=False:C215) && ($event.status.errors=Null:C1517))  // $event.status.errors is filled if the error comes from the validateSave event
			$failure:=ds:C1482.ProductsInFailure.new()
			$failure.name:=This:C1470.name
			$failure.category:=This:C1470.category
			$failure.costPrice:=This:C1470.costPrice
			$failure.retailPrice:=This:C1470.retailPrice
			$failure.reason:="Error during the save action"
			$failure.stamp:=Timestamp:C1445
			$status:=$failure.save()
		End if 
		
	End if 
	
	//
	//
exposed Function get margin() : Real
	return This:C1470.retailPrice-This:C1470.costPrice
	
	
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
	
	
	
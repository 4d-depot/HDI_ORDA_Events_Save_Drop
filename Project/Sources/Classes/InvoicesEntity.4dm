Class extends Entity


//
// DROP EVENTS
//
Function event validateDrop toDelete($event : Object) : Object
	
	var $result : Object
	
	If (Not:C34(This:C1470.toDelete))
		$result:={errCode: 1; message: "You can't drop this invoice"; \
			extraDescription: {info: "This invoice must be marked as To Delete"}; seriousError: False:C215}
	End if 
	
	return $result
	
	
	//
	//Function event validateDrop margin($event : Object) : Object
	
	//var $result : Object
	//var $marginAverage : Real
	
	//// Events are ignored when importing data with ds.Products.initProducts()
	//If (Storage.checks.enableEvents=True)
	
	//$marginAverage:=ds.Products.query("category= :1"; This.category).average("margin")
	
	//If (This.margin>$marginAverage)
	//$result:={errCode: 1; message: "You can't drop this product because it is profitable"; \
		extraDescription: {info: "The margin of this product ("+String(This.margin)+") exceeds the average for the "+This.category+" category ("+String($marginAverage)+")"}; fatalError: False}
	//End if 
	
	//End if 
	
	//return $result
	
	
Function event dropping amount($event : Object) : Object
	
	var $result; $status : Object
	var $amountAverage : Real
	var $remote; $remoteOK; $remoteKO : 4D:C1709.DataStoreImplementation
	var $invoiceLog : 4D:C1709.Entity
	
	
	//$amountAverage:=ds.Invoices.all().average("amount")
	
	If (This:C1470.amount>=200)
		
		Try
			
			
			
		Catch
			$result:={errCode: Last errors:C1799().last().errCode; message: Last errors:C1799().last().message; extraDescription: {info: "The external invoices Logs can't be reached"}}
		End try
		
		return $result
	End if 
	
	
	
Function event afterDrop($event : Object)
	
	var $failure : cs:C1710.InvoicesInFailureEntity
	var $status : Object
	
	
	If (($event.status.success=False:C215) && ($event.status.errors=Null:C1517))  // $event.status.errors is filled if the error comes from the validateDrop event
		$failure:=ds:C1482.InvoicesInFailure.new()
		$failure.invoiceId:=This:C1470.ID
		$failure.reason:="Error during the drop action"
		$failure.stamp:=Timestamp:C1445
		$status:=$failure.save()
	End if 
	
	
	
	//For Qodly
	//
exposed Function dropMe($openLog : Boolean) : Object
	
	var $status : Object
	
	
	Try
		$status:=This:C1470.drop()
	Catch
		Web Form:C1735.setError($status.errors.first().message+" - "+$status.errors.first().extraDescription.info)
		return $status
	End try
	
	If ($status.errors#Null:C1517)
		//If (Not($status.errors.first().fatalError))
		Web Form:C1735.setWarning($status.errors.first().message+" - "+$status.errors.first().extraDescription.info)
		//End if 
	Else 
		$message:="Congratulations! Your invoice has been dropped"
		If (This:C1470.amount<200)
			$message+=Char:C90(Carriage return:K15:38)+Char:C90(Carriage return:K15:38)+"Nothing has been logged because the amount is < 200"
		End if 
		Web Form:C1735.setMessage($message)
	End if 
	
	return $status
	
exposed Function markAsDelete()
	
	var $status : Object
	
	This:C1470.toDelete:=True:C214
	
	$status:=This:C1470.save()
	
	Web Form:C1735.setMessage("You can now drop this invoice")
	
	
$itempath = "item path here"
$templatePath = "template path here"
$InputcsvFile = Show-Input "Input file path"
$csv = Import-CSV $InputcsvFile -delimiter ","
 
$bulk = New-Object "Sitecore.Data.BulkUpdateContext"
try
{
	foreach($record in $csv)
	{
		$item = New-Item -Path $itempath -Name $record.ItemName -ItemType $templatePath
		$item.Editing.BeginEdit()
    		$item["__Display name"] = $record.ItemName 
   		$item.Editing.EndEdit()
		Write-Host "Item created: " $record.ItemName
	}
}
finally
{
 $bulk.Dispose()
}

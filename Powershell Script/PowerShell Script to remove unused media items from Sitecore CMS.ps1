$timenow = [datetime]::Now
$IsoDateNow = [sitecore.dateutil]::ToIsoDate($timenow)
$IsoDateToUtcIsoDate = [sitecore.dateutil]::IsoDateToUtcIsoDate($IsoDateNow)
$sitePath = "Physical Site Path"

$logItem = new-object PSObject | select-object ID, MediaPath, Status, UsedByItemPath
$logFilepath = $sitecorelogFolder + "\Media-Delete_" + $IsoDateToUtcIsoDate + ".csv"
remove-item $logFilePath -errorAction ignore
Function LogWrite {
    Param ([PSObject]$logItem)
    #Add-content $Logfile -value $logstring
    export-csv -inputobject $logItem -path  $logFilepath -append -notypeinformation -force
}
function Get-ItemReferrers ($item) {
   
    $logItem = new-object PSObject | select-object ID, MediaPath, Status, UsedByItemPath
    
    $logItem.MediaPath = $item.Paths.FullPath
    $logItem.ID = $item.ID
    $linkDb = [Sitecore.Globals]::LinkDatabase
    $links = $linkDb.GetReferrers($item)
    $CanDelete = 'true'
    $noRef = 'true'
    $usedByPath = ''
    
    foreach ($link in $links) {
        $linkedItem = Get-Item -Path master:\ -ID $link.SourceItemID            
        $path = $linkedItem.FullPath            
             
        if ($path -eq '') {
            $CanDelete = 'true'
            #usedByPath= usedByPath + '|' +$linkedItem.Paths.FullPath
            $usedByPath = $usedByPath + '|' + $linkedItem.Paths.FullPath
            $logItem.OtherVertical = $true
            break;
        }
        else {
            $usedByPath = $usedByPath + '|' + $linkedItem.Paths.FullPath
            #$logItem.UsedByItemPath=$linkedItem.Paths.FullPath
            $CanDelete = 'false'
                    
        }
    }     
    
    $logItem.UsedByItemPath = $usedByPath
              
    if (($CanDelete -eq 'true')) {
        $logItem.Status = 'Deleted'
        LogWrite ($logItem)
        if ($logItem.FileExists) {          
            Remove-Item -Path $fullFilePath -Force
            Remove-Item -Path $item.Paths.FullPath -Permanently
        }      
    }
    else {
        $logItem.Status = 'Skiped'
        LogWrite ($logItem) 
    }
}

$itemPath = "/sitecore/media library"

$mideaItems = Get-ChildItem -Path $itemPath -r  | Where-Object { $_.TemplateID -ne [Sitecore.TemplateIDs]::MediaFolder }  -ErrorAction SilentlyContinue

foreach ($item in $mideaItems) {
  
    try {
        Get-ItemReferrers $item 
   
    }
    catch { 
                            
    }
 
}
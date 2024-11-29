$props = @{
    InfoTitle = "Remove workflows"
     PageSize = 10000000
 }
 
 Write-Host "Starting work in the context of the 'master' database, under /Home item."
 Set-Location -Path "master:/sitecore/content/MySite1/Home"
 
 # Set up variables
 $workflowState1 = "{xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}" #ID of the workflow states. 
 $workflowState2 = "{yyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy}"
 $workflowState3 = "{zzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz}"
 
 function Remove-Workflows {
 
     # Logic
     foreach ($item in Get-ChildItem . -Recurse)
     {
         foreach ($version in $item.Versions.GetVersions($true))
         {
             if (($version.Fields["__Workflow state"].Value -eq $workflowState1) -or ($version.Fields["__Workflow state"].Value -eq $workflowState2) -or ($version.Fields["__Workflow state"].Value -eq $workflowState3))
             {
                 $version.Editing.BeginEdit();
                 $version.Fields["__Workflow state"].Value = ""
                 $version.Editing.EndEdit();
                 Publish-Item $version -Target "web" -PublishMode SingleItem -Language $version.Language 
             
                 Write-Host $version.ID " - " $version.Language 
                 $version;
             }
             else
             {
                 #Write-Host "NOT UPDATED: " $version.ItemPath " - " $version.Language 
             }
         }   
     }
 
 }
 
 $items = Remove-Workflows
 $items | Show-ListView @props -Property ItemPath, ID, @{Label="Language"; Expression={$_."Language"}} 
 Close-Window
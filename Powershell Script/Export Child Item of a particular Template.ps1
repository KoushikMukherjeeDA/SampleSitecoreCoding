
$path="Item Path"
$item = Get-ChildItem -path "$($path)" -Recurse | Where-Object { $_.TemplateName -eq "Page" } #Provide Template Name
 
$item | Show-ListView -Property `
    @{ Name="Item Name"; Expression={$_.DisplayName}}, # property renamed
    @{ Name="Item path"; Expression={$_.FullPath}}
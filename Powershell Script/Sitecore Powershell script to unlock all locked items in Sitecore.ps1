$sourcePath = "Home Item Path"
function RunScript
{
    $items = Get-ChildItem -Path $sourcePath -Recurse
    $rootItem = Get-Item -Path $sourcePath
    $items = $items + $rootItem

    foreach ($item in $items)
    {
        foreach ($version in $item.Versions.GetVersions($true))
        {
            if($version.Locking.IsLocked())
            {
                $version.Editing.BeginEdit();
                $version.Locking.Unlock();
                $version.Editing.EndEdit();
                Write-Host "Item un-locked:" $item.ID $version.Language;
            }
        }
    }
}
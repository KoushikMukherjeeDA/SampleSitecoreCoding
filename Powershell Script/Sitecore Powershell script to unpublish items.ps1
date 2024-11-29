$sourcePath = "/sitecore/content/Site1/Home"
function RunScript
{
    $items = Get-ChildItem -Path $sourcePath -Recurse
    $rootItem = Get-Item -Path $sourcePath
    $items = $items + $rootItem

    foreach ($item in $items)
    {
        if($item.Fields["__Never publish"].Value -ne 1)
        {
            $item.Editing.BeginEdit();
            $item.Fields["__Never publish"].Value = "1";
            $item.Editing.EndEdit();
        
            Publish-Item $item -Target "web" -PublishMode SingleItem 

            Write-Host "option:" $item.Fields["__Never publish"].Value
        
        }
    }
}

$items = RunScript
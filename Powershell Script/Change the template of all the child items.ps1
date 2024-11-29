$path="/sitecore/content/Home/Sample Item1"
$items = Get-ChildItem -path "$($path)"

foreach($item in $items)
    {
        if ($item.TemplateId -eq "{Current Template ID}")
        {
            $item.Editing.BeginEdit();
            $item.TemplateId = "{New Template ID}"
            $item.Editing.EndEdit();
            Write-Host "Item id: " $item.ID " - Template id: " $item.TemplateId
        }
    }
$items
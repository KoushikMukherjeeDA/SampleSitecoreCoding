Get-ChildItem master:\Content -Recurse | 
Where-Object { $_._Updated -gt [datetime]::Now.AddDays(-{days}) } | 
Format-Table -property DisplayName, "__Updated", "__Updated By", {$.Paths.Path}
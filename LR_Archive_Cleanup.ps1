#LogRhythm Archive Clenaup

trap [Exception] 
{
	write-error $("Exception: " + $_)
	exit 1
}

#Archive Path
$Path = "D:\LogRhythmArchives\Inactive"

#Log File
$LogFile = "D:\LogRhythm\ArchiveCleanup.log"

#Number of days to keep
$Days = 3 * -365

$LastDay = (Get-Date).AddDays($Days)

$Today = (Get-Date)

$Archives = Get-ChildItem -Path $Path -Directory
foreach ($Archive in $Archives)
{
    #Write-Host ($Archive.BaseName).Substring(4,2)"/"($Archive.BaseName).Substring(6,2)
    $ArchDay = [DateTime](($Archive.BaseName).Substring(0,4)+"/"+($Archive.BaseName).Substring(4,2)+"/"+($Archive.BaseName).Substring(6,2))
    if ($ArchDay -lt $LastDay)
    {
        Remove-Item -Path $Archive.FullName -Recurse -Force
        "Archive Folder " + $Archive.BaseName + " Deleted" | Out-File -FilePath $LogFile -Append -Force 
    }
}
exit 0

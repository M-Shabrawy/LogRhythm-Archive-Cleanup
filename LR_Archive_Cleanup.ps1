#LogRhythm Archive Clenaup

param(
    #Inactive Archive Path
    [string]$Path,
    [int]$Years = 3,
    [bool]$Test = $false
)

trap [Exception] 
{
	write-error $("Exception: " + $_)
	exit 1
}

if ($Path -eq "")
{
    $Path = "D:\LogRhythmArchives\Inactive"
}

#Log File
$LogFile = "D:\LogRhythmArchives\ArchiveCleanup.log"

#Number of days to keep
$Days = $Years * -365

$LastDay = (Get-Date).AddDays($Days).ToString("yyyMMdd")

$Archives = Get-ChildItem -Path $Path -Directory -Recurse -Depth 1 | Where-Object{ $_.Name -Match "\d{6}_\d+_\d+.*"}
foreach ($Archive in $Archives)
{
    $ArchDay = ($Archive.BaseName).Substring(0,8)
    if ($ArchDay -lt $LastDay)
    {
        if ($Test)
        {
            Write-Host "Archive Folder " + $Archive.BaseName + " will be deleted"
        }
        else
        {
           Remove-Item -Path $Archive.FullName -Recurse -Force
           "Archive Folder " + $Archive.BaseName + " Deleted" | Out-File -FilePath $LogFile -Append -Force
        }
    }
}
exit 0

<#
.Synopsis
   copy-wsusapprovedpatches
.DESCRIPTION
   Copies the Approved Patches from source target group to target WSUS Group.

.EXAMPLE
   copy-wsusapprovedpatches "source_group_name" "target_group_name"
.EXAMPLE
   copy-wsusapprovedpatches "source_group_name" "target_group_name" "<wsus_FQDN(default is localhost)>" "<WSUS Port(Default is 80)>"
#>
[CmdletBinding()]
[Alias()]
[OutputType([int])]
Param
(
        
    [Parameter(Mandatory=$true,
                ValueFromPipelineByPropertyName=$true,
                Position=0)]
    $WsusSourceGroup,

    [Parameter(Mandatory=$true,
                ValueFromPipelineByPropertyName=$true,
                Position=1)]
    $WsusTargetGroup,
    [Parameter(Mandatory=$true,
                ValueFromPipelineByPropertyName=$true,
                Position=2)]
    $WsusServerFqdn='localhost',
    [Parameter(Mandatory=$true,
                ValueFromPipelineByPropertyName=$true,
                Position=3)]
    $WsusServerPort = "80"


)

    

[void][reflection.assembly]::LoadWithPartialName( “Microsoft.UpdateServices.Administration”)
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer( $WsusServerFqdn, $False, $WsusServerPort)
$Groups = $wsus.GetComputerTargetGroups()
$WsusSourceGroupObj = $Groups | Where {$_.Name -eq $WsusSourceGroup}
$WsusTargetGroupObj = $Groups | Where {$_.Name -eq $WsusTargetGroup}

$Updates = $wsus.GetUpdates()
$i = 0
ForEach ($Update in $Updates)
{
    if ($Update.GetUpdateApprovals($WsusSourceGroupObj).Count -ne 0 -and $Update.GetUpdateApprovals($WsusTargetGroupObj).Count -eq 0)
    {
        $i ++
        Write-Host (“Approving ” + $Update.Title)
        $Update.Approve(‘Install’,$WsusTargetGroupObj) | Out-Null
    }
}
Write-Output (“Approved {0} updates for target group {1}” -f $i, $WsusTargetGroup)







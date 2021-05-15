##Approves the patches which matches the search criteria



$wsus_server = "localhost"
$criteria = 'Windows Server 2019'
$target_group = "group_a"
[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")

$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer($wsus_server,$False)

$update = $wsus.SearchUpdates($criteria)

$group = $wsus.GetComputerTargetGroups() | where {$_.Name -eq $target_group}

$update.ApproveForOptionalInstall($Group)
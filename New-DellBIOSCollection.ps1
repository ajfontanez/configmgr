Import-Module "$($env:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"

$SiteCode = "SMS"
$IncludeCollection = "Clients Eligible for BIOS Updates"
$Models = @(
	"OptiPlex 9010",
	"OptiPlex 9020",
	"OptiPlex 7040"
)

Set-Location "$($SiteCode):"

$Schedule = New-CMSchedule -RecurInterval Days -RecurCount 1

foreach ($Model in $Models) {
    New-CMDeviceCollection -Name "BIOS Update - $Model" -LimitingCollectionName $Model -RefreshSchedule $Schedule -RefreshType Periodic
    Get-CMDeviceCollection -Name "BIOS Update - $Model" | Move-CMObject -FolderPath "$($SiteCode):\DeviceCollection\BIOS"
    Add-CMDeviceCollectionIncludeMembershipRule -CollectionName "BIOS Update - $Model" -IncludeCollectionName $IncludeCollection
}
# This script is used to contain a list of hostnames found in Crowdstrike
# Fill in the API credentials authorised to use the Crowdstrike API 
# Requires to install PSFalcon module with the command <Install-Module -Name PSFalcon -Scope CurrentUser>

$creduser = read-host "CS User ID: "
$credpass = read-host "CS User Password: "

#Request Falcon Token from the API key
Request-FalconToken -ClientID $creduser -ClientSecret $credpass -Cloud eu-1

$import_csv = read-host "Hosts Input CSV: "
$date_exec  = (Get-Date).tostring("dd-MM-yyyy_hh-mm-ss")
$export_csv = $import_csv+"_"+$date_exec+".csv"

$workstationInfo = @()

Write-Host ("Import CSV.")
$W_List = Import-Csv -Path $import_csv

Write-Host ("Query CS API.")
foreach ($workstationl in $W_List) {
    $workstation = $workstationl.workstation
    $HostID=Get-FalconHost -Filter "hostname:['$workstation']" -Detailed
    #Write-Host ($HostID)
    if ($HostID -ne $null){
        $tag=(Get-FalconHost -Filter "hostname:['$workstation']" | Get-FalconSensorTag)
        $tag2=$tag.tags
        #Write-Host ($workstation+","+$HostID.Status+","+$HostID.product_type_desc+","+$HostID.serial_number+","+$tag2)
        $workstationInfo += [PSCustomObject]@{
            id=$HostID.device_id
            hostname=$workstation
            domain=$HostID.machine_domain
            ou=$HostID.ou
            local_ip=$HostID.local_ip
            external_ip=$HostID.external_ip
            cs_version=$HostID.agent_version
            status=$HostID.status
            last_seen=$HostID.last_seen
            os=$HostID.os_product_name
            entity=$tag2
            serial=$HostID.serial_number
            last_login=$HostID.last_login_user
            }
    }    
}
Write-Host "Export CSV."
$workstationInfo | Export-Csv -NoTypeInformation -Path $export_csv -delimiter ',' -Encoding UTF8 -Force;
Write-Host "View exported CSV."
Import-Csv $export_csv | Out-GridView

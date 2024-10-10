##########################################################################################################################################################
# Author      : @jomivz
# Date        : 10/10/2024
# Description : 
# This script reads UPNs and passwords from an input csv file and check if the passwords are valid.
# Search available for all domains.If a domain search is not needed please temporarily remove it from the $servers list
# 
# Pre- requisite:
#	- Create a CSV file with the exact header in two separate columns (email, password)
#	- Under the header copy-paste all the UPNs and password to test 
# 	- The RSAT module is required to run the script (link : https://docs.microsoft.com/en-us/troubleshoot/windows-server/system-management-components/remote-server-administration-tools)
#
##########################################################################################################################################################


# define where is the export and import filesand clean up previous file results
$importCSV = read-host "CSV with Creds to test: "
$exportCSV = (Get-Location).Path + "\" + $importCSV + "_output_" + (Get-Date).tostring("dd-MM-yyyy_hh-mm-ss") + ".csv"

$validity="True"


# find user in the AD
$usersList = Import-Csv -Path $importCSV –Delimiter “;”
$usersInfo = @()

# replace the domain and allows to check if that is the case.
$ztarg_dom = Read-Host "domain to test: "

foreach ($userFromList in $usersList) {
    $auth="False"
    
    $userUpn = $userFromList.email.Split("@")[0]+"@"+$ztarg_dom    
    $userPassword=$userFromList.password

    Write-Host "$($userUpn):$($userPassword)"
    # check the password matches the AD password policy.
    # if TRUE
   
    ##########################################################################################################################################################
    # CHECKING PASSWORD COMPLIANCE WITH THE AD POLICY
    ##########################################################################################################################################################

    $validity="NULL"
    $count = $userPassword.Length
    if ($count -gt 7) {

        $regex = "[^a-zA-Z0-9]" #check for special characters
        $validity = ""
        If ($userPassword –cmatch $regex) {
          $validity= "true"
        }

        $regex1 = "[a-z]" #check for lower characters
        If ($userPassword –cmatch $regex1) {
          $validity= $validity + "true"
        }

        $regex2 = "[A-Z]" #check for upper characters
        If ($userPassword –cmatch $regex2) {
          $validity=  $validity + "true"
        }


        $regex3 = "[0-9]" #check for numbers
        If ($userPassword –cmatch $regex3) {
           $validity= $validity + "true"
        }
    
        #check if at least 3 on 4 conditions are matched
        $total=([regex]::Matches($validity, "true" )).count
        if ($total -le 2){
            $validity="False"
        }
        else {
            $validity="True"
        }
    }
     else {
            $validity="False"
        }
    
    # password is not compliant to policy
    if ($validity -eq "False"){
        Write-Host " + Password compliant with Policy : FALSE" -ForegroundColor yellow
        $usersInfo += [PSCustomObject]@{
            SamAccountName = "NULL"
            UPN = $userUpn
            PasswordLastSet="NULL"
            Enabled = "NULL"
            Password=$userPassword
            PwdCompliance="FALSE"
        }
    }

    ##########################################################################################################################################################
    # TESTING ACCOUNT CREDS
    ##########################################################################################################################################################
    if ($validity -eq "True"){
        $user = "NULL"
        Write-Host " + Password compliant with Policy : TRUE"
                
        # test the user account exists with status enabled 
        $doms = (get-adforest).Domains
        $dom  = "NULL"
        $isFound="false"

        foreach($dom in $doms) {
            $user = Get-ADUser -Properties * -Filter ('UserPrincipalName -like "' + $userUpn + '" -and ObjectClass -eq "User"') -Server $dom
            If ($user -ne $null){

                If (($user.Enabled -eq $True)) {
                    Write-Host " + Account Status: enabled." -ForegroundColor yellow
                    Write-Host " + Domain: $dom " -ForegroundColor yellow
                    $testUsercred=$user.DistinguishedName.split(",")[-3].split("=")[1]+"."+$user.DistinguishedName.split(",")[-2].split("=")[1]+"."+$user.DistinguishedName.split(",")[-1].split("=")[1]+"\"+$user.SamAccountName
                    $userPasswordc = ConvertTo-SecureString -String $userPassword -AsPlainText -Force
                    $plaintext = (New-Object System.Management.Automation.PSCredential('N/A',$userPasswordc)).GetNetworkCredential().Password
                    $CurrentDomain = "LDAP://" + ([ADSI]"").distinguishedName
                    $domain = New-Object System.DirectoryServices.DirectoryEntry($CurrentDomain,$testUsercred,$plaintext)

                    If ($domain.name -eq $null){
                        write-host " + Authentication failed with password: "$($userPassword)"" -ForegroundColor yellow
                        $usersInfo+=[PSCustomObject]@{
                        SamAccountName=$user.SamAccountName
                        UPN=$userUpn
                        PasswordLastSet=$user.passwordlastset
                        Password=$userPassword
                        PwdCompliance="true"
                        Status="enabled"
                        Authentication="failed"
                        Dom=$dom}
                    }

                    Else{
                        write-host " + Authentication successful with password: "$($userPassword)"" -ForegroundColor green 
                        $usersInfo+=[PSCustomObject]@{
                        SamAccountName=$user.SamAccountName
                        UPN=$userUpn
                        PasswordLastSet=$user.passwordlastset
                        Password=$userPassword
                        PwdCompliance="true"
                        Status="enabled" 
                        Authentication="success"
                        Dom=$dom}
                    }
                }
                ElseIf (($user.Enabled -eq $False)) {
                    Write-Host " + Account status: disabled." -ForegroundColor yellow
                    Write-Host " + Domain: $dom " -ForegroundColor yellow
                    $usersInfo += [PSCustomObject]@{
                        SamAccountName=$user.SamAccountName
                        UPN=$userUpn
                        PasswordLastSet="NULL"
                        Password=$userPassword
                        PwdCompliance="true"
                        Status="disabled"
                        Authentication="failed"
                        Dom=$dom}
                }
                $isFound="true"
                Break
            }
        }

        If ($isFound -eq "false") {
            Write-Host " + Account not found in the forest." -ForegroundColor yellow
            $usersInfo += [PSCustomObject]@{
                SamAccountName="NULL"
                UPN=$userUpn
                PasswordLastSet="NULL"
                Password=$userPassword
                PwdCompliance="true"
                Status="not_found"
                Authentication="failed"
                Dom="NULL"
            }
            Break
       
        }
    }
}

Write-Host "Export CSV"
$usersInfo | Export-Csv -NoTypeInformation -Path $exportCSV
$xl = new-object -comobject excel.application
$xl.visible = $true
$Workbook = $xl.workbooks.open($exportCSV)
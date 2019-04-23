function Connect-sbSPOnline {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganisationName
    )

    # Checking for SPOnline module and installing if necessary
    $spomodule = Get-Module -Name Microsoft.Online.SharePoint.PowerShell -ListAvailable
    if (-not $spomodule ) {
        Write-Verbose 'Sharepoint Online Powershell Module not found.'
        Write-Verbose 'Installing...'
        Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force
    }

    Connect-SPOService -Url https://$OrganisationName-admin.sharepoint.com
}

function Get-sbSPSiteGroups {
    [cmdletbinding()]
    param(
        [parameter(Mandatory = $true)]
        [string]$OrganisationName,
        [parameter(Mandatory = $true)]
        [string]$SiteName
    )

    Begin { }

    Process {
        $siteURL = "https://$OrganisationName.sharepoint.com/sites/$SiteName"
        $spositegroup = Get-SPOSiteGroup -Site $siteURL
        foreach ($group in $spositegroup) {
            if ($group.Users) {
                [PSCustomObject]@{
                    'GroupName'    = $group.LoginName
                    'GroupMembers' = $group.Users
                }
            } #if group has users
        } #foreach
    } #process

    End { }

} #function
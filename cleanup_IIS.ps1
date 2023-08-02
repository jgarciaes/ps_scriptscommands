# List of site names
$SiteNames = "site1", "site2", "site3", "site4"

# Loop through each site
foreach ($SiteName in $SiteNames) {
    # Stop the site if it's running
    Stop-Website -Name $SiteName

    # Remove the site
    Remove-Website -Name $SiteName

    # Remove the application pool
    Remove-WebAppPool -Name $SiteName

    # Define the paths
    $PhysicalPathE = "E:\$SiteName"
    $PhysicalPathD = "D:\$SiteName"

    # Delete folders
    Remove-Item -Path $PhysicalPathC -Recurse -Force
    Remove-Item -Path $PhysicalPathD -Recurse -Force

    Write-Host "Site $SiteName and associated folders deleted."
}

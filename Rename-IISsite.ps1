# Step 1: Open PowerShell as an administrator.

# Step 2: Define the list of current and new names for the websites
$SitesToRename = @{
    "CurrentSiteName1" = "NewSiteName1"
    "CurrentSiteName2" = "NewSiteName2"
    # Add more websites as needed
}

# Step 3: Execute the renaming process for each website
$appcmd = "$Env:SystemRoot\system32\inetsrv\appcmd.exe"

foreach ($oldSiteName in $SitesToRename.Keys) {
    $newSiteName = $SitesToRename[$oldSiteName]
    & $appcmd set site "$oldSiteName" -name:"$newSiteName"
    Write-Host "The website has been successfully renamed from '$oldSiteName' to '$newSiteName'."
}

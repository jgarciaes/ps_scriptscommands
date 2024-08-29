# Run this script in an elevated PowerShell session (Run as Administrator)

# Import the WebAdministration module
Import-Module WebAdministration

# Define the pattern to match site names (e.g., sites containing "UAT")
$pattern = "Compliance - QA"

# Get all site names matching the pattern
$siteNames = Get-Website | Where-Object { $_.Name -like "*$pattern*" } | Select-Object -ExpandProperty Name


# Define the custom header details
$headerName = "Access-Control-Allow-Origin"
$headerValue = "*"

# Loop through each site and add the custom header
foreach ($siteName in $siteNames) {
    # Construct the path to the custom headers
    $customHeadersPath = "MACHINE/WEBROOT/APPHOST/$siteName"
    
    # Check if the header already exists
    $existingHeaders = Get-WebConfigurationProperty -pspath $customHeadersPath -filter "system.webServer/httpProtocol/customHeaders" -name "Collection"
    
    # Check if the header is already present
    $headerExists = $false
    foreach ($header in $existingHeaders) {
        if ($header.name -eq $headerName) {
            $headerExists = $true
            break
        }
    }
    
    # Add the header if it does not exist
    if (-not $headerExists) {
        Add-WebConfigurationProperty -pspath $customHeadersPath -filter "system.webServer/httpProtocol/customHeaders" -name "Collection" -value @{name=$headerName; value=$headerValue}
        Write-Output "Added custom header '${headerName}: ${headerValue}' to site '${siteName}'."
    } else {
        Write-Output "Custom header '${headerName}: ${headerValue}' already exists for site '${siteName}'."
    }
}

# Run this script in an elevated PowerShell session (Run as Administrator)

# Import the WebAdministration module
Import-Module WebAdministration

# Define the pattern to match site names (e.g., sites containing "AOB - UAT")
$pattern = "Compliance - QA"

# Define the base hostname
$baseHostname = "qa"

# Define the domain suffix
$domainSuffix = "backoffice.riaenvia.net"  # Replace with your domain suffix

# Get all site names matching the pattern
$siteNames = Get-Website | Where-Object { $_.Name -like "*$pattern*" } | Select-Object -ExpandProperty Name


# Loop through each site to manage bindings
foreach ($siteName in $siteNames) {
    # Extract the number from the site name (assuming the format is "AOB - UAT{number}")
    if ($siteName -match "$pattern(\d{2})") {
        $siteNumber = $matches[1]
        
        # Construct the new hostname
        $newHostname = "${baseHostname}${siteNumber}-${domainSuffix}"

        # Get existing bindings for the site
        $bindings = Get-WebBinding -Name $siteName
        
        # Loop through each binding
        foreach ($binding in $bindings) {
            # Check if the binding protocol is HTTP or HTTPS
            if ($binding.protocol -eq "http" -or $binding.protocol -eq "https") {
                # Extract the port from the binding
                $port = $binding.bindingInformation.Split(":")[1]

                # Define the new binding information with the same port and new hostname
                $newBindingInformation = "*:${port}:${newHostname}"

                # Remove the old binding (need to specify exact binding information)
                $oldBinding = $binding.bindingInformation
                Remove-WebBinding -Name $siteName -IPAddress "*" -Port $port -Protocol $binding.protocol -HostHeader ($oldBinding -split ":")[2]

                # Add the new binding with the updated hostname
                New-WebBinding -Name $siteName -IPAddress "*" -Port $port -Protocol $binding.protocol -HostHeader $newHostname

                Write-Output "Updated binding for site '${siteName}' with hostname '${newHostname}' on port ${port}."
            }
        }
    } else {
        Write-Output "Site name '${siteName}' does not match the expected pattern."
    }
}

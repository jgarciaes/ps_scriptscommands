# Run this script in an elevated PowerShell session (Run as Administrator)

# Import the necessary module
Import-Module WebAdministration

# Define the pattern to match site names (e.g., sites containing "UAT")
$sitePattern = "Ria Back Office Login - QA"

# Define the pattern to match URL rewrite rules (e.g., rules containing "Agents")
$rewritePattern = "Compliance"

# Get all site names matching the pattern
$siteNames = Get-Website | Where-Object { $_.Name -like "*$sitePattern*" } | Select-Object -ExpandProperty Name

# Loop through each site
foreach ($siteName in $siteNames) {
    Write-Output "Processing site: $siteName"
    
    # Get the physical path of the site
    $sitePath = (Get-Item "IIS:\Sites\$siteName").physicalPath
    
    # Path to the web.config file
    $webConfigPath = Join-Path -Path $sitePath -ChildPath "web.config"

    if (Test-Path -Path $webConfigPath) {
        Write-Output "Found web.config at: $webConfigPath"

        # Load the XML of the web.config file
        [xml]$webConfigXml = Get-Content -Path $webConfigPath

        # Get the URL rewrite section
        $rewriteSection = $webConfigXml.configuration.'system.webServer'.rewrite

        if ($rewriteSection) {
            # Get all rewrite rules
            $rules = $rewriteSection.rules.rule

            if ($rules) {
                foreach ($rule in $rules) {
                    if ($rule.name -like "*$rewritePattern*") {
                        Write-Output "Removing rewrite rule '${rule.name}' from web.config."

                        # Remove the matching rule
                        $rule.ParentNode.RemoveChild($rule) | Out-Null
                    }
                }

                # Save changes if any rule was removed
                if ($rules.Count -ne ($rewriteSection.rules.rule.Count)) {
                    $webConfigXml.Save($webConfigPath)
                    Write-Output "Updated web.config file."
                }
            }
        }

        # Get the HTTP Redirect section
        $httpRedirectSection = $webConfigXml.configuration.'system.webServer'.httpRedirect

        if ($httpRedirectSection) {
            # Check if the redirect matches the pattern
            if ($httpRedirectSection.redirectMode -like "*$rewritePattern*") {
                Write-Output "Removing redirect settings from web.config."

                # Remove the redirect settings
                $httpRedirectSection.ParentNode.RemoveChild($httpRedirectSection) | Out-Null

                # Save changes
                $webConfigXml.Save($webConfigPath)
                Write-Output "Updated web.config file."
            }
        }
    } else {
        Write-Output "No web.config file found at: $webConfigPath"
    }
}

Write-Output "URL rewrite rules and redirects removal process completed."

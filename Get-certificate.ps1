# Define your variables
$Keyword = ""   # Set this to your search term (for Subject, Issuer, or Thumbprint)
$Path = ""                             # Leave empty to use the default path

# Set default path if $Path is empty
if ([string]::IsNullOrWhiteSpace($Path)) {
    $Path = "Cert:\LocalMachine\*"
}

# Search certificates based on Keyword and Path
Get-ChildItem -Path $Path -Recurse | 
Where-Object { 
    $_ -is [System.Security.Cryptography.X509Certificates.X509Certificate2] -and 
    (
        ($_.Subject -like "*$Keyword*" -or $_.Issuer -like "*$Keyword*") -or 
        ($_.Thumbprint -eq $Keyword)
    )
} | 
Select-Object Thumbprint, 
              @{Name="Name";Expression={$_.Subject -replace '^.*?CN=([^,]+).*', '$1'}}, 
              NotAfter, 
              @{Name="StorePath";Expression={$_.PSParentPath}}

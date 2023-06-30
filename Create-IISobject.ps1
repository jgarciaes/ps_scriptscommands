Import-Module WebAdministration


# Variables
$nombreSitio = "test6"
$puerto = 80
$rutaFisica = "C:\Sites\$($nombreSitio)"
$nombreAppPool = $nombreSitio
$header = "test.com"
$protocol = "http"
$certificate = ""




# Validar si el pool de aplicaciones existe, de lo contrario, crearlo
if (-not (Get-IISAppPool -Name $nombreAppPool -ErrorAction SilentlyContinue)) {
    New-WebAppPool -Name $nombreAppPool
} else {
    Write-Host "El pool de aplicaciones $nombreAppPool ya existe. No se creará nuevamente."
}



# Validar si el sitio web existe, de lo contrario, crearlo
if (-not (Get-Website -Name $nombreSitio -ErrorAction SilentlyContinue)) {
    # Validar si la ruta física existe, de lo contrario, crearla
    if (-not (Test-Path $rutaFisica -PathType Container)) {
        New-Item -Path $rutaFisica -ItemType Directory | Out-Null
    }



    # Crear el sitio web
    New-WebSite -Name $nombreSitio -PhysicalPath $rutaFisica -Port $puerto -ApplicationPool $nombreAppPool -HostHeader $header



        # Crear el binding HTTP
     if ($certificate -ne ""){
            $bindingInfo = "*:$($puerto):$nombreSitio"
            New-WebBinding -Name $nombreSitio -Protocol $protocol -Port $puerto -HostHeader $header
            (Get-WebBinding -Name $nombreSitio -Port $puerto -Protocol $protocol).AddSslCertificate($certificate, "my")
        }
} else {
    Write-Host "El sitio web $nombreSitio ya existe. No se creará nuevamente."
}



# Mostrar información del sitio web
Get-Website $nombreSitio


# Imagen base
FROM mcr.microsoft.com/powershell:latest

# Copiar los scripts de PowerShell al contenedor
COPY ps_scriptscommands /scripts

# Establecer el directorio de trabajo
WORKDIR /scripts

# Comando de inicio
CMD ["pwsh", "-File", "script1.ps1"]

# Imagen base
FROM mcr.microsoft.com/powershell:latest

# Copiar los scripts de PowerShell al contenedor
COPY . /scripts

# Establecer el directorio de trabajo
WORKDIR /scripts

# Comando de inicio (se puede ajustar según tus necesidades)
CMD ["ls"]

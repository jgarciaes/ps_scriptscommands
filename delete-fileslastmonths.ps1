# old XML files deletion
Get-ChildItem -Path "" -Recurse -Filter *.xml | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-90) } | Remove-Item -Force

# Empty folder deletion
$folders = Get-ChildItem -Path "" -Recurse -Directory | Sort-Object FullName -Descending

foreach ($folder in $folders) {
    Remove-Item -Path $folder.FullName -Force -ErrorAction SilentlyContinue
}

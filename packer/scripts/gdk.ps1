
<# >Description
downloading Microsoft GDK repo package
#>

$sb= Start-Job -ScriptBlock {
New-Item -ItemType "directory" -Path "$env:PUBLIC\gdk"
Set-Location -Path "$env:PUBLIC\gdk"
$pkg="GDK-Man.zip"
$pkglink="https://github.com/microsoft/GDK/archive/refs/heads/Main.zip"
Invoke-WebRequest -Uri (Get-Variable -Name ("pkglink")).value -OutFile (Get-Variable -Name ("pkg")).value }
Wait-Job $sb.Name 
Write-Output "Microsoft GDK package download is now completed .... "

<# >Description
installing GDK repo package into the designated folder
#>
$sb= Start-Job -ScriptBlock { 
Set-Location -Path "$env:PUBLIC\gdk"
Expand-Archive -LiteralPath GDK-Man.zip -DestinationPath 'C:\Program Files' }  
Wait-Job $sb.Name 
Write-Output "Microsoft GDK package repo installation job is now completed .... "

<# >Description
installing Microsoft GDK from repo folder
#>
$sb= Start-Job -ScriptBlock { 
Start-Process -Wait -ArgumentList "/silent" -PassThru -FilePath 'C:\Program Files\GDK-Main\PGDK.exe' }  
Wait-Job $sb.Name 
Write-Output "Microsoft GDK installation job is now completed .... "

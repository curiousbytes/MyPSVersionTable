[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

<#------------------------------Prompt------------------------------#>
$TimeOnly = (Get-Date).ToShortTimeString()
$SetLocation = Set-Location 'C:\'

function prompt {
	$SetLocation
	Write-Host "[michalis $TimeOnly $PWD]> " -NoNewline -ForegroundColor Yellow
    return " "
}

<#-----------------------------PSVersionTable---------------------------#>

$ComputerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
$OperatingSystem = Get-CimInstance -ClassName Win32_OperatingSystem
$CPU = (Get-CimInstance -ClassName Win32_Processor).name
$PhysicalDisk = Get-PhysicalDisk | Where-Object {$_.mediatype -eq "SSD"} | Select-Object @{l="FriendlyName";e={$_.FriendlyName}}, @{l="Size";e={[math]::Round($_.size / 1gb, 2)}}
$dateTime = (get-date).ToShortDateString()
$MyHost = hostname.exe
$PSVersion = Get-Host
$BIOS = Get-CimInstance Win32_Bios
$WinBuild = Get-ChildItem \WINDOWS\system32\hal.dll
$PwshVersion = $(Get-ChildItem 'C:\Program Files\PowerShell\7\pwsh.exe').VersionInfo.ProductVersionRaw

$myPSVersionTable = [ordered]@{
  "Hostname" = $MyHost
  "Current Date" = $dateTime
  "Notebook Model" = $ComputerSystem.model+ " " +"(SN:"+ $BIOS.SerialNumber+")"
  "BIOS Version" = $BIOS.Name + " " + "(Released: "+($BIOS.ReleaseDate.ToShortDateString())+")"
  "Windows Version" = $OperatingSystem.caption + " " + "(OS Build "+ $WinBuild.VersionInfo.ProductVersion.Replace("10.0.","")+")"
  "PowerShell 5 Version" = $PSVersion.Version
  "PowerShell 7 Version" = $PwshVersion
  "CPU" = $CPU
  "Physical Memory (GB)" = $null + ([math]::Round($ComputerSystem.TotalPhysicalMemory / 1gb, 2))
  "SSD" = $PhysicalDisk.FriendlyName+ " "+"(Size: " + $PhysicalDisk.size+"GB)"
}

Set-PoshPrompt -Theme negligible
Import-Module Terminal-Icons

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
<#-----------------------------Get-PSReadlineOption------------------------#>
#Set-PSReadlineOption -TokenKind String -ForegroundColor Magenta

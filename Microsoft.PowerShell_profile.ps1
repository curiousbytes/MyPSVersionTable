# PS 5.1 PROFILE

# [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

<#------------------------------Prompt------------------------------#>
$Setlocation = Set-Location 'C:\'

<#-----------------------------PSVersionTable-----------------------#>
$LocalCimSession = New-CimSession -ComputerName localhost

$cs = Get-CimInstance -CimSession $LocalCimSession -ClassName Win32_ComputerSystem
$csMemory = Get-CimInstance -CimSession $LocalCimSession -ClassName Win32_ComputerSystem |  Select-Object @{l = 'Memory'; e = { [math]::round($_.TotalPhysicalMemory / 1gb, 2) } }
$os = Get-CimInstance -CimSession $LocalCimSession -ClassName Win32_OperatingSystem
$CPU = (Get-CimInstance -CimSession $LocalCimSession -ClassName Win32_Processor).name
$DiskModel = (Get-CimInstance -CimSession $LocalCimSession win32_DiskDrive).Model
$DiskSize = Get-CimInstance -cimsession $LocalCimSession Win32_LogicalDisk | Select-Object @{l = "Size"; e = { [math]::Round($_.size / 1gb, 2) } }
$dateTime = ([datetime]::Now).ToShortdateString()
$MyHost = hostname.exe
$PSVersion = Get-Host
$BIOS = Get-CimInstance -cimsession $LocalCimSession Win32_Bios
$WinBuild = [System.Diagnostics.FileVersionInfo]::GetVersionInfo('\WINDOWS\system32\hal.dll').productversion.Replace("10.0.", "")
$PwshVersion = $(Get-ChildItem 'C:\Program Files\PowerShell\7\pwsh.exe').VersionInfo.ProductVersionRaw

$myPSVersionTable = [ordered]@{
  "Hostname"             = $MyHost
  "Date"                 = $dateTime
  "Notebook Model"       = $cs.model + " " + "(SN:" + $BIOS.SerialNumber + ")"
  "BIOS Version"         = $BIOS.Name + " " + "(Released: " + ($BIOS.ReleaseDate.ToShortDateString()) + ")"
  "Windows Version"      = $os.caption + " " + "(Build: $WinBuild)"
  "PowerShell 5 Version" = $PSVersion.Version
  "PowerShell 7 Version" = $PwshVersion
  "CPU"                  = $CPU
  "Physical Memory (GB)" = $csMemory.Memory
  "SSD"                  = $DiskModel + " " + "(Size: " + $DiskSize.size + "GB)"
}

Set-PoshPrompt -Theme negligible
Import-Module Terminal-Icons


<#-----------------------------Old entries removed-----------------------#>

#$weather = (curl http://wttr.in/athens?0 -UserAgent "curl").Content | ConvertFrom-String
#$pd = Get-PhysicalDisk | Where-Object {$_.mediatype -eq "SSD"} | Select-Object @{l="FriendlyName";e={$_.FriendlyName}}, @{l="Size";e={[math]::Round($_.size / 1gb, 2)}}
#$dateTime = (get-date).ToShortDateString()
#$DiskSize = Get-CimInstance -cimsession $LocalCimSession Win32_LogicalDisk | Select-Object @{l='Drive';e={$_.DeviceID}}, @{l="Name";e={$_.VolumeName}}, @{l="Size";e={[math]::Round($_.size / 1gb, 2)}}
#$WinBuild = Get-ChildItem \WINDOWS\system32\hal.dll

<#-----------------------------Chocolatey profile-----------------------#>

$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
<#-----------------------------Get-PSReadlineOption------------------------#>
#Set-PSReadlineOption -TokenKind String -ForegroundColor Magenta

<#-----------------------------Weather-------------------------------------#>
#(curl http://wttr.in/athens?0 -UserAgent "curl").Content
#$weather = Invoke-WebRequest -UserAgent 'curl' -uri "http://wttr.in/athens?0" | select -expandproperty content
#$weather.Content
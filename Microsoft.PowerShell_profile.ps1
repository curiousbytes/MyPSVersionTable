[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

<#------------------------------Prompt------------------------------#>
$TimeOnly = (Get-Date).ToShortTimeString()
$Setlocation = Set-Location 'C:\'

function prompt {
	$Setlocation
	Write-Host "[michalis $TimeOnly $PWD]> " -NoNewline -ForegroundColor Yellow
    return " "
}

#$CmdExecTime = ((Get-History)[-1].EndExecutionTime - (Get-History)[-1].StartExecutionTime).TotalSeconds
#$ReduceValuetoInt = [math]::Round($CmdExecTime, 2)

<#-----------------------------PSVersionTable---------------------------#>

$cs = Get-CimInstance -ClassName Win32_ComputerSystem
$os = Get-CimInstance -ClassName Win32_OperatingSystem
$CPU = (Get-CimInstance -ClassName Win32_Processor).name
$pd = Get-PhysicalDisk | ? {$_.mediatype -eq "SSD"} | select @{l="FriendlyName";e={$_.FriendlyName}}, @{l="Size";e={[math]::Round($_.size / 1gb, 2)}}
$dateTime = (get-date).ToShortDateString()
$weather = (curl http://wttr.in/athens?0 -UserAgent "curl").Content | ConvertFrom-String
$MyHost = hostname.exe
$PSVersion = Get-Host
$BIOS = Get-CimInstance Win32_Bios
$WinBuild = Get-ChildItem \WINDOWS\system32\hal.dll
$PwshVersion = $(Get-ChildItem 'C:\Program Files\PowerShell\7\pwsh.exe').VersionInfo.ProductVersionRaw

$myPSVersionTable = [ordered]@{
  "Hostname" = $MyHost
  "Current Date" = $dateTime
  "Temperature in Athens" = $weather.P12+$weather.P13
  "Notebook Model" = $cs.model+ " " +"(SN:"+ $BIOS.SerialNumber+")"
  "BIOS Version" = $BIOS.Name + " " + "(Released: "+($BIOS.ReleaseDate.ToShortDateString())+")"
  "Windows Version" = $os.caption + " " + "(OS Build "+ $WinBuild.VersionInfo.ProductVersion.Replace("10.0.","")+")"
  "PowerShell 5 Version" = $PSVersion.Version
  "PowerShell 7 Version" = $PwshVersion
  "CPU" = $CPU
  "Physical Memory (GB)" = $null + ([math]::Round($cs.TotalPhysicalMemory / 1gb, 2))
  "SSD" = $pd.FriendlyName+ " "+"(Size: " + $pd.size+"GB)"
}

Set-PoshPrompt -Theme negligible
Import-Module Terminal-Icons


<# the old one
$OS = Get-CimInstance Win32_OperatingSystem
$BIOS = Get-CimInstance Win32_Bios
$PSVersionTable.Remove("BuildVersion")
$PSVersionTable.Remove("PSEdition")
$PSVersionTable.Remove("PSCompatibleVersions")
$PSVersionTable.Remove("CLRVersion")
$PSVersionTable.Remove("WSManStackVersion")
$PSVersionTable.Remove("PSRemotingProtocolVersion")
$PSVersionTable.Remove("SerializationVersion")
$PSVersionTable.Add("HostName", ($MyHost))
$PSVersionTable.Add("Operating System", ($OS.Caption))
$PSVersionTable.Add("Date & Time", (Get-Date))
$PSVersionTable.Add("BIOS Version", ($BIOS.Name))
$PSVersionTable.Add("Manufacturer", ($BIOS.Manufacturer))
$PSVersionTable.Add("PWSH 6", ($PwshVersion))
#>

# Chocolatey profile
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

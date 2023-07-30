# Change FPS Here
$targetFPS = 240
# Override current ClientAppSettings
$override = $true

# Any additional ClientAppSettings changes:
$clientSettings = @{
	"DFIntTaskSchedulerTargetFps" = $targetFPS
}

# Script
Write-Host "Getting Roblox Versions..."

Get-ChildItem -Path "$ENV:LOCALAPPDATA\Roblox\Versions" -Attributes Directory |
Foreach-Object -Process {
	$FullName = $_.FullName
	Write-Host "Checking $FullName"
	
	$hasFolder = Get-ChildItem -Path $FullName -Attributes Directory -Filter "ClientSettings"
	
	if (!$hasFolder) {
		Write-Host "$FullName is missing ClientSettings... Creating."
		New-Item -ItemType Directory -Path $FullName -Name "ClientSettings"
	}
	
	$hasFile = Get-ChildItem -Path "$FullName/ClientSettings" -Filter "ClientAppSettings.json"
	
	if (!$hasFile -Or $override) {
		Write-Host "$FullName is missing ClientAppSettings.json... Creating."
		
		$Path = "$FullName/ClientSettings/ClientAppSettings.json"
		$Data = ConvertTo-Json $clientSettings
		$Options = New-Object System.Text.UTF8Encoding $False
		
		[System.IO.File]::WriteAllLines($Path, $Data, $Options)
	}
	
	Write-Host "$FullName Should Be FPS Unlocked (If not, check ClientAppSettings.json)."
}
Read-Host
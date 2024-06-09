# Clean Remnants from Past Executions
Remove-Item ./labs/*
Remove-Item ./tmp/*
Remove-Item ./Labs_Export.zip

# Create Necessary Directories
New-Item -Path "./" -Name "tmp" -ItemType "directory" -ErrorAction Ignore | Out-Null
New-Item -Path "./" -Name "labs" -ItemType "directory" -ErrorAction Ignore | Out-Null

# Retrieve source JSON
$labDefinitionJsonSource = "https://raw.githubusercontent.com/James-Burnham/docs/James-Burnham-patch-1/lod/quick-starts/cloud-slice/als-import.json"
$exportLabData = Invoke-RestMethod -Uri $labDefinitionJsonSource

# Define function to validate correct tenant
function aad-auth {
    try {
        $currentTenant = Get-AzureADTenantDetail
    } catch {
        Connect-AzureAD
        $currentTenant = Get-AzureADTenantDetail
    }
    
    "`n"
    "Current Tenant Information Below:"
    "Name: $($currentTenant.DisplayName)"
    "ID: $($currentTenant.ObjectId)"
    "`n"
    Write-Host -ForegroundColor Yellow 'Validate you are in the correct tenant according to the above information.'
    Write-Host -ForegroundColor Cyan -NoNewline 'If this is the correct tenant, press Enter. If it is the incorrect tenant, type "Cancel":'
    $confirmation = Read-Host 
    "`n"
    if ($confirmation -eq "Cancel") {
        $script:cancel = $true
        return
    }
}

# Define function to validate user-input
function Read-Input {
    param(
        [string]$Prompt = "Please enter something:",
        [ValidateSet("Integer", "FreeText", "Boolean", "Subpool", "Mode")]
        [string]$Type = "FreeText",
        [System.ConsoleColor]$Color = 'Cyan'
    )
    
    Write-Host -NoNewline -ForegroundColor $Color $Prompt

    switch ($Type) {
        "Integer" {
            while ($true) {
                $input = Read-Host
                try {
                    $int = [int]::Parse($input)
                    return $int
                } catch {
                    Write-Host "Invalid input. Please enter a valid integer." -ForegroundColor Red
                }
            }
        }
        "Boolean" {
            while ($true) {
                $input = Read-Host
                switch ($input) {
                    "Yes" { return $true }
                    "No" { return $false }
                    default {
                        Write-Host "Invalid input. Please enter 'Yes' or 'No'." -ForegroundColor Red
                    }
                }
            }
        }
        "FreeText" {
            return Read-Host
        }
        "Subpool" {
            while ($true) {
                $input = Read-Host
                try {
                    $int = [int]::Parse($input)
                    if ($int -gt 726) {
                        return $int
                    } else {
                        Write-Host "Invalid input. Please enter a valid subscription pool ID." -ForegroundColor Red
                    }
                } catch {
                    Write-Host "Invalid input. Please enter a valid subscription pool ID." -ForegroundColor Red
                }
            }
        }
        "Mode" {
            while ($true) {
                $input = Read-Host
                switch ($input) {
                    "Manual" { return $input }
                    "Automated" { return $input }
                    default {
                        Write-Host "Invalid input. Please enter 'Manual' or 'Automated'." -ForegroundColor Red
                    }
                }
            }
        }
    }
}

# Validate Correct Tenant
$cancel = $false
aad-auth
if ($cancel -eq $true) { return "You have identified this as the incorrect tenant. Please login to the correct tenant and try again." }

# Validate Azure Lab Services Module available - install if not
if (-not (Get-Module -ListAvailable -Name $AzLabServicesModule)) {
    $AzLabServicesModule = "Az.LabServices"
    Write-Host "Azure Lab Services Module is not installed. Attempting to install..."
    
    # Install the module from PSGallery or another specified repository
    try {
        Install-Module -Name $AzLabServicesModule -Force -ErrorAction Stop
        Write-Host "Azure Lab Services Module installed successfully."
    } catch {
        Write-Host "Failed to install Azure Lab Services Module: $_"
    }
} else {
    Write-Host "Azure Lab Services Module already installed."
}

# Get all labs from subscription
$AzureLabs = Get-AzLabServicesLab | Sort-Object -Property Name
$i = 0

# Obtain user input of variables
Write-Host -ForegroundColor Yellow "`nCOST IMPACT: Skillable supports the ability for lab users to extend their quota hours by 50% if needed. Skillable does not charge orchestration costs for this access, but any Azure charges in that period will still be applicable."
$timeExtensions = Read-Input -Type Boolean -Prompt 'Would you like to enable time extensions for these labs (Yes/No)?' -Color Cyan

# Initialize an array to store all lab data
$allLabData = @()

foreach ($lab in $AzureLabs) {
    $labName = $lab.Name
    "Gathering Lab Data for $labName"
    $i += 1
    $shortDate = Get-Date -Format "yyyyMMdd"
    $labNumber = "Import$($i.ToString('00'))_$shortDate"

    # Copy base data and modify per lab
    $labData = [pscustomobject]@{
        Name = $labName
        Number = $labNumber
        DurationMinutes = [int]$lab.VirtualMachineProfileUsageQuota.TotalMinutes
        Description = $lab.Description
        LastConsoleSyncTimeoutMinutes = [int]$lab.AutoShutdownProfileDisconnectDelay.Minutes
        LastActivityTimeoutMinutes = [int]$lab.AutoShutdownProfileIdleDelay.Minutes
        MinimumAutoSaveTimeInvestment = [int]$lab.AutoShutdownProfileNoConnectDelay.Minutes
        AllowDesktopConnections = $true
        AllowSshConnections = $false
        LabTitle = $labName
        AllowTimeExtensions = $timeExtensions
        VMName = "Student VM - $labName"
        MachineType = $null
        ExternalMachineImage = $null
        ExternalMachineImageRegion = $null
        CloudDatacenterAvailability = $null
        OSType = $lab.VirtualMachineProfileOSType
        Username = $null
        Password = $null
        ExternalImageSource = $null
        ImageReferenceID = $null
        ExternalImageOffer = $null
        ExternalImagePublisher = $null
    }

    # Set machine type based on SKU
    $trimmedSkuName = $lab.SkuName -replace '(_\d+GB).+$', '$1'
    $labData.MachineType = switch ($trimmedSkuName) {
        "Classic_Fsv2_2_4GB" { "Standard_F2s_v2" }
        "Classic_Fsv2_4_8GB" { "Standard_F4s_v2" }
        "Classic_Fsv2_8_16GB" { "Standard_F8s_v2" }
        "Classic_Dsv4_4_16GB" { "Standard_DS3_v2" }
        "Classic_Dsv4_8_32GB" { "Standard_DS4_v2" }
        "NVadsA10v5" { "TBD" }
        "TBD" { "Standard_NV8as_v4" }
        "TBD" { "Standard_NV12" }
        "NVadsA10v5" { "Standard_NV12ads_A10_v5" }
        "TBD" { "TBD" }
        "TBD" { "Standard_NC8as_T4_v3" }
        "TBD" { "Standard_NV8as_v4" }
        default { "Standard_F4s_v2" }
    }

    # Set image reference details
    if ($null -ne $lab.ImageReferenceId) {
        # Set details for Compute Gallery Images
        $labData.ExternalImageSource = "Gallery"
        $labData.ImageReferenceID = $lab.ImageReferenceID
        $labData.ExternalImageOffer = "N/A"
        $labData.ExternalImagePublisher = "N/A"
        $labData.ExternalMachineImage = $lab.ImageReferenceID -replace '.*/images/(.+)', '$1'
        $labData.ExternalMachineImageRegion = "latest"
    } else {
        # Set details for Marketplace Images
        $labData.ExternalImageSource = "Marketplace"
        $labData.ImageReferenceID = "N/A"
        $labData.ExternalImageOffer = $lab.ImageReferenceOffer
        $labData.ExternalImagePublisher = $lab.ImageReferencePublisher
        $labData.ExternalMachineImage = $lab.ImageReferenceSku
        $labData.ExternalMachineImageRegion = $lab.ImageReferenceVersion
    }

    # Check for RDP and SSH access
    $labData.AllowDesktopConnections = $lab.ConnectionProfileClientRdpAccess -ne "None" -or $lab.ConnectionProfileWebRdpAccess -ne "None"
    $labData.AllowSshConnections = $lab.ConnectionProfileClientSSHAccess -ne "None" -or $lab.ConnectionProfileWebSSHAccess -ne "None"

    # Set username and password
    $adminUsername = $lab.AdminUserUsername
    $nonAdminUsername = $lab.NonAdminUserUsername

    if ($null -ne $adminUsername) {
        $labData.Username = $adminUsername
        $labData.Password = Read-Input -Type FreeText -Prompt "For lab $labName, please provide the password for the Admin user ${adminUsername}:" -Color Cyan
    } elseif ($null -ne $nonAdminUsername) {
        $labData.Username = $nonAdminUsername
        $labData.Password = Read-Input -Type FreeText -Prompt "For lab $labName, please provide the password for the non-Admin user ${nonAdminUsername}:" -Color Cyan
    } else {
        $labData.Username = $exportLabData.VirtualMachineProfiles[0].Username
    }

    # Add lab data to the array
    $allLabData += $labData

    # Prepare JSON data for the lab
    $importLabData = $exportLabData | ConvertTo-Json -Depth 10 | ConvertFrom-Json
    $importLabData.LabProfiles[0].Name = $labData.Name
    $importLabData.LabProfiles[0].InstructionsSets[0].LabTitle = $labData.LabTitle
    $importLabData.VirtualMachineProfiles[0].Name = $labData.VMName
    $importLabData.LabProfiles[0].Number = $labData.Number
    $importLabData.LabProfiles[0].DurationMinutes = $labData.DurationMinutes
    $importLabData.LabProfiles[0].InstructionsSets[0].DurationMinutes = $labData.DurationMinutes
    $importLabData.LabProfiles[0].Description = $labData.Description
    $importLabData.LabProfiles[0].LastConsoleSyncTimeoutMinutes = $labData.LastConsoleSyncTimeoutMinutes
    $importLabData.LabProfiles[0].LastActivityTimeoutMinutes = $labData.LastActivityTimeoutMinutes
    $importLabData.LabProfiles[0].MinimumAutoSaveTimeInvestment = $labData.MinimumAutoSaveTimeInvestment
    $importLabData.LabProfiles[0].AllowTimeExtensions = $labData.AllowTimeExtensions
    $importLabData.LabProfiles[0].Machines[0].AllowDesktopConnections = $labData.AllowDesktopConnections
    $importLabData.LabProfiles[0].Machines[0].AllowSshConnections = $labData.AllowSshConnections
    $importLabData.VirtualMachineProfiles[0].OperatingSystemValue = $labdata.OSType
    $importLabData.VirtualMachineProfiles[0].MachineType = $labData.MachineType
    $importLabData.VirtualMachineProfiles[0].Username = $labData.Username
    $importLabData.VirtualMachineProfiles[0].Password = $labData.Password
    $importLabData.VirtualMachineProfiles[0].ExternalMachineImage = $labData.ExternalMachineImage
    $importLabData.VirtualMachineProfiles[0].ExternalMachineImageRegion = $labData.ExternalMachineImageRegion

    # Save JSON data to file
    $jsonFilePath = "./tmp/${labName}.json"
    $zipFilePath = "./labs/${labName}_import.zip"
    $importLabData | ConvertTo-Json -Depth 10 | Out-File -FilePath $jsonFilePath -Encoding UTF8

    # Compress JSON file into ZIP archive
    Compress-Archive -Path $jsonFilePath -DestinationPath $zipFilePath
    Remove-Item -Path $jsonFilePath
    Write-Host "Lab archived successfully at $zipFilePath"
}

# Export all lab data to a CSV file
$allLabData | Export-Csv -Path "./labs/AllLabs.csv" -NoTypeInformation

# Compress the directory containing the labs into a single ZIP file
Compress-Archive -Path "./labs/" -DestinationPath "./Labs_Export.zip"

download ./Labs_Export.zip
Write-Host "All lab data archived successfully in Labs_Export.zip. If you need a fresh download use the following command: download ./Labs_Export.zip"

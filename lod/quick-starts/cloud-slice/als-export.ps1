$cancel = $false

function aad-auth{
    try{
        $currentTenant = Get-AzureADTenantDetail
    }catch{
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
    if($confirmation -eq "Cancel"){
        $script:cancel = $true
        return
    }
}

function Read-Input {
    param(
        [string]$Prompt = "Please enter something:",
        [ValidateSet("Integer", "Text", "Boolean","Mode")] # This restricts the Type parameter to these values.
        [string]$Type = "Text",
        [System.ConsoleColor]$Color = 'Cyan'
    )

    Write-Host -NoNewline -ForegroundColor $Color $Prompt
    $input = Read-Host

    switch ($Type) {
        "Integer" {
            while ($true) {
                try {
                    $int = [int]::Parse($input)
                    return $int
                } catch {
                    Write-Host "Invalid input. Please enter a valid integer." -ForegroundColor Red
                    $input = Read-Host
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
        "Text" {
            return $input
        }
        "Mode" {  # New case for handling "Performance" or "Quality"
            while ($true) {
                $input = Read-Host
                switch ($input) {
                    "Performance", "Quality" { return $input }
                    default {
                        Write-Host "Invalid input. Please enter 'Performance' or 'Quality'." -ForegroundColor Red
                    }
                }
            }
        }
    }
}

aad-auth
if($cancel -eq $true){return "You have identified this as the incorrect tenant. Please login to the correct tenant and try again."}
$seriesID = Read-Input -Type Integer -Prompt 'Enter your Skillable Lab Series ID:' -Color Cyan
$subPoolID = Read-Input -Type Integer -Prompt 'Enter your Skillable Cloud Subscription Pool ID:' -Color Cyan
Write-Host -ForegroundColor Yellow "COST IMPACT: Skillable supports the ability for lab users to extend their quota hours by 50% if needed. Skillable does not charge orchestration costs for this access, but any Azure charges in that period will still be applicable. Would you like to enable this capability for these labs?"
$timeExtensions = Read-Input -Type Boolean -Prompt 'Would you like to enable time extensions for these labs (Yes/No)?' -Color Cyan
Write-Host -ForegroundColor Yellow "Would you like to prioritize lab performance or visual quality? Performance mode disables the VM background and font smoothing."
$perfMode = Read-Input -Type Mode -Prompt 'Please select performance or quality mode:' -Color Cyan

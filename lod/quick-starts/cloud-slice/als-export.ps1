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
        [ValidateSet("Integer", "FreeText", "Boolean", "Mode")]
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
        "Mode" {
            while ($true) {
                $input = Read-Host
                switch ($input) {
                    "Performance" { return $input }
                    "Quality" { return $input }
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
Write-Host -ForegroundColor Yellow "`nCOST IMPACT: Skillable supports the ability for lab users to extend their quota hours by 50% if needed. Skillable does not charge orchestration costs for this access, but any Azure charges in that period will still be applicable."
$timeExtensions = Read-Input -Type Boolean -Prompt 'Would you like to enable time extensions for these labs (Yes/No)?' -Color Cyan
Write-Host -ForegroundColor Yellow "`nWould you like to prioritize lab performance or visual quality? Performance mode disables the VM background and font smoothing, these are generally minor impacts but in regions with poor internet they can become more severe (this decision can be changed later on specific labs)."
$perfMode = Read-Input -Type Mode -Prompt 'Please select performance or quality mode:' -Color Cyan

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

function Read-Integer {
    param(
        [string]$Prompt = "Please enter an integer:",
        [System.ConsoleColor]$Color = 'Cyan'
    )

    # Set the foreground color for the prompt message
    Write-Host -NoNewline -ForegroundColor $Color $Prompt
    while ($true) {
        $input = Read-Host
        try {
            # Try to convert the input to an integer
            $int = [int]::Parse($input)
            return $int
        } catch {
            # If input is not an integer, print an error message in Red
            Write-Host "Invalid input. Please enter a valid integer." -ForegroundColor Red
        }
    }
}

aad-auth
if($cancel -eq $true){return "You have identified this as the incorrect tenant. Please login to the correct tenant and try again."}
$seriesID = Read-Integer -Prompt 'Enter your Skillable Lab Series ID:' -Color Cyan
$subPoolID = Read-Integer -Prompt 'Enter your Skillable Cloud Subscription Pool ID:' -Color Cyan

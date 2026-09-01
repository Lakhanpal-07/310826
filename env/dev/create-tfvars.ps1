# # Define file paths
# $inputPath  = ".\input.csv"
# $tfvarsPath = ".\terraform.tfvars"

# # Check if input file exists
# if (-not (Test-Path $inputPath)) {
#     Write-Error "Error: '$inputPath' not found. Please create the input file first."
#     exit
# }

# # Read all non-empty lines
# $lines = Get-Content -Path $inputPath | Where-Object { $_.Trim() -ne "" }

# # Skip header row if present
# if ($lines.Count -gt 1 -and ($lines[0] -match "rg_name" -or $lines[0] -match "name")) {
#     $lines = $lines | Select-Object -Skip 1
# }

# # Array to store structured map blocks
# $mapBlocks = @()

# foreach ($line in $lines) {
#     # Split by comma OR space/tab whitespace
#     $parts = $line.Trim() -split '[\s,]+'
    
#     if ($parts.Count -ge 2) {
#         $rgName   = $parts[0]
#         $location = $parts[1]
        
#         # Sanitize key name for HCL compliance
#         $mapKey = $rgName -replace '[^a-zA-Z0-9_]', '_'
        
#         # Build standard block structure
#         $block  = "  $mapKey = {`n"
#         $block += "    name     = `"$rgName`"`n"
#         $block += "    location = `"$location`"`n"
#         $block += "  }"
        
#         $mapBlocks += $block
#     }
# }

# # Join map blocks with commas between entries
# $tfvarsContent = "rg_map = {`n" + ($mapBlocks -join ",`n") + "`n}"

# # Write directly to terraform.tfvars
# [System.IO.File]::WriteAllText((Resolve-Path .).Path + "\terraform.tfvars", $tfvarsContent)

# Write-Host "Successfully generated '$tfvarsPath'!" -ForegroundColor Green


# Define file paths
$inputPath  = ".\input.csv"
$tfvarsPath = ".\terraform.tfvars"

# Check if input file exists
if (-not (Test-Path $inputPath)) {
    Write-Error "Error: '$inputPath' not found. Please create the input file first."
    exit
}

# Read all non-empty lines
$lines = Get-Content -Path $inputPath | Where-Object { $_.Trim() -ne "" }

# Skip header row if present
if ($lines.Count -gt 1 -and ($lines[0] -match "rg" -or $lines[0] -match "vnet")) {
    $lines = $lines | Select-Object -Skip 1
}

# Array to store structured map blocks
$mapBlocks = @()

foreach ($line in $lines) {
    # Split by comma OR space/tab whitespace
    $parts = $line.Trim() -split '[\s,]+'
    
    # Expecting 4 values: RG Name, Location, VNet Name, Subnet/Address Prefix
    if ($parts.Count -ge 4) {
        $rgName       = $parts[0]
        $location     = $parts[1]
        $vnetName     = $parts[2]
        $addressSpace = $parts[3] -replace '[\[\]]', '' # Removes optional square brackets if pasted
        
        # Sanitize key name for HCL compliance
        $mapKey = $rgName -replace '[^a-zA-Z0-9_]', '_'
        
        # Build standard block structure
        $block  = "  $mapKey = {`n"
        $block += "    name          = `"$rgName`"`n"
        $block += "    location      = `"$location`"`n"
        $block += "    vnet_name     = `"$vnetName`"`n"
        $block += "    address_space = [`"$addressSpace`"]`n"
        $block += "  }"
        
        $mapBlocks += $block
    }
}

# Join map blocks with commas between entries
$tfvarsContent = "rg_map = {`n" + ($mapBlocks -join ",`n") + "`n}"

# Write directly to terraform.tfvars
$outputPath = Join-Path (Get-Location).Path "terraform.tfvars"
[System.IO.File]::WriteAllText($outputPath, $tfvarsContent)

Write-Host "Successfully generated '$tfvarsPath'!" -ForegroundColor Green
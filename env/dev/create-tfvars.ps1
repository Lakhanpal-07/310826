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
if ($lines.Count -gt 1 -and ($lines[0] -match "rg_name" -or $lines[0] -match "name")) {
    $lines = $lines | Select-Object -Skip 1
}

# Array to store structured map blocks
$mapBlocks = @()

foreach ($line in $lines) {
    # Split by comma OR space/tab whitespace
    $parts = $line.Trim() -split '[\s,]+'
    
    if ($parts.Count -ge 2) {
        $rgName   = $parts[0]
        $location = $parts[1]
        
        # Sanitize key name for HCL compliance
        $mapKey = $rgName -replace '[^a-zA-Z0-9_]', '_'
        
        # Build standard block structure
        $block  = "  $mapKey = {`n"
        $block += "    name     = `"$rgName`"`n"
        $block += "    location = `"$location`"`n"
        $block += "  }"
        
        $mapBlocks += $block
    }
}

# Join map blocks with commas between entries
$tfvarsContent = "rg_map = {`n" + ($mapBlocks -join ",`n") + "`n}"

# Write directly to terraform.tfvars
[System.IO.File]::WriteAllText((Resolve-Path .).Path + "\terraform.tfvars", $tfvarsContent)

Write-Host "Successfully generated '$tfvarsPath'!" -ForegroundColor Green




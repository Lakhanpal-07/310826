# Define file paths
$inputPath  = ".\input.csv"
$tfvarsPath = ".\terraform.tfvars"

# Check if input file exists
if (-not (Test-Path $inputPath)) {
    Write-Error "Error: '$inputPath' not found. Please create the input file first."
    exit
}

# Read lines from input file (ignoring empty lines and header)
$lines = Get-Content -Path $inputPath | Where-Object { $_.Trim() -ne "" } | Select-Object -Skip 1

# Array to store map string blocks
$mapBlocks = @()

foreach ($line in $lines) {
    # Split line by whitespace (one or more spaces/tabs)
    $parts = $line.Trim() -split '\s+'
    
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

# Join map blocks with a single trailing comma and newline separating each entry
$tfvarsContent = "rg_map = {`n" + ($mapBlocks -join ",`n") + "`n}"

# Write cleanly to terraform.tfvars
[System.IO.File]::WriteAllText((Resolve-Path .).Path + "\terraform.tfvars", $tfvarsContent)

Write-Host "Successfully generated '$tfvarsPath'!" -ForegroundColor Green
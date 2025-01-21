param(
    [parameter(Mandatory=$true)][string] $inputfile,
    [parameter(Mandatory=$true)][string] $substitutionsfile
  )


if (-not (Test-Path $inputfile)) {
    Write-Output "Input File $inputfile does not exist."
    exit 1
}

if (-not (Test-Path $substitutionsfile)) {
    Write-Output "Substitutions File $substitutionsfile does not exist."
    exit 1
}

$subs = Get-Content -Raw $substitutionsfile | ConvertFrom-Json

[System.Collections.ArrayList] $lines = @()
foreach($line in Get-Content -Path $inputfile)
{
    foreach ($obj in $subs.PSObject.Properties) {
        $key = "$"+$obj.Name+"$"
        $line = $line.Replace($key, $obj.Value)
    }
    [void] $lines.Add($line)
}

Remove-Item $inputfile

$lines | Out-File -Append $inputfile

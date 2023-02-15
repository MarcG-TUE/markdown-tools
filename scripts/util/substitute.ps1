param(
    [parameter(Mandatory=$true)][string] $inputfile,
    [parameter(Mandatory=$true)][string] $substitutionsfile
  )

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

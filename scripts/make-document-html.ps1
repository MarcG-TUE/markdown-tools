param(
    [parameter(Mandatory=$true)][string] $inputfile,
    [parameter(Mandatory=$true)][string] $outputfile,
    [parameter(Mandatory=$false)][string] $bibfile = ""
  )

$Verbose = $false
if ($PSBoundParameters.ContainsKey('Verbose')) { # Command line specifies -Verbose[:$false]
    $Verbose = $PsBoundParameters.Get_Item('Verbose')
}

$inputfile = Resolve-Path -Path $inputfile

$outputpath = Split-Path -Path $outputfile -Parent
$outputpath = Resolve-Path $outputpath
$outputleaf = Split-Path -Path $outputfile -Leaf
$outputfile = "$outputpath\$outputleaf"

$macrosfile = Resolve-Path -Path "$PSScriptRoot/../metadata/macros.yaml"
$filters = Resolve-Path -Path "$PSScriptRoot/../filters"

$allargs = @($inputfile, `
  "--output", $outputfile, `
  "--from", "markdown+citations", `
  "--to", "html", `
  "--lua-filter", "$filters/html/macros.lua", `
  "--filter", "pandoc-xnos", `
  "--lua-filter", "$filters/html/environments.lua", `
  "--lua-filter", "$filters/html/references.lua", `
  "--lua-filter", "$filters/html/images.lua", `
  "--metadata-file", $macrosfile, `
  "--citeproc")

if ($bibfile -ne "") {
  $bibpath = Resolve-Path -Path $bibfile
  $bibpath = $bibpath -replace '[\\]', "/"
  $allargs += "--bibliography=$bibpath"
}

if ($Verbose) {
  $allargs += "--verbose"
}
  
& pandoc $allargs
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

$headerfile = Resolve-Path -Path "$PSScriptRoot/../templates/document/header.tex"
$macrosfile = Resolve-Path -Path "$PSScriptRoot/../metadata/macros.yaml"
$filters = Resolve-Path -Path "$PSScriptRoot/../filters"

$allargs = @($inputfile, `
  "--output", $outputfile, `
  "--from", "markdown+citations", `
  "--to", "pdf", `
  "--include-in-header", $headerfile, `
  "--lua-filter", "$filters/latex/macros.lua", `
  "--filter", "pandoc-xnos", `
  "--lua-filter", "$filters/latex/environments.lua", `
  "--lua-filter", "$filters/latex/references.lua", `
  "--lua-filter", "$filters/latex/images.lua", `
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

    # & pandoc $inputfile `
    # --output $outputfile `
    # --from markdown+citations `
    # --to pdf `
    # --include-in-header $headerfile `
    # --lua-filter $filters/latex/macros.lua `
    # --filter pandoc-xnos `
    # --lua-filter $filters/latex/environments.lua `
    # --lua-filter $filters/latex/references.lua `
    # --lua-filter $filters/latex/images.lua `
    # --metadata-file $macrosfile `
    # --citeproc `
    # $bibopt $verboseOpt

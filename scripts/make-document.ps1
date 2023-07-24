param(
  [parameter(Mandatory = $true)][string] $inputfile,
  [parameter(Mandatory = $true)][string] $outputfile,
  [parameter(Mandatory = $false)][string] $bibfile = "",
  [parameter(Mandatory = $false)][string] $macrosfile = "",
  [parameter(Mandatory = $false)][string] $headerfile = ""
)

# check output type
$outputExtension = Split-Path -Path $outputfile -Extension
if ($outputExtension -eq '.tex') {
  $targetType = 'latex'
} else {
  $targetType = 'pdf'
}

$Verbose = $false
if ($PSBoundParameters.ContainsKey('Verbose')) {
  # Command line specifies -Verbose[:$false]
  $Verbose = $PsBoundParameters.Get_Item('Verbose')
}

$inputfile = Resolve-Path -Path $inputfile

$outputpath = Split-Path -Path $outputfile -Parent
$outputpath = Resolve-Path $outputpath
$outputleaf = Split-Path -Path $outputfile -Leaf
$outputfile = "$outputpath\$outputleaf"

if ($headerfile -ne "") {
  $headerfile = Resolve-Path -Path $headerfile
  $headerfile = $headerfile -replace '[\\]', "/"
}
else {
  $headerfile = Resolve-Path -Path "$PSScriptRoot/../templates/document/header.tex"
}

$filters = Resolve-Path -Path "$PSScriptRoot/../filters"

if ($macrosfile -ne "") {
  $macrospath = Resolve-Path -Path $macrosfile
  $macrospath = $macrospath -replace '[\\]', "/"
}
else {
  $macrospath = Resolve-Path -Path "$PSScriptRoot/../metadata/macros.yaml"
}


$allargs = @($inputfile, `
    "--output", $outputfile, `
    "--from", "markdown+citations", `
    "--to", $targetType, `
    "-V", "geometry:margin=1in", `
    "--include-in-header", $headerfile, `
    "--number-sections", `
    "--metadata-file", $macrospath, `
    "--lua-filter", "$filters/common/macros.lua", `
    "--filter", "pandoc-xnos", `
    "--lua-filter", "$filters/latex/spans.lua", `
    "--lua-filter", "$filters/latex/environments.lua", `
    "--lua-filter", "$filters/latex/references.lua", `
    "--lua-filter", "$filters/latex/images.lua", `
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

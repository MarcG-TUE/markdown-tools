param(
    [parameter(Mandatory=$true)][string] $inputfile,
    [parameter(Mandatory=$true)][string] $outputfile
  )

$inputfile = Resolve-Path -Path $inputfile

$outputpath = Split-Path -Path $outputfile -Parent
$outputpath = Resolve-Path $outputpath
$outputleaf = Split-Path -Path $outputfile -Leaf
$outputfile = "$outputpath\$outputleaf"

$headerfile = Resolve-Path -Path "$PSScriptRoot/../templates/document/header.tex"
$macrosfile = Resolve-Path -Path "$PSScriptRoot/../metadata/macros.yaml"
$filters = Resolve-Path -Path "$PSScriptRoot/../filters"

$mdDir = "$PSScriptRoot/.."

pandoc $inputfile `
    --output $outputfile `
    --to pdf `
    --include-in-header $headerfile `
    --lua-filter $filters/latex/environments.lua `
    --lua-filter $filters/latex/images.lua `
    --metadata-file $macrosfile `
    --lua-filter $filters/latex/macros.lua `
    --from markdown


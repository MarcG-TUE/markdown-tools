#!/usr/bin/env pwsh
param(
    [parameter(Mandatory=$true)][string] $inputfile,
    [parameter(Mandatory=$true)][string] $outputfile
)

$Verbose = $false
if ($PSBoundParameters.ContainsKey('Verbose')) { # Command line specifies -Verbose[:$false]
    $Verbose = $PsBoundParameters.Get_Item('Verbose')
}

$inputfile = Resolve-Path -Path $inputfile

$outputpath = Split-Path -Path $outputfile -Parent
$outputpath = Resolve-Path $outputpath
$outputleaf = Split-Path -Path $outputfile -Leaf
$outputfile = "$outputpath/$outputleaf"

$macrosfile = Resolve-Path -Path "$PSScriptRoot/../metadata/macros.yaml"
$filters = Resolve-Path -Path "$PSScriptRoot/../filters"

$allargs = @($inputfile,
  "--output", $outputfile,
  "--from", "markdown+citations+simple_tables+fenced_divs+link_attributes",
  "--to", "markdown",
  "--metadata-file", $macrosfile,
  "--lua-filter", "$filters/common/macros.lua",
  "--lua-filter", "$filters/latex/spans.lua",
  "--lua-filter", "$filters/latex/environments.lua",
  "--lua-filter", "$filters/questions/ans-environments.lua",
  "--lua-filter", "$filters/latex/references.lua",
  "--lua-filter", "$filters/questions/ans-images.lua",
  "--lua-filter", "$filters/questions/ans-mathdelimiters.lua"
)

if ($Verbose) {
    $allargs += "--verbose"
}

& pandoc $allargs

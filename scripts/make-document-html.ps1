#!/usr/bin/env pwsh
param(
    [parameter(Mandatory=$true)][string] $inputfile,
    [parameter(Mandatory = $false)][string[]] $additionalinputfiles,
    [parameter(Mandatory=$true)][string] $outputfile,
    [parameter(Mandatory=$false)][string] $bibfile = "",
    [parameter(Mandatory = $false)][string] $macrosfile = ""
    )

$Verbose = $false
if ($PSBoundParameters.ContainsKey('Verbose')) { # Command line specifies -Verbose[:$false]
    $Verbose = $PsBoundParameters.Get_Item('Verbose')
}

$inputfile = Resolve-Path -Path $inputfile

if ($null -ne $additionalinputfiles) {
  $additionalinputfiles = $additionalinputfiles | ForEach-Object {Resolve-Path -Path $_ }
} else {
  $additionalinputfiles = @()
}

$outputpath = Split-Path -Path $outputfile -Parent
$outputpath = Resolve-Path $outputpath
$outputleaf = Split-Path -Path $outputfile -Leaf
$outputfile = "$outputpath/$outputleaf"

if ($macrosfile -ne "") {
  $macrospath = Resolve-Path -Path $macrosfile
  $macrospath = $macrospath -replace '[\\]', "/"
}
else {
  $macrospath = Resolve-Path -Path "$PSScriptRoot/../metadata/macros.yaml"
}


$filters = Resolve-Path -Path "$PSScriptRoot/../filters"

$inputfiles = @($inputfile) + $additionalinputfiles

$allargs = $inputfiles + @(`
  "--output", $outputfile, `
  "--from", "markdown+citations+simple_tables", `
  "--mathjax", `
  "--to", "html", `
  "--lua-filter", "$filters/common/extractmetadata.lua",
  "--lua-filter", "$filters/html/macros.lua", `
  "--filter", "pandoc-xnos", `
  "--lua-filter", "$filters/html/environments.lua", `
  "--lua-filter", "$filters/html/references.lua", `
  "--lua-filter", "$filters/html/images.lua", `
  "--metadata-file", $macrosfile, `
  "--citeproc",
  "--standalone")

if ($bibfile -ne "") {
  $bibpath = Resolve-Path -Path $bibfile
  $bibpath = $bibpath -replace '[\\]', "/"
  $allargs += "--bibliography=$bibpath"
}

if ($Verbose) {
  $allargs += "--verbose"
}

& pandoc $allargs

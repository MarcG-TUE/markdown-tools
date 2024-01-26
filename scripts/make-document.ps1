#!/usr/bin/env pwsh
param(
  [parameter(Mandatory = $true)][string] $inputfile,
  [parameter(Mandatory = $false)][string[]] $additionalinputfiles,
  [parameter(Mandatory = $false)][string[]] $preprocessingfilters,
  [parameter(Mandatory = $true)][string] $outputfile,
  [parameter(Mandatory = $false)][string] $bibfile = "",
  [parameter(Mandatory = $false)][string] $macrosfile = "",
  [parameter(Mandatory = $false)][string] $headerfile = ""
)

# stop on first error
$ErrorActionPreference = "Stop"

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


# check the additional input files, if any
if ($null -ne $additionalinputfiles) {
  foreach ($f in $additionalinputfiles) {
      if (! (Test-Path $f -PathType Leaf)) {
          Write-Error("Input file $f not found.")
      }
  }
  $additionalinputfiles = $additionalinputfiles | ForEach-Object { Resolve-Path -Path $_ }
}
else {
  $additionalinputfiles = @()
}

# check the preprocessing filters, if any
if ($null -ne $preprocessingfilters) {
  foreach ($f in $preprocessingfilters) {
      if (! (Test-Path $f -PathType Leaf)) {
          Write-Error("Preprocessing filter $f not found.")
      }
  }
  $preprocessingfilters = $preprocessingfilters | ForEach-Object { Resolve-Path -Path $_ }
}
else {
  $preprocessingfilters = @()
}

$outputpath = Split-Path -Path $outputfile -Parent
$outputpath = Resolve-Path $outputpath
$outputleaf = Split-Path -Path $outputfile -Leaf
$outputfile = "$outputpath/$outputleaf"

if ($headerfile -ne "") {
  $headerfile = Resolve-Path -Path $headerfile
  $headerfile = $headerfile -replace '[\\]', "/"
}
else {
  $headerfile = Resolve-Path -Path "$PSScriptRoot/../templates/document/header.tex"
}

$filters = Resolve-Path -Path "$PSScriptRoot/../filters"
$templates = Resolve-Path -Path "$PSScriptRoot/../templates"

if ($macrosfile -ne "") {
  $macrospath = Resolve-Path -Path $macrosfile
  $macrospath = $macrospath -replace '[\\]', "/"
}
else {
  $macrospath = Resolve-Path -Path "$PSScriptRoot/../metadata/macros.yaml"
}

$inputfiles = @($inputfile) + $additionalinputfiles

$allargs = $inputfiles + @(`
    "--output", $outputfile, `
    "--from", "markdown+citations+simple_tables", `
    "--to", $targetType, `
    "-V", "geometry:margin=1in", `
    "--metadata", "fignos-warning-level=0", `
    "--metadata", "tablenos-warning-level=0", `
    "--metadata", "eqnos-warning-level=0", `
    "--template", "$templates/eisvogel"
    "--include-in-header", $headerfile, `
    "--number-sections", `
    "--metadata-file", $macrospath)

    foreach ($filter in $preprocessingfilters) {
      <# $filter is the current item #>
      $allargs = $allargs + @(`
      "--lua-filter", "$filter")
  }

  $allargs = $allargs + @(`
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

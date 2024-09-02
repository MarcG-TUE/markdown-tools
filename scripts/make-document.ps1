#!/usr/bin/env pwsh
param(
  [parameter(Mandatory = $true)][string] $inputfile,
  [parameter(Mandatory = $true)][string] $outputfile,
  [parameter(Mandatory = $false)][string[]] $additionalinputfiles,
  [parameter(Mandatory = $false)][string[]] $preprocessingfilters,
  [parameter(Mandatory = $false)][string] $bibfile = "",
  [parameter(Mandatory = $false)][string] $macrosfile = "",
  [parameter(Mandatory = $false)][string] $headerfile = "",
  [parameter(Mandatory = $false)][string] $template = "",
  [parameter(Mandatory = $false)][string[]] $pandocVariables,
  [parameter(Mandatory = $false)][switch] $includeToC
)

$pandocVars = @{}
$pandocVars["geometry:margin"] = "0.8in"
$pandocVars["fontsize"] = "10pt"

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

$templatesDir = Resolve-Path -Path "$PSScriptRoot/../templates"

if ($template -ne "") {
  $template = Resolve-Path -Path $template
} else {
  $template = "$templatesDir/eisvogel"
}

if ($macrosfile -ne "") {
  $macrospath = Resolve-Path -Path $macrosfile
  $macrospath = $macrospath -replace '[\\]', "/"
}
else {
  $macrospath = Resolve-Path -Path "$PSScriptRoot/../metadata/macros.yaml"
}

$filters = Resolve-Path -Path "$PSScriptRoot/../filters"

$inputfiles = @($inputfile) + $additionalinputfiles

foreach ($v in $pandocVariables) {
  $kv = $v -split "="
  $pandocVars[$kv[0]] = $kv[1]
}

$varargs = @()
foreach ($v in $pandocVars.Keys) {
  $varargs = $varargs + $("-V", "$v=$($pandocVars[$v])")
}

$tocArg = @()
if ($includeToC) {
  $tocArg = $("--toc")
}

$allargs = $inputfiles + @(`
    "--output", $outputfile, `
    "--from", "markdown+citations+simple_tables", `
    "--to", $targetType, `
    "--pdf-engine", "xelatex", `
    "--metadata", "fignos-warning-level=0", `
    "--metadata", "tablenos-warning-level=0", `
    "--metadata", "eqnos-warning-level=0", `
    "--metadata", "link-citations=true", `
    "--template", $template, `
    "--include-in-header", $headerfile, `
    "--number-sections", `
    "--metadata-file", $macrospath) `
    + $tocArg `
    + $varargs

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

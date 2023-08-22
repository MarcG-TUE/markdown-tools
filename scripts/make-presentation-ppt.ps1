#!/usr/bin/env pwsh
param(
    [parameter(Mandatory=$true)][string] $inputfile,
    [parameter(Mandatory=$false)][string] $template = ""
  )

$Verbose = $false
if ($PSBoundParameters.ContainsKey('Verbose')) { # Command line specifies -Verbose[:$false]
    $Verbose = $PsBoundParameters.Get_Item('Verbose')
}

$inputfile = Resolve-Path -Path $inputfile
$outputdir = Split-Path -Parent $inputfile

$inputbase = Split-Path -LeafBase $inputfile

$outputfile = "$outputdir/${inputbase}.pptx"

if ($template -eq "") {
    $template = "presentation.pptx"
}


$templatepath = "$PSScriptRoot/../templates/presentation/$template"
$templatepath = Resolve-Path $templatepath

$macrosfile = Resolve-Path -Path "$PSScriptRoot/../metadata/macros.yaml"
$filters = Resolve-Path -Path "$PSScriptRoot/../filters"

$allargs = @($inputfile,
  "--output", $outputfile,
  "--from", "markdown+citations+simple_tables+fenced_divs+link_attributes+footnotes",
  "--to", "pptx",
  "--reference-doc=$templatepath",
  "--metadata-file", $macrosfile,
  "--lua-filter", "$filters/common/macros.lua",
  "--lua-filter", "$filters/common/presentation.lua"
)

if ($optSyntaxDef) {
    $allargs += $optSyntaxDef
}

if ($Verbose) {
  $allargs += "--verbose"
}

& pandoc $allargs

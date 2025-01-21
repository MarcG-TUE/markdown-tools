#!/usr/bin/env pwsh
param(
    [parameter(Mandatory=$true)][string] $inputFile,
    [parameter(Mandatory=$true)][string] $outputDir,
    [parameter(Mandatory=$false)][string] $outputName = "",
    [parameter(Mandatory=$false)][string] $macros = "",
    [parameter(Mandatory=$false)][string] $filter = "",
    [parameter(Mandatory=$false)][string] $syntaxDefinition = "",
    [Parameter(Mandatory=$false)][string] $metadata = ""
)

$metadataArgs = @()
Foreach ($i in $metadata.Split("&"))
{
  if ($i) {
    $kv = $i.split("=")
    $metadataArgs += @("-M")
    $metadataArgs += "$($kv[0])=$($kv[1])"
  }
}

$Verbose = $false
if ($PSBoundParameters.ContainsKey('Verbose')) { # Command line specifies -Verbose[:$false]
    $Verbose = $PsBoundParameters.Get_Item('Verbose')
}

if (-not (Test-Path -PathType Container $outputDir)) {
    New-Item $outputDir -ItemType Directory
}

$inputFile = Resolve-Path -Path $inputFile
$inputDir = Split-Path -Parent $inputFile
$outputDir = Resolve-Path -Path $outputDir

if (! ($syntaxDefinition -eq "")) {
  Write-Output("Trying syntax definition file $syntaxDefinition.xml")
  if (Test-Path -Path "$syntaxDefinition.xml") {
    $syntaxDefinitionFullPath = Resolve-Path -Path $syntaxDefinition
    $optSyntaxDef = "--syntax-definition=$syntaxDefinitionFullPath"
  } else {
    Write-Output("Trying syntax definition file $PSScriptRoot/../metadata/syntax/$syntaxDefinition.xml")
    if (Test-Path -Path "$PSScriptRoot/../metadata/syntax/$syntaxDefinition.xml") {
      $syntaxDefinitionFullPath = Resolve-Path -Path "$PSScriptRoot/../metadata/syntax/$syntaxDefinition.xml"
      $optSyntaxDef = "--syntax-definition=$syntaxDefinitionFullPath"
    } else {
      Write-Output("Syntax definition file $syntaxDefinition not found. Not using syntax definition.")
      $optSyntaxDef = ""
    }
  }
}

$template = "$PSScriptRoot/../templates/presentation/presentation.html"
$template = Resolve-Path $template

if ($macros -eq "") {
  $macrosFile = Resolve-Path -Path "$PSScriptRoot/../metadata/macros.yaml"
} else {
  $macrosFile = Resolve-Path -Path $macros
}

if ($outputName -eq "") {
  $outputName = "index.html"
}

$filters = Resolve-Path -Path "$PSScriptRoot/../filters"

$allArgs = @($inputFile,
  "--output", "$outputDir/$outputName",
  "--from", "markdown+citations+simple_tables+fenced_divs+link_attributes+footnotes",
  "--to", "revealjs",
  "-V", "revealjs-url=./reveal.js",
  "-V", "width=960",
  "-V", "height=540",
  "-V", "margin=0.2",
  "-V", "center=0",
  "-V", "controls=0",
  "-V", "transition=slide",
  "-V", "slideNumber=`"'c'`"",
  "-V", "pdfSeparateFragments=0",
  "--css=./styles/theme.css",
  "--mathjax=./libs/mathjax/tex-chtml-full.js",
  "--standalone",
  "--template=$template",
  "--metadata-file", $macrosFile,
  "--lua-filter", "$filters/html/macros.lua",
  "--lua-filter", "$filters/common/presentation.lua"
  "--lua-filter", "$filters/html/reveal-extensions.lua",
  "--lua-filter", "$filters/common/extract-metadata.lua"
)

$allArgs += $metadataArgs

if ($filter) {
  $template = Resolve-Path $template
  $allArgs += "--lua-filter"
  $allArgs += $filter
}


if ($optSyntaxDef) {
    $allArgs += $optSyntaxDef
}

if ($optHighlightStyle) {
  $allargs += $optHighlightStyle
}


if ($Verbose) {
  $allArgs += "--verbose"
}

& pandoc $allArgs


# copy distribution files to output dir
$distPath = Resolve-Path $PSScriptRoot/../templates/presentation/dist
Copy-Item -Path "$distPath/*" -Destination $outputDir -Force -Recurse

$templates = Get-ChildItem $outputDir/background/*.html
foreach ($f in $templates) {
  & $PSScriptRoot/util/substitute $f "$inputDir/extracted-metadata.json"
}

if (Test-Path -Path "$inputDir/extracted-metadata.json") {
  Remove-Item "$inputDir/extracted-metadata.json"
}

# copy figures to output dir
if (Test-Path -Path "$inputDir/figures") {
  Copy-Item -Force -Recurse "$inputDir/figures" $outputDir
}

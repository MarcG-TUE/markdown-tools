#!/usr/bin/env pwsh
param(
    [parameter(Mandatory = $true)][string] $inputfile,
    [parameter(Mandatory = $true)][string] $outputfile,
    [parameter(Mandatory = $false)][string] $headerfile = "",
    [parameter(Mandatory = $false)][string] $template = ""
)

$Verbose = $false
if ($PSBoundParameters.ContainsKey('Verbose')) {
    # Command line specifies -Verbose[:$false]
    $Verbose = $PsBoundParameters.Get_Item('Verbose')
}

$inputfile = Resolve-Path -Path $inputfile
$inputdir = [string](Split-Path -Parent $inputfile)

$outputpath = Split-Path -Path $outputfile -Parent
$outputpath = [string] (Resolve-Path $outputpath)
$outputleaf = Split-Path -Path $outputfile -Leaf
$outputfile = "$outputpath/$outputleaf"

$macrosfile = Resolve-Path -Path "$PSScriptRoot/../metadata/macros.yaml"
$filters = Resolve-Path -Path "$PSScriptRoot/../filters"

if ($headerfile -ne "") {
    $headerfile = Resolve-Path -Path $headerfile
    $headerfile = $headerfile -replace '[\\]', "/"
  }
  else {
    $headerfile = Resolve-Path -Path "$PSScriptRoot/../templates/questions/questions.textmpl"
  }

  $templatesDir = Resolve-Path -Path "$PSScriptRoot/../templates"

  if ($template -ne "") {
    if (Test-Path -Path $template) {
      $template = Resolve-Path -Path $template
    } else {
      $template = "$templatesDir/questions/$template"
    }
  } else {
    # TODO: make an Eisvogel questions template
    # $template = "$templatesDir/questions/eisvogel"
    $template = "$templatesDir/questions/questions.textmpl"
  }

$allargs = @($inputfile,
    "--output", $outputfile,
    "--from", "markdown+citations+simple_tables+fenced_divs+link_attributes",
    "--to", "latex",
    "--lua-filter", "$filters/common/macros.lua",
    "--template", $template, `
    "--metadata-file", $macrosfile,
    # "--filter", "pandoc-xnos",
    "--lua-filter", "$filters/latex/references.lua"
    "--lua-filter", "$filters/questions/latex-environments.lua"
    "--lua-filter", "$filters/latex/spans.lua"
    "--lua-filter", "$filters/latex/environments.lua"
    "--lua-filter", "$filters/latex/images.lua"
    "--lua-filter", "$filters/latex/addlatexinputpath.lua"
    "--lua-filter", "$filters/latex/syntaxhighlighting.lua"
    "--citeproc"
)

if ($Verbose) {
    $allargs += "--verbose"
}

& pandoc $allargs

# copy figures to output dir
if (Test-Path -Path "$inputdir/figures") {
    if ($inputdir -ne $outputpath) {
        Copy-Item -Force -Recurse "$inputdir/figures" $outputpath
    }
}
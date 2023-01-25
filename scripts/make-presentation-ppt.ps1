
param(
    [parameter(Mandatory=$true)][string] $inputfile,
    [parameter(Mandatory=$false)][string] $template = ""
  )

$inputfile = Resolve-Path -Path $inputfile
$outputdir = Split-Path -Parent $inputfile

$inputbase = Split-Path -LeafBase $inputfile

$outputfile = "$outputdir\${inputbase}.pptx"

if ($template -eq "") {
    $template = "presentation.pptx"
}


$templatepath = "$PSScriptRoot\..\templates\presentation\$template"
$templatepath = Resolve-Path $templatepath

pandoc $inputfile `
--metadata-file "$PSScriptRoot/../metadata/macros.yaml" `
--output $outputfile `
--to pptx `
--reference-doc=$templatepath `
--from markdown+citations+fenced_divs+link_attributes+footnotes `
--lua-filter "$PSScriptRoot/../filters/common/macros.lua" `
--lua-filter "$PSScriptRoot/../filters/common/presentation.lua" `
$optSyntaxDef


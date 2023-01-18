
param(
    [parameter(Mandatory=$true)][string] $inputfile,
    [parameter(Mandatory=$true)][string] $outputdir,
    [parameter(Mandatory=$false)][string] $syntaxdefinition = ""
  )

if (-not (Test-Path -PathType Container $outputdir)) {
    New-Item $outputdir -ItemType Directory
}

$inputfile = Resolve-Path -Path $inputfile
$inputdir = Split-Path -Parent $inputfile
$outputdir = Resolve-Path -Path $outputdir


if (! ($syntaxdefinition -eq "")) {
    $optSyntaxDef = "--syntax-definition=metadata/syntax/$syntaxdefinition"
}

$template = "$PSScriptRoot\..\templates\presentation\presentation.html"
$template = Resolve-Path $template

pandoc $inputfile `
--metadata-file "$PSScriptRoot/../metadata/macros.yaml" `
--output $outputdir\index.html `
--to revealjs `
-V revealjs-url=./reveal.js `
-V center=0 `
-V controls=0 `
-V transition=slide `
-V slideNumber="'c'" `
--css=./styles/theme.css `
--mathjax=./libs/mathjax/tex-chtml-full.js `
--standalone `
--template=$template `
--from markdown+citations+fenced_divs+link_attributes+footnotes `
--lua-filter "$PSScriptRoot/../filters/common/macros.lua" `
--lua-filter "$PSScriptRoot/../filters/common/presentation.lua" `
--lua-filter "$PSScriptRoot/../filters/html/reveal-extensions.lua" `
$optSyntaxDef

# copy distribution files to output dir
Copy-Item -Force -Recurse "$PSScriptRoot/../templates/presentation/dist/*" $outputdir

# copy figures to output dir
Copy-Item -Force -Recurse "$inputdir/figures" $outputdir

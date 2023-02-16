
param(
    [parameter(Mandatory=$true)][string] $inputfile,
    [parameter(Mandatory=$true)][string] $outputdir,
    [parameter(Mandatory=$false)][string] $outputname = "",
    [parameter(Mandatory=$false)][string] $macros = "",
    [parameter(Mandatory=$false)][string] $syntaxdefinition = ""
  )

$Verbose = $false
if ($PSBoundParameters.ContainsKey('Verbose')) { # Command line specifies -Verbose[:$false]
    $Verbose = $PsBoundParameters.Get_Item('Verbose')
}

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

if ($macros -eq "") {
  $macrosfile = Resolve-Path -Path "$PSScriptRoot/../metadata/macros.yaml"
} else {
  $macrosfile = Resolve-Path -Path $macros
}

if ($outputname -eq "") {
  $outputname = "index.html"
} 

$filters = Resolve-Path -Path "$PSScriptRoot/../filters"

$allargs = @($inputfile,
  "--output", "$outputdir\$outputname",
  "--from", "markdown+citations+fenced_divs+link_attributes+footnotes",
  "--to", "revealjs",
  "-V", "revealjs-url=./reveal.js",
  "-V", "width=960",
  "-V", "height=540",
  "-V", "margin=0.2",
  "-V", "center=0",
  "-V", "controls=0",
  "-V", "transition=slide",
  "-V", "slideNumber=`"'c'`"",
  "--css=./styles/theme.css",
  "--mathjax=./libs/mathjax/tex-chtml-full.js",
  "--standalone",
  "--template=$template",
  "--metadata-file", $macrosfile,
  "--lua-filter", "$filters/common/macros.lua",
  "--lua-filter", "$filters/common/presentation.lua"
  "--lua-filter", "$filters/html/reveal-extensions.lua",
  "--lua-filter", "$filters/common/extractmetadata.lua"
)

if ($optSyntaxDef) {
    $allargs += $optSyntaxDef
}
    
if ($Verbose) {
  $allargs += "--verbose"
}

& pandoc $allargs


# copy distribution files to output dir
$distPath = Resolve-Path $PSScriptRoot\..\templates\presentation\dist
Copy-Item -Path "$distPath\*" -Destination $outputdir -Force -Recurse

$templates = Get-ChildItem $outputdir/background/*.html
foreach ($f in $templates) {
  & $PSScriptRoot\util\substitute $f "$inputdir/extracted-metadata.json"
}

Remove-Item "$inputdir/extracted-metadata.json"

# copy figures to output dir
if (Test-Path -Path "$inputdir/figures") {
  Copy-Item -Force -Recurse "$inputdir/figures" $outputdir
}

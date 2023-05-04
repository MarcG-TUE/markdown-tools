param(
    [parameter(Mandatory = $true)][string] $inputfile,
    [parameter(Mandatory = $true)][string] $outputfile
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
$outputfile = "$outputpath\$outputleaf"

$macrosfile = Resolve-Path -Path "$PSScriptRoot/../metadata/macros.yaml"
$filters = Resolve-Path -Path "$PSScriptRoot/../filters"
$templates = Resolve-Path -Path "$PSScriptRoot/../templates"

$allargs = @($inputfile,
    "--output", $outputfile,
    "--from", "markdown+citations+fenced_divs+link_attributes",
    "--to", "html",
    "--mathjax",
    "--template", "$templates/questions/questions.html",
    "--standalone",
    "--metadata-file", $macrosfile,
    "--toc", "-V", "toc-title:Table of Contents", "--toc-depth=1",
    "--lua-filter", "$filters/html/macros.lua",
    "--lua-filter", "$filters/questions/html-environments.lua",
    "--lua-filter", "$filters/html/environments.lua",
    "--lua-filter", "$filters/html/images.lua",
    "--lua-filter", "$filters/latex/references.lua"
)

if ($Verbose) {
    $allargs += "--verbose"
}
    
& pandoc $allargs

# copy figures to output dir if it exists

if (Test-Path -Path "$inputdir/figures") {
    if ($inputdir -ne $outputpath) {
        Copy-Item -Force -Recurse "$inputdir/figures" $outputpath
    }
}

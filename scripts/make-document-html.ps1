#!/usr/bin/env pwsh
param(
    [parameter(Mandatory = $true)][string] $inputfile,
    [parameter(Mandatory = $true)][string] $outputfile,
    [parameter(Mandatory = $false)][string[]] $additionalinputfiles,
    [parameter(Mandatory = $false)][string[]] $preprocessingfilters,
    [parameter(Mandatory = $false)][string] $bibfile = "",
    [parameter(Mandatory = $false)][string] $macrosfile = "",
    [parameter(Mandatory = $false)][string] $templatefile = "",
    [parameter(Mandatory = $false)][string] $csslink = "",
    [parameter(Mandatory = $false)][string] $imagetype = "png"
)

$ErrorActionPreference = "Stop"

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

if ($macrosfile -ne "") {
    $macrospath = Resolve-Path -Path $macrosfile
    $macrospath = $macrospath -replace '[\\]', "/"
}
else {
    $macrospath = Resolve-Path -Path "$PSScriptRoot/../metadata/macros.yaml"
}

if ($templatefile -ne "") {
    $templatepath = Resolve-Path -Path $templatefile
    $templatepath = $templatepath -replace '[\\]', "/"
}

$filters = Resolve-Path -Path "$PSScriptRoot/../filters"

$inputfiles = @($inputfile) + $additionalinputfiles

$allargs = $inputfiles + @(`
        "--output", $outputfile, `
        "--from", "markdown+citations+simple_tables", `
        "--mathjax", `
        "--to", "html", `
        "--metadata", "fignos-warning-level=0", `
        "--metadata", "tablenos-warning-level=0", `
        "--metadata", "eqnos-warning-level=0", `
        "--metadata", "link-citations=true", `
        "--metadata", "targetimagetype=$imagetype")

foreach ($filter in $preprocessingfilters) {
    $allargs = $allargs + @(`
    "--lua-filter", "$filter")
}

$allargs = $allargs + @(`
        "--lua-filter", "$filters/common/extractmetadata.lua", `
        "--lua-filter", "$filters/html/macros.lua", `
        # "--filter", "pandoc-xnos", `
        "--lua-filter", "$filters/html/environments.lua", `
        "--lua-filter", "$filters/html/references.lua", `
        "--lua-filter", "$filters/html/images.lua", `
        "--metadata-file", "$macrospath", `
        "--citeproc",
    "--standalone")

if ($templatefile -ne "") {
    $allargs = $allargs + @(`
            "--template", $templatepath)
}

if ($csslink -ne "") {
    $allargs = $allargs + @(`
            "--css", $csslink)
}

if ($bibfile -ne "") {
    $bibpath = Resolve-Path -Path $bibfile
    $bibpath = $bibpath -replace '[\\]', "/"
    $allargs += "--bibliography=$bibpath"
}

if ($Verbose) {
    $allargs += "--verbose"
}

& pandoc $allargs

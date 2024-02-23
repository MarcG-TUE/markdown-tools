../scripts/make-document `
    -inputfile ./document.md `
    -additionalinputfiles ./document2.md `
    -outputfile ./document.pdf `
    -macrosfile ./metadata/macros.yaml `
    -bibfile ./references.bib `
    -pandocVariables @("fontsize=12pt","geometry:margin=1.3in")


../scripts/make-document-html `
    -inputfile ./document.md `
    -additionalinputfiles ./document2.md `
    -outputfile ./document.html `
    -macrosfile ./metadata/macros.yaml `
    -bibfile ./references.bib

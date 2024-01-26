../scripts/make-document `
    -inputfile ./document.md `
    -additionalinputfiles ./document2.md `
    -outputfile ./document.pdf `
    -macrosfile ./metadata/macros.yaml `
    -bibfile ./references.bib


../scripts/make-document-html `
    -inputfile ./document.md `
    -additionalinputfiles ./document2.md `
    -outputfile ./document.html `
    -macrosfile ./metadata/macros.yaml `
    -bibfile ./references.bib

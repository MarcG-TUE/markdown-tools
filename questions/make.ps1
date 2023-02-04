../scripts/make-questions-ans -inputfile ./questions.md -outputfile ./questions.txt
../scripts/make-questions-latex -inputfile ./questions.md -outputfile ./questions.tex
../scripts/make-questions-html -inputfile ./questions.md -outputfile ./dist/questions.html

if (-not (Test-Path -PathType Container ./dist)) {
    New-Item -ItemType Directory -Force -Path ./dist
}
Copy-Item -Recurse -Force -Path ./styles -Destination ./dist/
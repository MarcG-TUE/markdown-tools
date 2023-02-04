../scripts/make-questions-ans -inputfile ./questions.md -outputfile ./questions.txt

../scripts/make-questions-html -inputfile ./questions.md -outputfile ./dist/questions.html

Copy-Item -Recurse -Force -Path ./styles -Destination ./dist/
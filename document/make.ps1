pandoc ./document.md `
    --output ./document.pdf `
    --to pdf `
    --include-in-header header.tex `
    --lua-filter ../filters/environments.lua `
    --lua-filter ../filters/images.lua `
    --from markdown

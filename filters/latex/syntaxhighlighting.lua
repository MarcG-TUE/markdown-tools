function CodeBlock(block)
    print(block.classes[1])
    print(block)
    -- if block.classes[1] == "abc" then
    --     local img = abc2eps(block.text, filetype)
    --     local fname = pandoc.sha1(img) .. "." .. filetype
    --     pandoc.mediabag.insert(fname, mimetype, img)
    --     return pandoc.Para{ pandoc.Image({pandoc.Str("abc tune")}, fname) }
    -- end
    return {
        pandoc.RawInline("latex", "abc"),
        block
    }
end
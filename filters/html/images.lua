function Image (el)
    -- print("Image", el.caption)
    -- print("Image", el.src)
    -- print("Image", el.title)
    -- print("Image", el.attr)
    -- print("Image", el.identifier)
    -- print("Image", el.classes)
    -- print("Image", el.attributes)
    -- return el
    el.src = string.gsub(el.src, "%.pdf", ".png")
    return el
end

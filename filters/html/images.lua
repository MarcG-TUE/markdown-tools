local targetImageType = nil

-- replace pdf by png
function Image (el)
    -- print("Image", el.caption)
    -- print("Image", el.src)
    -- print("Image", el.title)
    -- print("Image", el.attr)
    -- print("Image", el.identifier)
    -- print("Image", el.classes)
    -- print("Image", el.attributes)
    -- return el

    -- get image type from  metadata

    if targetImageType == nil then
        targetImageType = "png"
    end
    el.src = string.gsub(el.src, "%.pdf", "."..targetImageType)
    return el
end

function Meta(m)
    if (m.targetimagetype ~= nil) then
        targetImageType = m.targetimagetype
    end
    return m
end

return {
    {Meta = Meta},
    {Image = Image}
    }
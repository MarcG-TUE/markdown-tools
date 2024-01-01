local function Image (el)
    -- print("Image", el.caption)
    -- print("Image", el.src)
    -- print("Image", el.title)
    -- print("Image", el.attr)
    -- print("Image", el.attr.classes)
    -- print("Image", el.identifier)
    -- print("Image", el.classes)
    -- print("Image", el.attributes)
    local attrs=""
    for k,v in pairs(el.attributes) do
        attrs = attrs .. k .. "=" .. v
    end
    if el.attr.classes:includes('inline') then
        return
        pandoc.List({pandoc.RawInline('latex', "\\custominlinefig{"..el.src.."}{")})
        .. pandoc.List({pandoc.RawInline('latex', attrs.."}")})
    else
        return
        pandoc.List({pandoc.RawInline('latex', "\\customfig{"..el.src.."}{")})
        .. pandoc.List(el.caption)
        .. pandoc.List({pandoc.RawInline('latex', "}{\\label{"..el.identifier.."}}{"..attrs.."}")})
    end
end

local function Figure (f)

    -- find the image in f.content
    -- hoping that the structure does not change much...
    local img = f.content[1].content[1]
    local attrs=""
    local externalUrl = nil
    for k,v in pairs(img.attributes) do
        if k == "external-url" then
            externalUrl = v
        else
            attrs = attrs .. k .. "=" .. v
        end
    end

    local ext = pandoc.List({})
    if externalUrl ~= nil then
        ext = pandoc.List({pandoc.Link(" (link)", externalUrl)})
    end
    return pandoc.Para(pandoc.List({pandoc.RawInline('latex', "\\customfig{"..img.src.."}{")})
    ..img.caption
    ..ext
    ..pandoc.List({pandoc.RawInline('latex', "}{\\label{"..f.identifier.."}}{"..attrs.."}")}))

end

return {
    {Figure = Figure},
    {Image = Image}
  }
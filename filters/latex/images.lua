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
        pandoc.List({pandoc.RawInline('latex', "\\compmodinlinefig{"..el.src.."}{")})
        .. pandoc.List({pandoc.RawInline('latex', attrs.."}")})
    else
        return
        pandoc.List(
            {
                pandoc.RawInline('latex', "\\compmodinlinefig{"..el.src.."}{"..attrs.."}")
            }
        )
    end

end

local function Figure (f)
    return f
end

return {
    {Figure = Figure},
    {Image = Image}
  }
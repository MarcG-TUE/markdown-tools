function Image (el)
    local attrs=""
    for k,v in pairs(el.attributes) do
        attrs = attrs .. k .. "=" .. v
    end
    if el.attr.classes:includes('inline') then
        return 
        pandoc.List({pandoc.Str("«Insert Image: "..el.src.."»")})
    else
        return 
        pandoc.List({pandoc.Str("«Insert Image: "..el.src.."»")})
    end
end
local title = ""

-- If title is not set in meta data take it from the first header

function Header(el)
    if title == "" then
        if el.level == 1 then
            title = pandoc.utils.stringify(el)
        end
    end
end

function Meta(m)
    if m.title == nil then
        m.title = title
    end
    if m['foot-text'] == nil then
        m['foot-text'] = ""
    end
    local metadata = "{\n\"title\": \""..pandoc.utils.stringify(m.title).."\",\n"
    metadata = metadata .. "\"foot-text\": \""..pandoc.utils.stringify(m['foot-text']).."\"\n}\n"
    local file = io.open("extracted-metadata.json",'w')
    if file ~= nil then
        file:write(metadata)
        file:close()
    end
    return m
end

return {
    { Header = Header },
    { Meta = Meta }
}

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
    return m
end

return {
    { Header = Header },
    { Meta = Meta }
}

function Div (elem)
    if elem.classes:includes('definition') then
        -- print(elem.attributes)
        name  = elem.attributes["name"]
        label = elem.attributes["label"]
        return {
            pandoc.RawInline('latex', '\\begin{definitionbox}{' .. name .. '}{\\label{' .. label .. '}}'),
            elem,
            pandoc.RawInline('latex', '\\end{definitionbox}')
        }
    end
    if elem.classes:includes('theorem') then
        name  = elem.attributes["name"]
        label = elem.attributes["label"]
        if name == nil then
            nameStr = ""
        else
            nameStr = "[" .. name .. "]"
        end
        if label == nil then
            labelStr = ""
        else
            labelStr = "\\label{" .. label .. "}"
        end
        return {
            pandoc.RawInline('latex', '\\begin{theorem}' .. nameStr .. '{' .. labelStr .. '}'),
            elem,
            pandoc.RawInline('latex', '\\end{theorem}')
        }
    end
    if elem.classes:includes('lemma') then
        name  = elem.attributes["name"]
        label = elem.attributes["label"]
        if name == nil then
            nameStr = ""
        else
            nameStr = "[" .. name .. "]"
        end
        if label == nil then
            labelStr = ""
        else
            labelStr = "\\label{" .. label .. "}"
        end
        return {
            pandoc.RawInline('latex', '\\begin{lemma}' .. nameStr .. '{' .. labelStr .. '}'),
            elem,
            pandoc.RawInline('latex', '\\end{lemma}')
        }
    end
end


-- catch references to these environments

function Cite(c)
    for i, item in ipairs(c.citations) do
        if item.id ~= nil then
            if item.id:find("^exc:") ~= nil then
                return pandoc.RawInline('latex', '\\ref{' .. item.id .. '}')
            end
        end    
    end
    return c
end


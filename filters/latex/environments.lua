function Div(elem)
    if elem.classes:includes('definition') then
        -- print(elem.attributes)
        local name  = elem.attributes["name"]
        local nameStr = ""
        if name ~= nil then
            nameStr = name
        end
        local labelStr = ""
        local label = elem.attributes["label"]
        if label ~= nil then
            labelStr = '\\label{' .. label .. '}'
        end
        return {
            pandoc.RawInline('latex', '\\begin{definitionbox}{' .. nameStr .. '}{'..labelStr..'}'),
            elem,
            pandoc.RawInline('latex', '\\end{definitionbox}')
        }
    end
    if elem.classes:includes('example') then
        -- print(elem.attributes)
        local name  = elem.attributes["name"]
        local nameStr = ""
        if name ~= nil then
            nameStr = name
        end
        local labelStr = ""
        local label = elem.attributes["label"]
        if label ~= nil then
            labelStr = '\\label{' .. label .. '}'
        end
        return {
            pandoc.RawInline('latex', '\\begin{examplebox}{' .. nameStr .. '}{'..labelStr..'}'),
            elem,
            pandoc.RawInline('latex', '\\end{examplebox}')
        }
    end
    if elem.classes:includes('background') then
        -- print(elem.attributes)
        local name  = elem.attributes["name"]
        local nameStr = ""
        if name ~= nil then
            nameStr = name
        end
        local labelStr = ""
        local label = elem.attributes["label"]
        if label ~= nil then
            labelStr = '\\label{' .. label .. '}'
        end
        return {
            pandoc.RawInline('latex', '\\begin{backgroundbox}{' .. nameStr .. '}{'..labelStr..'}'),
            elem,
            pandoc.RawInline('latex', '\\end{backgroundbox}')
        }
    end
    if elem.classes:includes('theorem') then
        local name  = elem.attributes["name"]
        local label = elem.attributes["label"]
        local nameStr
        local labelStr
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
        local name  = elem.attributes["name"]
        local label = elem.attributes["label"]
        local nameStr
        local labelStr
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
    if elem.classes:includes('proof') then
        return {
            pandoc.RawInline('latex', '\\begin{proof}'),
            elem,
            pandoc.RawInline('latex', '\\end{proof}')
        }
    end

end

function Span(elem)
    if elem.classes:includes('remark') then
        return {
            pandoc.RawInline('latex', '\\remark{'),
            elem,
            pandoc.RawInline('latex', '}')
        }
    end
    if elem.classes:includes('hl-blue') then
        return {
            pandoc.RawInline('latex', '{\\color{blue}{'),
            elem,
            pandoc.RawInline('latex', '}}')
        }
    end
    if elem.classes:includes('hl-purple') then
        return {
            pandoc.RawInline('latex', '{\\color{purple}{'),
            elem,
            pandoc.RawInline('latex', '}}')
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

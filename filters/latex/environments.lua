
local folderOfThisFile = PANDOC_SCRIPT_FILE:match("(.-)[^/]+$")
local refmap = dofile(folderOfThisFile .. "../common/referencesmap.lua")

refmap.clearReferences()

function Div(elem)
    if elem.classes:includes('definitionbox') then
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
    if elem.classes:includes('result') then
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
            pandoc.RawInline('latex', '\\begin{resultbox}{' .. nameStr .. '}{'..labelStr..'}'),
            elem,
            pandoc.RawInline('latex', '\\end{resultbox}')
        }
    end
    if elem.classes:includes('definition') then
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
            pandoc.RawInline('latex', '\\begin{definition}' .. nameStr .. '{' .. labelStr .. '}'),
            elem,
            pandoc.RawInline('latex', '\\end{definition}')
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

-- search in paragraphs for a label following a formula, of the form {eq:id}. pandoc does not keep them together
function Para(p)
    local prev = nil
    -- collect updated content to remove the label from the output
    local newContent = {}
    -- go through all content of the paragraph
    for _,v in ipairs(p.content) do
        local isTag = false
        -- tags show up a Str elements
        if v.tag=="Str" then
            -- check if the text of the Str is a label {#<env>:<id>}
            local i, _, label = v.text:find("{#(.*)}")
            if (i ~= nil) then
                isTag = true
                local textLabel = refmap.addLabelFor('equation', label)
                if prev ~= nil then
                    if prev.tag == "Math" then
                        -- add tag to the formula to make mathjax show it as an equation number
                        prev.text = prev.text .. "\\tag{".. textLabel .."}"
                    end
                end
            end
        end
        -- preserve all content except the label
        if not isTag then
            table.insert(newContent, v)
        end
        prev = v
    end
    p.content = newContent
    return p
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

function Meta(m)
    local metaMap = pandoc.MetaMap(refmap.allReferences())
    m.references = metaMap
    return m
end

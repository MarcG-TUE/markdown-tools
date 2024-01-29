local folderOfThisFile = PANDOC_SCRIPT_FILE:match("(.-)[^/]+$")
local refmap = dofile(folderOfThisFile .. "../common/referencesmap.lua")

refmap.clearReferences()

function Div (elem)
    for i, e in ipairs(refmap.environments) do
        if elem.classes:includes(e) then
            local name  = elem.attributes["name"]
            local label = elem.attributes["label"]
            local textLabel = refmap.addLabelFor(e, label)
            local nameStr
            if name == nil then
                nameStr = ""
            else
                nameStr = " (" .. name .. ")"
            end
            elem.content:insert(1, pandoc.Strong(pandoc.Str(refmap.captionEnvironments[e].." ".. textLabel ..nameStr)))
            elem.identifier = label
            return elem
        end
    end
end

function Figure(el)
    local label = el.identifier
    local textLabel = refmap.addLabelFor('figure', label)
    if el.caption ~= nil then
        el.caption.long:insert(1, pandoc.Str("Figure "..textLabel .. ": "))
    end
    return el
end

function Meta(m)
    local metaMap = pandoc.MetaMap(refmap.allReferences())
    m.references = metaMap
    return m
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

function Header(h)
    local id = h.attr.identifier
    local i, _, label = id:find("(sec:.*)")
    if (i ~= nil) then
        refmap.addSectionLabelFor(h.level, label)
    else
        refmap.updateSectionCounter(h.level)
    end
end
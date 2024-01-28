local counters = {}

local folderOfThisFile = PANDOC_SCRIPT_FILE:match("(.-)[^/]+$")
local refmap = dofile(folderOfThisFile .. "../common/referencesmap.lua")

refmap.clearReferences()

local function nextNumber(c)
    if counters[c] == nil then
        counters[c] = 0
    end
    counters[c] = counters[c] + 1
    return counters[c]
end

function Div (elem)
    for i, e in ipairs(refmap.environments) do
        if elem.classes:includes(e) then
            local name  = elem.attributes["name"]
            local label = elem.attributes["label"]
            local number = tostring(nextNumber(refmap.shortEnvironments[e]))
            if label ~= nil then
                refmap.setReference(label, number)
            end
            local nameStr
            if name == nil then
                nameStr = ""
            else
                nameStr = " (" .. name .. ")"
            end
            elem.content:insert(1, pandoc.Strong(pandoc.Str(refmap.captionEnvironments[e].." "..number..nameStr)))
            elem.identifier = label
            return elem
        end
    end
end

function Figure(el)
    local label = el.identifier
    if (label ~= nil) then
        local number = tostring(nextNumber(refmap.shortEnvironments['figure']))
        refmap.setReference(label, number)
    end
    return el
end

function Meta(m)
    local metaMap = pandoc.MetaMap(refmap.allReferences())
    m.references = metaMap
    return m
  end

function Para(p)
    local prev = nil
    local newContent = {}
    for _,v in ipairs(p.content) do
        local isTag = false
        if v.tag=="Str" then
            local i, _, label = v.text:find("{#(.*)}")
            if (i ~= nil) then
                isTag = true
                local number = tostring(nextNumber(refmap.shortEnvironments['equation']))
                refmap.setReference(label, number)
                if prev ~= nil then
                    if prev.tag == "Math" then
                        prev.text = prev.text .. "\\tag{".. tostring(number) .."}"
                    end
                end
            end
        end
        if not isTag then
            table.insert(newContent, v)
        end
        prev = v
    end
    p.content = newContent
    return p
end
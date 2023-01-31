local counters = {
    def = 0,
    exc = 0,
    exa = 0,
    thm = 0,
    alg = 0
}

local folderOfThisFile = PANDOC_SCRIPT_FILE:match("(.-)[^/]+$")
local refmap = dofile(folderOfThisFile .. "../common/referencesmap.lua")

refmap.clearReferences()

local function nextNumber(c)
    counters[c] = counters[c] + 1
    return counters[c]
end

function Div (elem)
    if elem.classes:includes('grey') then
        return elem
    end
    if elem.classes:includes('definition') then
        local name  = elem.attributes["name"]
        local label = elem.attributes["label"]
        local number = tostring(nextNumber("def"))
        refmap.setReference(label, number)
        elem.content:insert(1, pandoc.Strong(pandoc.Str("Definition "..number.." (" .. name .. ")")))
        elem.identifier = label
        return elem
    end
    if elem.classes:includes('definitionbox') then
        return elem
    end
    if elem.classes:includes('definition-nobox') then
        local name  = elem.attributes["name"]
        local label = elem.attributes["label"]
        local number = tostring(nextNumber("def"))
        refmap.setReference(label, number)
        elem.content:insert(1, pandoc.Strong(pandoc.Str("Definition "..number.." (" .. name .. ")")))
        elem.identifier = label
        return elem
    end
    if elem.classes:includes('exercise') then
        local name  = elem.attributes["name"]
        local label = elem.attributes["label"]
        local number = tostring(nextNumber("exc"))
        refmap.setReference(label, number)
        elem.identifier = label
        elem.content:insert(1, pandoc.Strong(pandoc.Str("Exercise "..number.." (" .. name .. ")")))
        return elem
    end
    if elem.classes:includes('example') then
        local name  = elem.attributes["name"]
        local label = elem.attributes["label"]
        local number = tostring(nextNumber("exa"))
        refmap.setReference(label, number)
        elem.content:insert(1, pandoc.Strong(pandoc.Str("Example "..number.." (" .. name .. ")")))
        elem.identifier = label
        return elem
    end
    if elem.classes:includes('algorithm') then
        local name  = elem.attributes["name"]
        local label = elem.attributes["label"]
        local number = tostring(nextNumber("alg"))
        refmap.setReference(label, number)
        elem.content:insert(1, pandoc.Strong(pandoc.Str("Algorithm "..number.." (" .. name .. ")")))
        elem.identifier = label
        return elem
    end
    if elem.classes:includes('background') then
        return elem
    end
    if elem.classes:includes('result') then
        return elem
    end
    if elem.classes:includes('theorem') then
        local name  = elem.attributes["name"]
        local label = elem.attributes["label"]
        local number = tostring(nextNumber("thm"))
        refmap.setReference(label, number)
        local nameStr
        if name == nil then
            nameStr = ""
        else
            nameStr = " (" .. name .. ")"
        end
        elem.content:insert(1, pandoc.Strong(pandoc.Str("Theorem " ..number.. nameStr)))
        elem.identifier = label
        return elem
    end

end

function Meta(m)
    local metaMap = pandoc.MetaMap(refmap.allReferences())
    m.references = metaMap
    return m
  end
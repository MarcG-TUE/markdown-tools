local folderOfThisFile = PANDOC_SCRIPT_FILE:match("(.-)[^/]+$")
local refmap = dofile(folderOfThisFile .. "../common/referencesmap.lua")

function Meta(m)
    local references = m.references
    if (references ~= nil) then
        refmap.setReferences(references)
    end
    -- for k,v in pairs(refmap.references) do
    --     print(k .. " -> " .. v)
    -- end
end

function Cite (c)
    if #(c.citations) == 1 then
        local cite = c.citations[1]
        if refmap.isTag(cite.id) then
            if refmap.hasReference(cite.id) then
                local storedRef = refmap.getReference(cite.id)
                return pandoc.RawInline('latex', storedRef)
            else
                return pandoc.RawInline('latex', "\\ref{"..cite.id.."}")
            end
        end
        return c
    else
        return c
    end
end

return {
    { Meta = Meta },
    { Cite = Cite }
}
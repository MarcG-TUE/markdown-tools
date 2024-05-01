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

function Cite(c)
    if #(c.citations) == 1 then
        local cite = c.citations[1]
        if refmap.isTag(cite.id) then
            return pandoc.RawInline('html', '<a href="#' .. cite.id .. '">' .. refmap.getReference(cite.id) .. '</a>')
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

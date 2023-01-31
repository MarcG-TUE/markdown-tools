local folderOfThisFile = PANDOC_SCRIPT_FILE:match("(.-)[^/]+$")
local refmap = dofile(folderOfThisFile .. "../common/referencesmap.lua")

function Meta(m)
    local references = m.references
    refmap.setReferences(references)
end

function Cite(c)
    if #(c.citations) == 1 then
        local cite = c.citations[1]
        if cite.id:find("^def:") ~= nil or
            cite.id:find("^exa:") ~= nil or
            cite.id:find("^exc:") ~= nil or
            cite.id:find("^thm:") ~= nil or
            cite.id:find("^eq:") ~= nil or
            cite.id:find("^alg:") ~= nil
        then
            -- return pandoc.Str(getReference(cite.id))
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

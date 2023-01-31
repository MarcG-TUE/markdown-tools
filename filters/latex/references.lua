local folderOfThisFile = PANDOC_SCRIPT_FILE:match("(.-)[^/]+$")
local refmap = dofile(folderOfThisFile .. "../common/referencesmap.lua")

function Cite (c)
    if #(c.citations) == 1 then
        local cite = c.citations[1]
        if refmap.isTag(cite.id) then
            return pandoc.RawInline('latex', "\\ref{"..cite.id.."}")
        end
        return c
    else
        return c
    end
end

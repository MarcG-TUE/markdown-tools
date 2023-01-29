function Cite (c)
    if #(c.citations) == 1 then
        local cite = c.citations[1]
        if 
        cite.id:find("^def:") ~= nil or
        cite.id:find("^exa:") ~= nil or
        cite.id:find("^thm:") ~= nil or
        cite.id:find("^lem:") ~= nil or
        cite.id:find("^eq:") ~= nil or
        cite.id:find("^alg:") ~= nil
        then
            return pandoc.RawInline('latex', "\\ref{"..cite.id.."}")
        end
        return c
    else
        return c
    end
end

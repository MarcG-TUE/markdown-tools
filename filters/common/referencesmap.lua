local refmap =  {}
refmap.references = {}


-- global list of references

function refmap.clearReferences()
    refmap.references = {}
end

function refmap.setReference(k, v)
    if k ~= nil then
        refmap.references[k] = v
    end
end

function refmap.getReference(k)
    local res = refmap.references[k]
    if res == nil then
        print ("Warning: reference " .. k .. " is unknown." )
        return "<Reference " .. k .. " unknown>"
    else
        return res
    end
end

function refmap.allReferences()
    return refmap.references
end

function refmap.setReferences(r)
    refmap.references = r
end

return refmap
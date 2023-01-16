-- global list of references

function ClearReferences()
    References = {}
end

function SetReference(k, v)
    if k ~= nil then
        References[k] = v
    end
end

function GetReference(k)
    local res = References[k]
    if res == nil then
        print ("Warning: reference " .. k .. " is unknown." )
        return "<Reference " .. k .. " unknown>"
    else
        return res
    end
end

function AllReferences()
    return References
end

function SetReferences(r)
    References = r
end

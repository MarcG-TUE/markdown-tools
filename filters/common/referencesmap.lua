local refmap =  {
    references = {},
    types = {"def", "exa", "exc", "thm", "lem", "eq", "alg", "qst", "prb"},
    environments = {'algorithm', 'definition', 'exercise', 'example', 'lemma', 'theorem', 'problem', 'question'},
    shortEnvironments = {
        algorithm = 'alg', 
        definition = 'def',
        exercise = 'exc',
        example = 'exa',
        lemma = 'lem',
        theorem = 'thm',
        question = 'qst',
        problem = 'prb'
    },
    captionEnvironments = {
        algorithm = 'Algorithm', 
        definition = 'Definition',
        exercise = 'Exercise',
        example = 'Example',
        lemma = 'Lemma',
        theorem = 'Theorem',
        question = 'Question',
        problem = 'Problem'
    }
    
}


-- global list of references

function refmap.isTag(t)
    for i, tp in ipairs(refmap.types) do
        if t:find("^"..tp..":") ~= nil then
            return true
        end
    end
    return false
end

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
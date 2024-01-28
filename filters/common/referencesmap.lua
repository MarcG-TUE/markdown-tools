local refmap =  {
    references = {},
    types = {"def", "exa", "exc", "thm", "lem", "eq", "alg", "fig", "prb", "qst"},
    environments = {'algorithm', 'definition', 'exercise', 'example', 'lemma', 'theorem', 'figure', 'problem', 'question'},
    shortEnvironments = {
        algorithm = 'alg',
        definition = 'def',
        exercise = 'exc',
        example = 'exa',
        lemma = 'lem',
        theorem = 'thm',
        figure = 'fig',
        problem = 'prb',
        question = 'qst',
        equation = 'eq'
    },
    captionEnvironments = {
        algorithm = 'Algorithm',
        definition = 'Definition',
        exercise = 'Exercise',
        example = 'Example',
        lemma = 'Lemma',
        theorem = 'Theorem',
        figure = 'Figure',
        problem = 'Problem',
        question = 'Question',
        equation = 'Equation'
    }
}


-- global list of references

function refmap.isTag(t)
    for _, tp in ipairs(refmap.types) do
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
    -- print(k.." => " .. v)
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
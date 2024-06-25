-- global list of references
local refmap = {

    -- map to store the references, mapping symbolic label to actual label
    references = {},

    -- section level to include in numbering, 0 does not include.
    sectionLevelInclude = 1,

    -- short names of the types of references to keep track of, used in labels
    types = { "def", "exa", "exc", "thm", "lem", "eq", "alg", "fig", "prb", "qst", "sec" },

    -- names of the counters
    environments = { 'algorithm', 'definition', 'exercise', 'example', 'lemma', 'theorem', 'figure', 'problem', 'question', 'section' },

    -- map to link them
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
        equation = 'eq',
        section = 'sec'
    },

    -- names of the environments
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
        equation = 'Equation',
        section = 'Section'
    },

    -- keep counters, sections are counted per level
    counters = {
        algorithm = 0,
        definition = 0,
        exercise = 0,
        example = 0,
        lemma = 0,
        theorem = 0,
        figure = 0,
        problem = 0,
        question = 0,
        equation = 0,
        section = {0, 0, 0, 0, 0, 0}
    }

}

-- check if the string is a recognized tag
function refmap.isTag(t)
    for _, tp in ipairs(refmap.types) do
        if t:find("^" .. tp .. ":") ~= nil then
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
    else
        print("Error: key is nil in refmap.setReference")
    end
end

function refmap.getReference(k)
    local res = refmap.references[k]
    if res == nil then
        print("Warning: reference " .. k .. " is unknown.")
        return "<Reference " .. k .. " unknown>"
    else
        return res
    end
end

function refmap.hasReference(k)
    local res = refmap.references[k]
    return res ~= nil
end


function refmap.allReferences()
    return refmap.references
end

function refmap.setReferences(r)
    refmap.references = r
end

-- create text label for section
local function sectionTextLabel(level)
    local k = level
    local result = nil
    while k>=1 do
        if result == nil then
            result = tostring(refmap.counters['section'][k])
        else
            result = tostring(refmap.counters['section'][k]).."."..result
        end
        k = k-1
    end
    return result
end

-- create text label for environments other than section
local function textLabel(env)
    local k = refmap.sectionLevelInclude
    local result = tostring(refmap.counters[env])
    while k>=1 do
        if refmap.counters['section'][k] ~= 0 then
            result = tostring(refmap.counters['section'][k]).."."..result
        end
        k = k-1
    end
    return result
end

local function nextLabel(env)
    if refmap.counters[env] == nil then
        refmap.counters[env] = 0
    end
    refmap.counters[env] = refmap.counters[env] + 1
    return textLabel(env)
end

-- increment the counter for a given level
local function increment_counter(level)
    refmap.counters['section'][level] = refmap.counters['section'][level] + 1
    local k = level+1
    while k<=6 do
      refmap.counters['section'][k] = 0
      k = k+1
    end
    if level <= refmap.sectionLevelInclude then
        for env, cnt in pairs(refmap.counters) do
            if env ~= 'section' then
                refmap.counters[env] = 0
            end
        end
    end
    -- print(pandoc.utils.stringify(refmap.counters['section']))
  end


local function nextSectionLabel(level)
    increment_counter(level)
    return sectionTextLabel(level)
end

function refmap.updateSectionCounter(level)
    nextSectionLabel(level)
end

function refmap.addLabelFor(env, label)
    local textLabel = nextLabel(refmap.shortEnvironments[env])
    if label ~= nil then
        refmap.setReference(label, textLabel)
    end

    return textLabel
end

function refmap.addSectionLabelFor(level, label)
    local textLabel = nextSectionLabel(level)
    if label ~= nil then
        refmap.setReference(label, textLabel)
    end

    return textLabel
end


return refmap

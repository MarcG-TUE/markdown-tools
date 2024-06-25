local Settings = {}
local counters = {}

local folderOfThisFile = PANDOC_SCRIPT_FILE:match("(.-)[^/]+$")
local refmap = dofile(folderOfThisFile .. "../common/referencesmap.lua")

refmap.clearReferences()

local function nextNumber(c)
    if counters[c] == nil then
        counters[c] = 0
    end
    counters[c] = counters[c] + 1
    return counters[c]
end

function Div(elem)

    if elem.classes:includes('problem') then
        local name      = elem.attributes["name"]
        local points    = elem.attributes["points"]
        local pointsStr = ''
        if (points ~= nil) then
            pointsStr = " (" .. points .. " pts)"
        end
        local label = elem.attributes["label"]
        local number = tostring(nextNumber(refmap.shortEnvironments['problem']))
        if label ~= nil then
            refmap.setReference(label, number)
        end

        if HtmlEnvCounter == nil then
            HtmlEnvCounter = 1
        else
            HtmlEnvCounter = HtmlEnvCounter + 1
        end

        local descriptor = Settings.descriptor
        local altDescriptor = elem.attributes["descriptor"]
        if (altDescriptor ~= nil) then
            descriptor = altDescriptor
        end

        elem.content:insert(1, pandoc.Strong(pandoc.Str(descriptor .. " " .. HtmlEnvCounter .. ": " .. name .. pointsStr)))
        return elem
    end

    if elem.classes:includes('question') then
        return elem.content
    end

    if elem.classes:includes('grading') then
        -- ignore if printgrading is false
        if not PrintGrading then
            return pandoc.List({})
        end

        elem.content:insert(1, pandoc.Strong(pandoc.Str("Grading:")))
        return elem
    end

    if elem.classes:includes('answer') then
        -- ignore if printanswers is false
        if not PrintAnswers then
            return pandoc.List({})
        end

        local ref = elem.attributes["ref"]
        if ref == nil then
            print("Warning: generating random id, consider adding 'ref' attribute to answer block.")
            ref = "answer"..tostring(math.random(10000))
        end
        return {
            pandoc.RawInline('html', '<button class="show-answer" id="' .. ref .. '">Show Answers</button>'),
            pandoc.RawInline('html', '<button class="hide-answer" id="' .. ref .. '">Hide Answers</button>'),
            elem
        }
    end

    for i, e in ipairs(refmap.environments) do
        if elem.classes:includes(e) then
            local name  = elem.attributes["name"]
            local label = elem.identifier
            if label == nil then
                label = elem.attributes["label"]
            end
            local number = tostring(nextNumber(refmap.shortEnvironments[e]))
            if label ~= nil then
                refmap.setReference(label, number)
            end
            local nameStr
            if name == nil then
                nameStr = ""
            else
                nameStr = " (" .. name .. ")"
            end
            elem.content:insert(1, pandoc.Strong(pandoc.Str(refmap.captionEnvironments[e].." "..number..nameStr)))
            elem.identifier = label
            return elem
        end
    end

end

function Figure(el)
    local label = el.identifier
    if (label ~= nil) then
        local number = tostring(nextNumber(refmap.shortEnvironments['figure']))
        refmap.setReference(label, number)
    end
    return el
end


function Span(s)
    if s.classes:includes('criterion') then
        local points = s.attributes["points"]
        s.content:insert(1, pandoc.Str("+" .. points .. " "))
        s.content:insert(pandoc.RawInline('html', '<br/>'))
        return s
    end
end


function Meta(m)

    if m.printanswers == nil then
        PrintAnswers = false
    else
        if tostring(m.printanswers[1].text)=="true" then
            PrintAnswers = true
        else
            PrintAnswers = false
        end
    end
    print("Print Answers: " .. tostring(PrintAnswers))

    if m.printgrading == nil then
        PrintGrading = false
    else
        if tostring(m.printgrading[1].text)=="true" then
            PrintGrading = true
        else
            PrintGrading = false
        end
    end
    print("Print Grading: " .. tostring(PrintGrading))

    if m.descriptor == nil then
        Settings.descriptor = "Question"
    else
        Settings.descriptor = m.descriptor[1].text
    end
    print("Descriptor set to: " .. Settings.descriptor)
    return m
end

function Meta2(m)

    local metaMap = pandoc.MetaMap(refmap.allReferences())
    m.references = metaMap

    return m
end

-- search in paragraphs for a label following a formula, of the form {eq:id}. pandoc does not keep them together
function Para(p)
    local prev = nil
    -- collect updated content to remove the label from the output
    local newContent = {}
    -- go through all content of the paragraph
    for _,v in ipairs(p.content) do
        local isTag = false
        -- tags show up a Str elements
        if v.tag=="Str" then
            -- check if the text of the Str is a label {#<env>:<id>}
            local i, _, label = v.text:find("{#(.*)}")
            if (i ~= nil) then
                isTag = true
                local textLabel = refmap.addLabelFor('equation', label)
                if prev ~= nil then
                    if prev.tag == "Math" then
                        -- add tag to the formula to make mathjax show it as an equation number
                        prev.text = prev.text .. "\\tag{".. textLabel .."}"
                    end
                end
            end
        end
        -- preserve all content except the label
        if not isTag then
            table.insert(newContent, v)
        end
        prev = v
    end
    p.content = newContent
    return p
end

return {
    {Meta = Meta},
    {Span = Span},
    {Para = Para},
    {Figure = Figure},
    {Div = Div},
    {Meta = Meta2}
}

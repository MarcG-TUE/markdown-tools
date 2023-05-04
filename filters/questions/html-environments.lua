local Settings = {}

function Div(elem)
    if elem.classes:includes('problem') then
        local name      = elem.attributes["name"]
        local points    = elem.attributes["points"]
        local pointsStr = ''
        if (points ~= nil) then
            pointsStr = " (" .. points .. " pts)"
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

    if elem.classes:includes('grading') then
        elem.content:insert(1, pandoc.Strong(pandoc.Str("Grading:")))
        return elem
    end

    if elem.classes:includes('answer') then
        -- ignore if printanswers is false
        -- replace all immediate children of type OrderedList by raw 'parts'
        -- wrap other children in \uplevel{}

        if not PrintAnswers then
            return pandoc.List({})
        end

        local ref = elem.attributes["ref"]
        return {
            pandoc.RawInline('html', '<button class="show-answer" id="' .. ref .. '">Show Answers</button>'),
            pandoc.RawInline('html', '<button class="hide-answer" id="' .. ref .. '">Hide Answers</button>'),
            elem
        }
    end
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
    if m.descriptor == nil then
        Settings.descriptor = "Question"
    else
        Settings.descriptor = m.descriptor[1].text
    end
    print("Descriptor set to: " .. Settings.descriptor)
    return m
end

return {
    {Meta = Meta},
    {Span = Span},
    {Div = Div}
}

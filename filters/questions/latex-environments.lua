local Settings = {}

function Div (elem)

    if elem.classes:includes('problems') then
        return {
            pandoc.RawInline('latex', '\\begin{questions}'),
            elem,
            pandoc.RawInline('latex', '\\end{questions}')
        }
    end

    if elem.classes:includes('problem') then
        local name  = elem.attributes["name"]
        local label  = elem.attributes["label"]
        local labelStr = ''
        if (label ~= nil) then
            labelStr = '\\label{'..label..'}'
        end
        local points = elem.attributes["points"]
        local pointsStr = ''
        if (points ~= nil) then
            pointsStr = '  ('..points..' points)'
        end
        local nameStr = ''
        if (name ~= nil) then
            nameStr = name
            local titleStr = nameStr
            if (pointsStr ~= "") then
                if (nameStr ~= "") then
                    titleStr = nameStr .. " " .. pointsStr
                else
                    titleStr = pointsStr
                end
            end
            return {
                pandoc.RawInline('latex', '\\titledquestion{' .. titleStr .. '}' .. labelStr),
                elem
            }
        else
            return {
                pandoc.RawInline('latex', '\\question{'..pointsStr..'}'),
                elem
            }
        end
    end

    if elem.classes:includes('grading') then
        return {
            pandoc.RawInline('latex', '\\textbf{Grading:}\n\n\\begin{itemize}'),
            elem,
            pandoc.RawInline('latex', '\\end{itemize}')
        }
    end

    if elem.classes:includes('answer') then

        -- ignore if printanswers is false
        -- replace all immediate children of type OrderedList by raw 'parts'
        -- wrap other children in \uplevel{}

        if not PrintAnswers then
            return pandoc.List({})
        end

        return elem
    end

end

function  Span (s)
    if s.classes:includes('criterion') then
        local points = s.attributes["points"]
        return {
            pandoc.RawInline('latex', '\\item[+'..points..']'),
            s,
            pandoc.RawInline('latex', '\n'),
        }
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

    if m.descriptor == nil then
        Settings.descriptor = "Question"
    else
        Settings.descriptor = m.descriptor[1].text
        Descriptor = Settings.descriptor
    end
    print("Descriptor set to: " .. Settings.descriptor)

    return m
end


return {
    {Meta = Meta},
    {Span = Span},
    {Div = Div}
}



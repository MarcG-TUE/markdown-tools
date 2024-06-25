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
                pandoc.RawInline('latex', '\\medskip\\titledquestion{' .. titleStr .. '}' .. labelStr..'\\hspace{0.01cm}\\vspace{-\\baselineskip}'),
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

        -- ignore if printgrading is false
        if not PrintGrading then
            return pandoc.List({})
        end

        return {
            pandoc.RawInline('latex', '\\textbf{Grading:}\n\n\\begin{itemize}'),
            elem,
            pandoc.RawInline('latex', '\\end{itemize}')
        }
    end

    if elem.classes:includes('answer') then

        -- ignore if printanswers is false
        if not PrintAnswers then
            return pandoc.List({})
        end

        return {
            pandoc.RawInline('latex', '\\medskip'),
            pandoc.RawInline('latex', '\\textbf{Answers}'),
            pandoc.RawInline('latex', '\\smallskip'),
            elem
        }
    end

    if elem.classes:includes('figure') then
        local label  = elem.identifier
        local caption  = elem.attributes["caption"]
        local captionStr = ""
        if caption ~= nil then
            captionStr = "\\caption{"..caption.."}"
        end


        return
        pandoc.List({
            pandoc.RawInline('latex', "\\begin{figure}[h]"),
            pandoc.RawInline('latex', "\\begin{center}"),
            elem,
            pandoc.RawInline('latex', captionStr),
            pandoc.RawInline('latex', "\\label{"..label.."}"),
            pandoc.RawInline('latex', "\\end{center}"),
            pandoc.RawInline('latex', "\\end{figure}")
        })
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



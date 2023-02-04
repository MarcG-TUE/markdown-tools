function Div (elem)

    if elem.classes:includes('problem') then
        name  = elem.attributes["name"]
        points = elem.attributes["points"]
        return {
            pandoc.RawInline('latex', '\\titledquestion{' .. name .. '} ('..points..' pts)'),
            elem
        }
    end

    if elem.classes:includes('grading') then
        return {
            pandoc.RawInline('latex', '\\textbf{Grading:}\n\n\\begin{itemize}'),
            elem,
            pandoc.RawInline('latex', '\\end{itemize}')
        }
    end
end

function  Span (s)
    if s.classes:includes('criterion') then
        points = s.attributes["points"]
        return {
            pandoc.RawInline('latex', '\\item[+'..points..']'),
            s,
            pandoc.RawInline('latex', '\n'),
        }
    end
end




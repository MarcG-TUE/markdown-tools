
function Div (elem)
    if elem.classes:includes('question') then
        name  = elem.attributes["name"]
        points = elem.attributes["points"]
        elem.content:insert(1, pandoc.Strong(pandoc.Str("Prolem: "..name.." (" .. points .. " pts)")))
        return elem
    end

    if elem.classes:includes('grading') then
        elem.content:insert(1, pandoc.Strong(pandoc.Str("Grading:")))
        return elem
    end

end

function  Span (s)
    if s.classes:includes('criterion') then
        points = s.attributes["points"]
        s.content:insert(1, pandoc.Str("+" .. points .. " "))
        s.content:insert(pandoc.RawInline('html', '<br/>'))
        return s
    end
end

function Div (elem)
    if elem.classes:includes('question') then
        name  = elem.attributes["name"]
        points = elem.attributes["points"]
        elem.content:insert(1, pandoc.Strong(pandoc.Str("Problem: "..name.." (" .. points .. " pts)")))
        return elem.content
    end

    if elem.classes:includes('grading') then
        elem.content:insert(1, pandoc.Strong(pandoc.Str("Grading:")))
        elem.content:insert(2, pandoc.Str("\n"))
        return elem.content
    end

end

function  Span (s)
    if s.classes:includes('criterion') then
        points = s.attributes["points"]
        s.content:insert(1, pandoc.Str("+" .. points .. " "))
        s.content:insert(pandoc.Str("\n\n"))
        return s.content
    end
end

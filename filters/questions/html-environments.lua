function Div (elem)
    if elem.classes:includes('problem') then
        name  = elem.attributes["name"]
        points = elem.attributes["points"]
        pointsStr = ''
        if (points ~= nil) then
            pointsStr = " (" .. points .. " pts)"
        end

        elem.content:insert(1, pandoc.Strong(pandoc.Str("Problem: "..name..pointsStr)))
        return elem
    end

    if elem.classes:includes('grading') then
        elem.content:insert(1, pandoc.Strong(pandoc.Str("Grading:")))
        return elem
    end

    if elem.classes:includes('answer') then
        ref  = elem.attributes["ref"]
        return {
            pandoc.RawInline('html', '<button class="show-answer" id="'..ref..'">Show Answers</button>'),
            pandoc.RawInline('html', '<button class="hide-answer" id="'..ref..'">Hide Answers</button>'),
            elem
        }
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
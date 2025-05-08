


function Div(elem)
    if elem.classes:includes('no-slide-number') then
        print("No slide number")
    end
end

function Header(elem)
    if elem.classes:includes('no-slide-number') then
        pandoc.RawInline('html', '<div>No Slide Number</div>')
        print("No slide number")
    end
end
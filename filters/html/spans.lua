
local function Span(elem)
    if elem.classes:includes('remark') then
        return {
            pandoc.RawInline('html', '<span class="remark"><b>Remark</b>:'),
            elem,
            pandoc.RawInline('html', '</span>')
        }
    end
    if elem.classes:includes('hint') then
        return {
            pandoc.RawInline('html', '<span class="hint"><b>Hint</b>:'),
            elem,
            pandoc.RawInline('html', '</span>')
        }
    end
    if elem.classes:includes('hl-blue') then
        return {
            pandoc.RawInline('html', '<span style="color:blue">'),
            elem,
            pandoc.RawInline('html', '</span>')
        }
    end
    if elem.classes:includes('hl-red') then
        return {
            pandoc.RawInline('html', '<span style="color:red">'),
            elem,
            pandoc.RawInline('html', '</span>')
        }
    end
    if elem.classes:includes('hl-purple') then
        return {
            pandoc.RawInline('html', '<span style="color:purple">'),
            elem,
            pandoc.RawInline('html', '</span>')
        }
    end

    return elem
end


return {
    {Span = Span}
  }
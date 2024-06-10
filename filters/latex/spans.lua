
local function Span (s)
    return s
end

local function Span(elem)
    if elem.classes:includes('remark') then
        return {
            pandoc.RawInline('latex', '\\remark{'),
            elem,
            pandoc.RawInline('latex', '}')
        }
    end
    if elem.classes:includes('hl-blue') then
        return {
            pandoc.RawInline('latex', '{\\color{blue}{'),
            elem,
            pandoc.RawInline('latex', '}}')
        }
    end
    if elem.classes:includes('hl-red') then
        return {
            pandoc.RawInline('latex', '{\\color{red}{'),
            elem,
            pandoc.RawInline('latex', '}}')
        }
    end
    if elem.classes:includes('hl-purple') then
        return {
            pandoc.RawInline('latex', '{\\color{purple}{'),
            elem,
            pandoc.RawInline('latex', '}}')
        }
    end
    if elem.classes:includes("bits") then
        return {
            pandoc.RawInline('latex', '{\\color{blue}\\texttt{'),
            elem,
            pandoc.RawInline('latex', '}}')
        }
    end

    return elem
end


return {
    {Span = Span}
  }
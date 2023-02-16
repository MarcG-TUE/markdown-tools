local revealExtensions = {}

function Meta(m)
  if m["slide-attributes"] then
    revealExtensions.defaultBackground = pandoc.utils.stringify(m["slide-attributes"]["background"])
  end
  if m["title-slide-attributes"] then
    revealExtensions.defaultTitleBackground = pandoc.utils.stringify(m["title-slide-attributes"]["background"])
  end
  revealExtensions.includeCSS = {}
  if m["include-css"] then

    m.extraCss={}
    for i, item in ipairs(m["include-css"]) do
      revealExtensions.includeCSS[i] = item
      table.insert(m.extraCss, item)
    end
  end
  
  return m

end

function Header (elem)
  if elem.attributes["background"] then
    elem.attributes["data-background-iframe"] = "./background/"..elem.attributes["background"]
  else
    if elem.classes:includes('title') then
      if revealExtensions.defaultTitleBackground ~= nil then
        elem.attributes["data-background-iframe"] = "./background/"..revealExtensions.defaultTitleBackground
      end
    else
      if revealExtensions.defaultBackground ~= nil then
        elem.attributes["data-background-iframe"] = "./background/"..revealExtensions.defaultBackground
      end
    end
  end
  return elem
end

function Div (elem)

  if elem.classes:includes('chart') then
    elem.content:insert(1, pandoc.RawInline('html', '<canvas data-chart="scatter">'))
    elem.content:insert(pandoc.RawInline('html', '</canvas>'))
    return elem
  end

  if elem.classes:includes('scatterchart') then
    local attrs = ""
    if elem.attributes["rangeX"] then
      attrs = attrs.." rangeX='"..elem.attributes["rangeX"].."'"
    end
    if elem.attributes["rangeY"] then
      attrs = attrs.." rangeY='"..elem.attributes["rangeY"].."'"
    end
    if elem.attributes["data"] then
      attrs = attrs.." data='"..elem.attributes["data"].."'"
    end
    if elem.attributes["labels"] then
      attrs = attrs.." labels='"..elem.attributes["labels"].."'"
    end
    if elem.attributes["colors"] then
      attrs = attrs.." colors='"..elem.attributes["colors"].."'"
    end
    if elem.attributes["dotSizes"] then
      attrs = attrs.." dotSizes='"..elem.attributes["dotSizes"].."'"
    end
    elem.content:insert(1, pandoc.RawInline('html', '<canvas class="scatterChart" '..attrs..'>'))
    elem.content:insert(pandoc.RawInline('html', '</canvas>'))
    return elem
  end

  if elem.classes:includes('paretoDemo') then
    elem.content:insert(1, pandoc.RawInline('html', '<canvas class="paretoDemo">'))
    elem.content:insert(pandoc.RawInline('html', '</canvas>'))
    return elem
  end

  if elem.classes:includes('speech-bubble') then
    local classes = elem.classes
    elem.classes={}
    if elem.attributes["x"] then
      local px = elem.attributes["x"]
      local py = elem.attributes["y"]
      local fsSpec = ""
      if elem.attributes["font-size"] then
        fsSpec = "font-size: "..elem.attributes["font-size"]..";"
      end
      elem.attributes["style"] = "padding-left: 25px;padding-right: 25px; "..fsSpec
      local sb = pandoc.Div(elem)
      sb.attributes["style"] = "position: absolute; left: "..px.."; top: "..py..";"
      sb.classes = classes
      return sb
    end
    return elem
  end
  
  if elem.classes:includes('text-box') then
    local classes = elem.classes
    elem.classes={}
    if elem.attributes["x"] then
      local px = elem.attributes["x"]
      local py = elem.attributes["y"]
      local fsSpec = ""
      if elem.attributes["font-size"] then
        fsSpec = "font-size: "..elem.attributes["font-size"]..";"
      end
      elem.attributes["style"] = "padding-left: 25px;padding-right: 25px; "..fsSpec
      local sb = pandoc.Div(elem)
      sb.attributes["style"] = "position: absolute; left: "..px.."; top: "..py..";"
      sb.classes = classes
      return sb
    end
    return elem
  end

end

return {
  { Meta = Meta },
  { Header = Header },
  {Div = Div}
}
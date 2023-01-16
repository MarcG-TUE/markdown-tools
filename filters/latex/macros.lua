local folderOfThisFile = PANDOC_SCRIPT_FILE:match("(.-)[^/]+$")
local macroutils = dofile(folderOfThisFile .. "../common/macrosutils.lua")

local function replace (el)
  local replaced
  local res
  res, replaced = macroutils.doSubstitutions(el.text)
  if replaced then
    return pandoc.RawInline('latex', res)
  else
    return pandoc.Str(res)
  end
end

local function replaceMath (el)
  res, _ = macroutils.doSubstitutions(el.text)
  return pandoc.Math(el.mathtype, res)
end

local function replaceImage (el)
  -- perform replacements in the image source and caption
  if el.caption ~= nil then
    -- print("Caption ", el.caption)
  end
  if el.src ~= nil then
    el.src, _ = macroutils.doSubstitutions(Urldecode(el.src))
  end
  if el.title ~= nil then
    el.title, _ = macroutils.doSubstitutions(el.title)
  end
  return el
end

function replaceDiv (d)
  if d.attr.attributes["name"] ~= nil then
    d.attr.attributes["name"], _ = macroutils.doSubstitutions(d.attr.attributes["name"])
  end
  return d
end

return {
  {Meta = macroutils.get_substitutions},
  {Str = replace},
  {Math = replaceMath},
  {Image = replaceImage},
  {Div = replaceDiv}
}



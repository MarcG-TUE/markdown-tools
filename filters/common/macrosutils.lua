local macroutils =  {}
macroutils.substitutions = {}

function macroutils.urlencode (str)
  str = string.gsub (str, "([^0-9a-zA-Z !'()*._~-])", -- locale independent
      function (c) return string.format ("%%%02X", string.byte(c)) end)
  str = string.gsub (str, " ", "+")
  return str
end

function macroutils.urldecode (str)
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)", function(h) return string.char(tonumber(h,16)) end)
  return str
end

function macroutils.add_substitutions(s)
  local numArgs
  for km, vm in pairs(s) do
    local stot = ""
    for i = 1, #vm do
      stot = stot .. vm[i].text
    end
    if km:find("#(%d+)") ~= nil then
        local start
        start, _, numArgs = km:find("#(%d+)")
        numArgs = tonumber(numArgs)
        km = km:sub(1, start-1)
    else numArgs = 0
    end
    macroutils.substitutions[km] = {numArgs=numArgs, subst = stot}
  end
end

function macroutils.get_substitutions (meta)
  for k, v in pairs(meta) do
    if k=="macros" then
      macroutils.add_substitutions(v)
    end
    -- add output format specific substitutions
    if FORMAT:match 'latex' then
      if k=="macros-latex" then
        macroutils.add_substitutions(v)
      end
    end
    if FORMAT:match 'html' then
      if k=="macros-html" then
        macroutils.add_substitutions(v)
      end
    end
  end
end

local function findMatchingClosingBrace(s, k)
  local n = 1
  while n>0 or s:sub(k,k) ~= "}" do
      k = k + 1
    if s:sub(k,k) == "{" then
      n = n + 1
    end
    if s:sub(k,k) == "}" then
      n = n - 1
    end
  end
  return k
end

local function determineArguments(s, start, n)
  -- find the closing string '}}' skipping nested {..}
  -- start points to first argument { or closing }} if n=0
  local res = {}
  local k = start
  while n > 0 do
    local pBegin = k
    if s:sub(k, k) ~= "{" then
      print("Warning: expected '{' symbol, found: ", s:sub(k,k))
      return
    end
    k = findMatchingClosingBrace(s, k)
    table.insert(res, s:sub(pBegin+1, k-1))
    n = n-1
    k = k+1
  end
  return res, k
end

local function replaceArguments(s, args)
  local res = s
  for i = 1, #args do
    local placeholder = "#" .. tostring(i)
    res = res:gsub(placeholder, args[i])
  end
  return res
end

function macroutils.doSubstitutions(s)
  local replaced = false
  local res = s
  local changes = true
  while changes do
    changes = false
    for k, v in pairs(macroutils.substitutions) do
      -- make sure that the next char is { or }
      local pattern = "%{%{"..k.."[%{%}]"
      if res:find(pattern) ~= nil then
        replaced = true
        local numArgs = v.numArgs
        local subst = v.subst
        local b, e, args, et
        b, e = res:find(pattern)
        args, et = determineArguments(res, e, numArgs)
        if args == nil then
          print("Warning: failed to determine arguments of macro "..k:sub(3))
        else
          local replcmnt = replaceArguments(subst, args)
          res = res:sub(1,b-1) .. replcmnt .. res:sub(et+2,res:len())
          changes = true
        end
      end
    end
  end
  return res, replaced
end

return macroutils
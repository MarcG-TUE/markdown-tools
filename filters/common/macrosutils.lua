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

function macroutils.print_substitutions()
  print("Substitutions")
  for km, vm in pairs(macroutils.substitutions) do
    print(("Key: %s"):format(km))
    -- print(("Value: %s"):format(pandoc.utils.stringify(vm)))
    print(("Value: %s"):format(vm.subst))
  end
  print("End")
end

function macroutils.get_substitutions (meta)
  for k, v in pairs(meta) do
    if k=="macros" then
      macroutils.add_substitutions(v)
    end
    if k=="doc-macros" then
      macroutils.add_substitutions(v)
    end
    -- add output format specific substitutions
    if FORMAT:match 'latex' or FORMAT:match 'markdown' then
      if k=="macros-latex" then
        macroutils.add_substitutions(v)
      end
      if k=="doc-macros-latex" then
        macroutils.add_substitutions(v)
      end
    end
    if FORMAT:match 'html' or FORMAT:match 'revealjs' then
      if k=="macros-html" then
        macroutils.add_substitutions(v)
      end
      if k=="doc-macros-html" then
        macroutils.add_substitutions(v)
      end
    end
  end
  meta["macros"] = nil
  meta["doc-macros"] = nil
  meta["macros-latex"] = nil
  meta["doc-macros-latex"] = nil
  meta["macros-html"] = nil
  meta["doc-macros-html"] = nil
  return meta
end

local function findMatchingClosingBrace(s, k)
  local n = 1
  while n>0 or s:sub(k,k) ~= "}" do
      k = k + 1
    if k > s:len() then
      print("Failed to find matching closing brace in string: " .. s)
      return -1
    end
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
    if k==-1 then
      print("Failed to determine arguments")
      return nil, nil
    end
    table.insert(res, s:sub(pBegin+1, k-1))
    n = n-1
    k = k+1
  end
  return res, k
end

local function replaceArgument(s, n, arg)
  local placeholder = "#" .. tostring(n)
  local i, j = string.find(s, placeholder, 1)
  while i ~= nil do
    if tonumber(s:sub(j+1,j+1)) == nil then
      s = s:sub(1, i-1)..arg..s:sub(j+1,#s)
    end
    i, j = string.find(s, placeholder, j)
  end
  return s
end

local function replaceArguments(s, args)
  local res = s
  for i = 1, #args do
    res = replaceArgument(res, i, args[i])
  end
  return res
end

local function checkRemainingMacros(text)
  local pattern = "%{%{(%a%w*)"
  local b=1
  while true do
    local x,y,k =string.find(text,pattern,b)
    if x==nil then break end
      print("Warning: Macro "..k.." used, but not defined.")
      print(text)
      b=y+1
  end
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
  checkRemainingMacros(res)
  return res, replaced
end

return macroutils
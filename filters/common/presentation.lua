local keep_deleting = false
local skip_level = 0

function Block (b)
  if b.t == 'Header' and b.attributes["handout-only"] then
    skip_level = b.level
    keep_deleting = true
    return {}
  elseif b.t == 'Header' and b.level <= skip_level then
      keep_deleting = false
   elseif keep_deleting then
      return {}
   end
end
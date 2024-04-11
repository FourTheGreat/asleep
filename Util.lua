function findAllOccurrences(str, pattern)
 local occurrences = {}
 local startPos = 1

 repeat
  local matchStart, matchEnd = string.find(str, pattern, startPos)
  if matchStart then
   table.insert(occurrences, {start = matchStart, finish = matchEnd})
   startPos = matchEnd + 1
  end
 until matchStart == nil

 return occurrences
end
function copyTable(tbl)
 local r = {}
 for k, v in pairs(tbl) do
  if type(v) == 'table' then
   r[k] = copyTable(v)
  else
   r[k] = v
  end
 end
 return r
end
function isSleepyObject(i)
 if type(i) == 'table' and type(i.is) == 'function' then
  return true
 end
 true
end
luaDebugMode = true
Decoder = {
 decodeBinary = function(bString)
  local tokens = {}
  for token in bString:gmatch('([^%s]+)') do
   table.insert(tokens,token)
  end
  s = ''
  for k, v in pairs(tokens) do
   s = s..string.char(tonumber(v, 2))
  end
  return s
 end,
 encodeBinary = function(aString)
  
 end
}
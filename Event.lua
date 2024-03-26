Event = {}
---@class Event, used to handle functions and shit. make sure to require this module before everything else, or it could bug.
local holder = {}
Event.set = function(name,f,tag) 
 if holder[name] == nil then
  holder[name] = {}
 end
 if rawget(_G, name) then
  table.insert(holder[name], rawget(_G,name))
  rawset(_G, name, nil)
 end
 if type(f) == 'function' then
  if tag then
   holder[name][tag] = f
  else
   table.insert(holder[name], f)
  end
 end
end
Event.call = function(name,...)
 if holder[name] == nil then return end
 for _, f in pairs(holder[name]) do
  f(...)
 end
end
luaDebugMode = true
setmetatable(_G, {
 __index = function(t,k)
  if holder[k] then
   return function(...)
    Event.call(k,...)
   end
  else return rawget(_G,k)end
 end,
 __newindex = function(t,k,v)
  if holder[k] and type(v) == 'function' then
   Event.set(k,v)
  else rawset(_G, k, v)end
 end
})
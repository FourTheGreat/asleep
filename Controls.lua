no = 'no'
luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+asleep.)')..'?.lua;'
require 'Event'

Controls = {}

Controls.binds = {}

Controls.pressed = {}
Controls.justPressed = {}
Controls.released = {}
Controls.addBinds = function(name,binds)
 local e = binds
 if type(binds) == 'string' then e = {binds} end
 if type(e) ~= 'table' then return end
 for k,v in pairs(e) do
  e[k] = v:upper()
 end
 Controls.binds[name] = e
end

setmetatable(Controls.pressed, {
 __index = function(t,k)
  if Controls.binds[k] then
   for _,v in pairs(Controls.binds[k]) do
    if keyboardPressed(v:upper()) then
     return true
    end
   end
   return false
  end
  return keyboardPressed(k:upper())
 end,
 __newindex = function()
  return no
 end
})
setmetatable(Controls.justPressed, {
 __index = function(t,k)
  if Controls.binds[k] then
   for _,v in pairs(Controls.binds[k]) do
    if keyboardJustPressed(v:upper()) then
     return true
    end
   end
   return false
  end
  return keyboardJustPressed(k:upper())
 end,
 __newindex = function()
  return no
 end
})
setmetatable(Controls.released, {
 __index = function(t,k)
  if Controls.binds[k] then
   for _,v in pairs(Controls.binds[k]) do
    if keyboardJustReleased(v:upper()) then
     return true
    end
   end
   return false
  end
  return keyboardJustReleased(k:upper())
 end,
 __newindex = function()
  return no
 end
})

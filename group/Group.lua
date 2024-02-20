luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+scripts/)')..'?.lua;'
local Basic = import'asleep.Basic'
local Group = Basic.extend('Group')

Group.setField('members',{})
Group.setField('forEach',function(I,func)
 for k,v in pairs(I.members) do
  func(v)
 end
end)

return Group
luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+asleep.)')..'?.lua;'
require'Basic'
Group = Basic.extend('Group')

Group.setField('members',{})
Group.setField('foreach',function(I,func)
 for k,v in pairs(I.rawget('members')) do
  func(v,k)
 end
end)
Group.setField('length', 0, function(I)return(#I.rawget('members'))end,'never')
Group.setField('add', function(I,obj)
 table.insert(I.rawget('members'),obj)
end)
Group.setField('remove', function(I,id)
 table.remove(I.rawget('members'),id)
end)
Group.setField('get', function(I,id)
 if I.rawget('members')[id] ~= nil then
  debugPrint('bruh')
  return I.rawget('members')[id]
 end
end)

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
Group.setField('indexOf', function(I,obj)
 I.foreach(function(i,l)
  if i == obj then
   return l
  end
 end)
 return false
end)
Group.setField('remove', function(I,id)
 if type(id) == 'number' then
  table.remove(I.rawget('members'),id)
 elseif I.indexOf(id) then
  table.remove(I.rawget('members'),I.indexOf(id))
 end
end)
Group.setField('clear', function(I)
 I.rawset('members', {})
end)
Group.setField('get', function(I,id)
 if I.members[id] ~= nil then
  debugPrint('bruh')
  return I.members[id]
 end
end)
Group.new = function()
 local I = Group.createInstance()
 return I
end
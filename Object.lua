luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+asleep.)')..'?.lua;'
require'Basic'
Object = Basic.extend('Object')
Object.nullGet = function(I,k)
 return getProperty(I.rawget('tag')..'.'..k)
end
Object.nullSet = function(I,k,v)
 setProperty(I.rawget('tag')..'.'..k,v)
end
Object.forceIndex = true
Object.forceNewIndex = true

Object.setField('set', Object.nullSet)
Object.setField('get', Object.nullGet)

Object.setField('updateHitbox', function(I)
 updateHitbox(I.tag)
 return I
end)

Object.setField('tag', '', 'default', 'never')

Object.new = function(tag)
 local I = Object.createInstance()
 I.rawset('tag',tag)
 return I
end
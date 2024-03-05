luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+asleep.)')..'?.lua;'
require'Basic'
require'Color'
require'group.Group'
FancyText = Basic.extend('FancyText')
FancyText.setField('alive', false)
FancyText.setField('letters', nil, 'default', 'never')
FancyText.setField('text', '', 'default', function(I,k,v,c)
 if type(v) == 'string' then
  if v:len() < c:len() then
   I.rawget('letters').foreach(function(l,i)
    if i > v:len() then
     l.destroy()
     I.rawget('letters').remove(i)
    end
   end)
  elseif v:len() > c:len() then
   for i = c:len()+1, v:len() do
    I.rawget('letters').add(Letter.new())
   end
  end
 end
 I.rawget('letters').foreach(function(l,i)
  l.setLetter(v:sub(i,i))
  debugPrint(v:sub(i,i))
 end)
 I.rawset('text',v)
end)
FancyText.setField('x', 0, 'default', function(I,k,v,c)
 I.rawget('letters').members[1].x = v
 I.rawget('letters').foreach(function(l,i)
  if i>1 then
   l.x = I.rawget('letters').members[i-1].x + I.rawget('letters').members[i-1].width
  end
 end)
end)
FancyText.setField('camera', 'camGame', 'default', function(I,k,v,c)
 I.rawget('letters').foreach(function(l,i)
  l.camera = v
 end)
end)
FancyText.setField('add', function(I)
 I.rawset('alive', true)
 I.rawget('letters').foreach(function(l,i)
  l.add()
 end)
end)
FancyText.setField('remove', function(I)
 I.rawset('alive', false)
 I.rawget('letters').foreach(function(l,i)
  l.remove()
 end)
end)
FancyText.new = function()
 local I = FancyText.createInstance()
 I.rawset('letters', Group.new())
 return I
end
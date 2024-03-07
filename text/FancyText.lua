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
 I.rawset('text',v)
 I.reloadText()
end)
FancyText.setField('color', Color.white, 'default', function(I,k,v,c)
 local t = ''
	if type(v) == 'string' then
		t = 'fromHex'
		I.rawget('color').hexCode = v
	elseif type(v) == 'table' then
		if v.is then
			if v.rawget('type') == 'Color' then
				I.rawset('color', nil)
				I.rawset('color', v)
			end
		else
   local c = I.rawget('color')
			c.r = v[1] or 0
			c.g = v[2] or 0
			c.b = v[3] or 0
			c.a = v[4] or 255
		end
	elseif type(v) == 'number' then
		I.rawget('color').intValue = v
	end
	I.reloadText()
end)
FancyText.setField('reloadText', function(I)
 I.rawget('letters').members[1].x = I.x
 I.rawget('letters').foreach(function(l,i)
  l.setLetter(I.text:sub(i,i))
  l.color = I.color
  if i>1 then
   l.x = I.rawget('letters').members[i-1].x + I.rawget('letters').members[i-1].width
  end
  l.y = I.y
  if I.alive then
   l.add()
  else
   l.remove()
  end
 end)
end)
FancyText.setField('x', 0, 'default', function(I,k,v,c)
 I.rawset('x',v)
 I.reloadText()
end)
FancyText.setField('y', 0, 'default', function(I,k,v,c)
 I.rawset('y',v)
 I.reloadText()
end)
FancyText.setField('camera', 'camGame', 'default', function(I,k,v,c)
 I.rawget('letters').foreach(function(l,i)
  l.camera = v
 end)
 I.reloadText()
end)
FancyText.setField('add', function(I)
 I.rawset('alive', true)
 I.reloadText()
end)
FancyText.setField('remove', function(I)
 I.rawset('alive', false)
 I.reloadText()
end)
FancyText.new = function()
 local I = FancyText.createInstance()
 I.rawset('letters', Group.new())
 return I
end

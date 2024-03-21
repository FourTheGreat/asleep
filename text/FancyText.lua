luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+asleep.)')..'?.lua;'
require'Basic'
require'Color'
require'text.Letter'
require'group.Group'
require'Util'
FancyText = Basic.extend('FancyText')
FancyTextCounter = 0

FancyText.setField('alive', false)
FancyText.setField('letters', nil, 'default', 'never')
FancyText.setField('text', '', 'default', function(I,k,v,c)
 if type(v) == 'string' then
  if v:len() < I.letters.length then
   repeat
    I.letters.members[v:len()+1].destroy()
    I.letters.remove(v:len()+1)
   until I.letters.length == v:len()
  elseif v:len() > I.letters.length then
   for i = I.letters.length+1, v:len() do
    I.letters.add(Letter.new(FancyText.indexOf(I)))
   end
  end
 end
 I.rawset('text',v)
 I.reloadText()
 debugPrint(I.letters.length..' '..v:len())
end)
FancyText.setField('spaceBetween', 0, 'default', function(I,k,v,c)
 I.rawset('spaceBetween', v)
 I.reloadText()
end)
FancyText.setField('color', nil, 'default', function(I,k,v,c)
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
FancyText.setField('concat', function(I,text)
 I.text = I.rawget('text')..text
end)
FancyText.setField('setEffects', function(I,st,en,ef)
 I.letters.foreach(function(l,i)
  if type(st) == 'number' and type(en) == 'table' then --start is number, end is table, sets all after start.
   if i >= st then
    l.loadEffects(en)
   end
  elseif type(st) == 'number' and type(en) == 'number' and type(ef) == 'table' then --start is number, end is number, effect is table, sets all between.
   if i >= st and i <= en then
    l.loadEffects(ef)
   end
  elseif type(st) == 'table' then --start is table, sets all letters.
   l.loadEffects(st)
  elseif type(st) == 'string' then --start is a string, sets where the text matches.
   local o = findAllOccurrences(I.text,st)
   for k,v in pairs(o) do
    I.setEffects(v.start,v.finish,en)
   end
  end
 end)
 I.reloadText()
end)

FancyText.setField('reloadText', function(I)
 I.letters.foreach(function(l,i)
  l.setLetter(I.text:sub(i,i))
  if not l.customAlpha then l.alpha = I.alpha end
  if not l.customAngle then l.angle = I.angle end
  if not l.customColor then l.color = I.color end
  l.camera = I.camera
  I.letters.members[1].x = I.x
  if I.text:sub(i,i) == ' ' then
   l.setLetter('a')
   l.rawset('customAlpha', true)
   l.alpha = 0
  end
  if i>1 then
   if I.alignment == 'right' then
    l.x = I.letters.members[i-1].x - l.width - I.spaceBetween
    if I.text:sub(i-1,i-1) == ' ' then
     l.x = l.x + (l.width/2)
    end
    debugPrint(l.x)
   else
    l.x = I.letters.members[i-1].x + I.letters.members[i-1].width + I.spaceBetween
    if I.text:sub(i-1,i-1) == ' ' then
     l.x = l.x - (l.width/2)
    end
   end
  end
  l.y = I.y
  if l.letter == ',' then
   l.y = l.y + l.get('height')
  end
  if I.alive then
   l.add(I.front)
  else
   l.remove(I.front)
  end
 end)
 if I.letters.length > 0 and I.alignment == 'center' then
  I.letters.members[1].x = I.letters.members[1].x -(I.letters.members[1].width/2)
  local offset = I.letters.members[I.letters.length].x - I.letters.members[1].x
  I.letters.foreach(function(l,i)
   l.x = l.x - offset/2
  end)
  I.letters.members[1].x = I.letters.members[1].x +(I.letters.members[1].width/2)
 end
end)
FancyText.setField('alpha', 1, 'default', function(I,k,v,c)
 I.rawset('alpha',v)
 I.reloadText()
end)
FancyText.setField('angle', 0, 'default', function(I,k,v,c)
 I.rawset('angle',v)
 I.reloadText()
end)
FancyText.setField('x', 0, 'default', function(I,k,v,c)
 I.rawset('x',v)
 I.reloadText()
end)
FancyText.setField('y', 0, 'default', function(I,k,v,c)
 I.rawset('y',v)
 I.reloadText()
end)
FancyText.setField('size', 30, 'default', function(I,k,v,c)
 I.rawset('size',v)
 I.reloadText()
end)
FancyText.setField('camera', 'camHUD', 'default', function(I,k,v,c)
 I.rawset('camera', v)
 I.reloadText()
end)
FancyText.setField('alignment', 'left', 'default', function(I,k,v,c)
 I.rawset('alignment', v)
 I.reloadText()
end)
FancyText.setField('front',false)
FancyText.setField('add', function(I, front)
 I.rawset('alive', true)
 I.rawset('front', front or false)
 I.reloadText()
end)
FancyText.setField('remove', function(I)
 I.rawset('alive', false)
 I.reloadText()
end)

FancyText.new = function()
 local I = FancyText.createInstance()
 I.rawset('letters', Group.new())
 I.rawset('color', Color.white)
 return I
end
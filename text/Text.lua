luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+asleep.)')..'?.lua;'
require'Basic'
require'Color'
Text = Basic.extend('Text')
TextCounter = 0

Text.set = function(I,k,v,c)
	I.set(k,v)
	I.rawset(k,v)
end
Text.get = function(I,k,v)
	local g = getProperty(I.rawget('tag')..'.'..k)
	if g == I.rawget('tag')..'.'..k then
		return I.rawget(k)
	end
	return getProperty(I.rawget('tag')..'.'..k)
end
Text.defaultGet = Text.get

Text.setField('text', '', Text.get, Text.set)
Text.setField('alignment', 'left', 'default', function(I,k,v,c)setTextAlignment(I.rawget('tag'),v)end)
Text.setField('size', 16, 'default', function(I,k,v,c)setTextSize(I.rawget('tag'),v)end)

Text.setField('tag','')
Text.setField('x',0, Text.get, Text.set)
Text.setField('y',0, Text.get, Text.set)
Text.setField('alpha',1, Text.get, Text.set)
Text.setField('visible',true, Text.get, Text.set)
Text.setField('angle',0, Text.get, Text.set)
Text.setField('camera','camGame',function(I,k,v)
	return I.rawget('camera')
end, function(I,k,v,c)
	setObjectCamera(I.rawget('tag'), v)
	I.rawset('camera',v)
end)
Text.setField('color', nil, 'default', function(I,k,v,c)
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
		I.rawget('color').subCode = v
	end
	setTextColor(I.rawget('tag'),I.rawget('color').subCode)
end)

Text.setField('add', function(I,f)
	addLuaText(I.rawget('tag'), f)
	I.doUpdate = true
	return I
end)
Text.setField('remove', function(I)
	removeLuaText(I.rawget('tag'), false)
	I.doUpdate = false
	return I
end)
Text.setField('destroy', function(I)
	removeLuaText(I.rawget('tag'))
	I = nil
end)

Text.setField('get', Text.get)
Text.setField('set', function(I,K,V)
	setProperty(I.rawget('tag')..'.'..K,V)
end)

Text.onUpdate = function(I)
	setTextColor(I.rawget('tag'),I.rawget('color').subCode)
end
Text.setField('_update', Text.onUpdate)

Text.new = function(image)
	local I = Text.createInstance()
	TextCounter = TextCounter+1
	I.rawset('color', Color.white)
	I.rawset('tag', 'AText'..TextCounter)
	makeLuaText(I.rawget('tag'))
	return I
end
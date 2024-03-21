luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+asleep.)')..'?.lua;'
require'Basic'
require'Color'

Sprite = Basic.extend('Sprite')
local SpriteCounter = 0

Sprite.set = function(I,k,v,c)
	I.set(k,v)
	I.rawset(k,v)
end
Sprite.get = function(I,k,v)
	debugPrint(k)
	local g = getProperty(I.rawget('tag')..'.'..k)
	if g == I.rawget('tag')..'.'..k then
		return I.rawget(k)
	end
	return I.get(k)
end
Sprite.forceIndex = true
Sprite.defaultGet = Sprite.get

Sprite.setField('tag','')
Sprite.setField('x',0, Sprite.get, Sprite.set)
Sprite.setField('y',0, Sprite.get, Sprite.set)
Sprite.setField('alpha',1, Sprite.get, Sprite.set)
Sprite.setField('visible',true, Sprite.get, Sprite.set)
Sprite.setField('angle',0, Sprite.get, Sprite.set)
Sprite.setField('camera','camGame',function(I,k,v)
	return I.rawget('camera')
end, function(I,k,v,c)
	setObjectCamera(I.rawget('tag'), v)
	I.rawset('camera',v)
end)
Sprite.setField('color', nil, 'default', function(I,k,v,c)
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
	I.set('color', I.rawget('color').intValue)
end)

Sprite.setField('makeGraphic',function(I,w,h,c)
 local col = Color.white
	makeGraphic(I.rawget('tag'), w,h,col.intValue)
 I.color = (c or Color.white)
	I.update()
	return I
end)
Sprite.setField('loadGraphic',function(I,img, w, h)
	loadGraphic(I.rawget('tag'), img, w, h)
	I.color = Color.white
	I.update()
	return I
end)

Sprite.setField('add', function(I,f)
	addLuaSprite(I.rawget('tag'), f)
	I.doUpdate = true
	I.update()
	return I
end)
Sprite.setField('remove', function(I)
	removeLuaSprite(I.rawget('tag'), false)
	I.doUpdate = false
	return I
end)
Sprite.setField('destroy', function(I)
	removeLuaSprite(I.rawget('tag'))
	I = nil
end)

Sprite.setField('get', function(I,k,v)
	return getProperty(I.rawget('tag')..'.'..k)
end)
Sprite.setField('set', function(I,k,v)
	setProperty(I.rawget('tag')..'.'..k,v)
	return I
end)
Sprite.setField('rset', function(I,k,v)
	I[k] = v
	return I
end)

Sprite.onUpdate = function(I)
	I.set('color', I.rawget('color').intValue)
	return I
end
Sprite.setField('_update', Sprite.onUpdate)

Sprite.new = function(x,y,image)
	local I = Sprite.createInstance()
	SpriteCounter = SpriteCounter+1
	I.rawset('color', Color.white)
	I.rawset('tag', 'ASprite'..SpriteCounter)
	makeLuaSprite(I.rawget('tag'),image)
	I.x = x or 0
	I.y = y or 0
	return I
end

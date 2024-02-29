luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+scripts/)')..'?.lua;'
require'asleep.Basic'
require'asleep.Color'

Sprite = Basic.extend('Sprite')
local SpriteCounter = 0

Sprite.set = function(I,k,c,v)
	I.set(k,v)
	I.rawset(k,v)
end
Sprite.get = function(I,k,v)
	return I.get(k)
end

Sprite.setField('tag','')
Sprite.setField('x',0, Sprite.get, Sprite.set)
Sprite.setField('y',0, Sprite.get, Sprite.set)
Sprite.setField('alpha',1, Sprite.get, Sprite.set)
Sprite.setField('visible',true, Sprite.get, Sprite.set)
Sprite.setField('angle',0, Sprite.get, Sprite.set)
Sprite.setField('camera','camGame',function(I,K,V)
	return I.rawget('camera')
end, function(I,K,C,V)
	setObjectCamera(I.tag, V)
	I.rawset('camera',V)
end)
Sprite.setField('color', Color.white, 'default', function(I,k,c,v)
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
	makeGraphic(I.tag, w,h,col.intValue)
 I.color = (c or Color.white)
	I.update()
end)
Sprite.setField('loadGraphic',function(I,img, w, h)
	loadGraphic(I.tag, img, w, h)
	I.update()
end)

Sprite.setField('add', function(I,f)
	addLuaSprite(I.tag, f)
	I.doUpdate = true
end)
Sprite.setField('remove', function(I)
	removeLuaSprite(I.tag, false)
	I.doUpdate = false
end)
Sprite.setField('destroy', function(I)
	removeLuaSprite(I.tag)
	I = nil
end)

Sprite.setField('get', function(I,K)
	if getProperty(tostring(I.rawget('tag'))..'.'..tostring(K)) then
		return getProperty(I.rawget('tag')..'.'..K)
	else
		return I.rawget(K)
	end
end)
Sprite.setField('set', function(I,K,V)
	setProperty(I.rawget('tag')..'.'..K,V)
end)


Sprite.onUpdate = function(I)
end
Sprite.setField('_update', Sprite.onUpdate)

Sprite.new = function(image)
	local I = Sprite.createInstance()
	SpriteCounter = SpriteCounter+1
	I.color.rawset('parent',I)
	I.rawset('tag', 'ASprite'..SpriteCounter)
	makeLuaSprite(I.tag,image)
	return I
end
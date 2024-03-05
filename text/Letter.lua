luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+asleep.)')..'?.lua;'
require'text.LetterAnimations'
require'Basic'
require'Color'

Letter = Basic.extend('Letter')
Letter.forceIndex = true
local LetterCounter = 0

Letter.set = function(I,k,v,c)
	I.set(k,v)
	I.rawset(k,v)
end
Letter.get = function(I,k,v)
	return getProperty(I.rawget('tag')..'.'..k)
end
Letter.defaultGet = Letter.get

Letter.setField('tag','')
Letter.setField('x',0, Letter.get, Letter.set)
Letter.setField('y',0, Letter.get, Letter.set)
Letter.setField('alpha',1, Letter.get, Letter.set)
Letter.setField('visible',true, Letter.get, Letter.set)
Letter.setField('angle',0, Letter.get, Letter.set)
Letter.setField('camera','camGame',function(I,k,v)
	return I.rawget('camera')
end, function(I,k,v,c)
	setObjectCamera(I.rawget('tag'), v)
	I.rawset('camera',v)
end)
Letter.setField('color', nil, 'default', function(I,k,v,c)
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

Letter.setField('set', function(I,K,V)
	setProperty(I.rawget('tag')..'.'..K,V)
end)

Letter.setField('setLetter', function(I,letter)
 playAnim(I.rawget('tag'), letter)
end)

Letter.setField('add', function(I,f)
	addLuaSprite(I.rawget('tag'), f)
	I.doUpdate = true
end)
Letter.setField('remove', function(I)
	removeLuaSprite(I.rawget('tag'), false)
	I.doUpdate = false
end)
Letter.setField('destroy', function(I)
	removeLuaSprite(I.rawget('tag'))
	I = nil
end)

Letter.new = function(font)
 I = Letter.createInstance()
 LetterCounter = LetterCounter+1
 local tag = 'ALetter'..LetterCounter
 I.rawset('tag',tag)
 makeAnimatedLuaSprite(tag, '../'..debug.getinfo(1,'S').source:sub(7):match('(.+asleep.)')..'assets/fonts/default')
 for _,anim in pairs(LetterAnimations) do
  addAnimationByPrefix(tag, anim[2], anim[1])
 end
 return I
end
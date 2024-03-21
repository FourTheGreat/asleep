luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+asleep.)')..'?.lua;'
require'text.LetterAnimations'
require'Basic'
require'Color'

Letter = Basic.extend('Letter')
Letter.forceIndex = true
local LetterCounter = 0

Letter.set = function(I,k,v,c)
	I.rawset(k,v)
	I.set(k,v)
end
Letter.get = function(I,k,v)
	local g = I.get(k)
	if g == I.rawget('tag')..'.'..k then
		return I.rawget(k)
	end
	return I.get(k)
end
Letter.TGet = function(I,k,v)
	return I.rawget(k)
end
Letter.defaultGet = Letter.get

Letter.setField('tag','', Letter.TGet)
Letter.setField('shake', {x=0,y=0}, Letter.TGet)
Letter.setField('shakeTimer', 0, Letter.TGet)
Letter.setField('curShakeTimer', 0, Letter.TGet)

Letter.setField('customAlpha', false, Letter.TGet)
Letter.setField('customAngle', false, Letter.TGet)
Letter.setField('customColor', false, Letter.TGet)

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

Letter.setField('loadEffects', function(I,ef)
	if type(ef) == 'table' then
		if ef.angle then
			if ef.angle == false then
				I.rawset('customAngle',false)
			else
				I.rawset('customAngle',true)
				I.angle = ef.angle
			end
		end
		if ef.alpha then
			if ef.alpha == false then
				I.rawset('customAlpha', false)
			else
				I.rawset('customAlpha', true)
				I.alpha = ef.alpha
			end
		end
		if ef.color then
			if ef.color == false then
				I.rawset('customColor', false)
			else
				I.rawset('customColor', true)
				I.color = ef.color
			end
		end
		if ef.shake and type(ef.shake) == 'table' then
			I.shake.x = ef.shake.x or (ef.shake[1] or 0)
			I.shake.y = ef.shake.y or (ef.shake[2] or 0)
			I.shakeTimer = ef.shake.delay or (ef.shake[3] or 0)
		end
	end
end)

Letter.setField('scale', function(I,x,y)
	scaleObject(I.rawget('tag'),x,y)
end)

Letter.setField('get', function(I,K)
	return getProperty(I.rawget('tag')..'.'..K)
end)
Letter.setField('set', function(I,K,V)
	setProperty(I.rawget('tag')..'.'..K,V)
end)

Letter.setField('setLetter', function(I,letter)
	I.rawset('letter', letter)
	playAnim(I.rawget('tag'), letter)
end)

Letter.setField('letter', '', 'default', function(I,k,v,s)I.setLetter(v)end)

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
local function f(r)return(getRandomInt(-r,r))end
Letter.update = function(I,e)
	I.set('offset.x', f(I.shake.x))
	I.set('offset.y', f(I.shake.y))
end
Letter.setField('_update', Letter.update)

Letter.new = function(prefixTag)
 local I = Letter.createInstance()
 LetterCounter = LetterCounter+1
 local tag = prefixTag..'ALetter'..LetterCounter
	I.rawset('tag', tag)
	I.rawset('color', Color.white)
 makeAnimatedLuaSprite(tag, '../'..debug.getinfo(1,'S').source:sub(7):match('(.+asleep.)')..'assets/fonts/default')
 for _,anim in pairs(LetterAnimations) do
  addAnimationByPrefix(tag, anim[2], anim[1])
 end
 return I
end
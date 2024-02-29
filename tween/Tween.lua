luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+scripts/)')..'?.lua;'
require'asleep.Types'
require'asleep.Timer'
require'asleep.tween.EaseFuncs'
Tween = Timer.extend('Tween')

Tween.setField('obj', '')
Tween.setField('vars', {})
Tween.setField('varStarts', {})
Tween.setField('objMode', false)
Tween.setField('easeFunc', 'linear')
Tween.onUpdate = function(I,e)
	Tween.super.onUpdate(I,e)
 for k, v in pairs(I.rawget('vars')) do
  local o = I.rawget('obj')
  local s = I.rawget('varStarts')
  local f = EaseFuncs[I.rawget('ease')] or EaseFuncs.linear
  if I.rawget('objMode') then
   o[k]=f(v,s[k],I.rawget(curTime)/I.rawget('maxTime'))
  else
   setProperty(o..'.'..k,f(v,s[k],I.rawget('curTime')/I.rawget('maxTime')))
  end
 end
end
Tween.setField('_update', Tween.onUpdate)
Tween.new = function(obj, vars, time, ease, onComplete)
	local I = Tween.createInstance(time,1,onComplete)
 I.rawset('obj', obj)
 if type(obj) ~= 'string' then--assume it's an asleep object in any case where it's not a string.
  I.rawset('objMode',true)
 end
 I.rawset('vars',vars)
 I.rawset('ease', ease or 'linear')
 local starters = {}
 for k, v in pairs(vars) do
  if I.rawget('objMode') then
   starters[k] = obj.rawget(k)
  else
   starters[k] = getProperty(obj..'.'..k)
  end
 end
 I.rawset('varStarts',starters)
 I.run()
	return I
end
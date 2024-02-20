luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+scripts/)')..'?.lua;'
require'asleep.Basic'
require'asleep.Sprite'
Bar = Basic.extend('Bar')
Bar.setField('front', nil, 'default', 'never')
Bar.setField('back', nil, 'default', 'never')
Bar.setField('bg', nil, 'default', 'never')

Bar.setField('cur', 0.5, 'default', function(I,k,v,c)
 I.rawset('cur',v)
 I.reloadBar()
end)
Bar.setField('max', 1, 'default', function(I,k,v,c)
 I.rawset('max', v)
 I.reloadBar()
end)
Bar.setField('percent', 50, 'default', function(I,k,v,c)
 I.rawset('cur',I.rawget('max')*(v/100))
 I.reloadBar()
end)

Bar.setField('reloadBar',function(I)
 local tween = Tween.
end)

Bar.setField('tweening', false)
Bar.setField('tweenTime', 0.1)

Bar.setField('percentFunc', function(I,p)return((I.rawget('cur')/I.rawget('max'))*(p and 100 or 1)) end)
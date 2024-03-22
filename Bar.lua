luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+asleep.)')..'?.lua;'
require'Basic'
require'Sprite'
require'Color'
require'tween.Tween'

Bar = Basic.extend('Bar')
Bar.setField('front', nil, 'default', 'never')
Bar.setField('back', nil, 'default', 'never')
Bar.setField('border', nil, 'default', 'never')

Bar.setField('frontColor', Color.green, 'default', function(I,k,v,c)
 if I.leftToRight then
  I.front.color = v
  I.rawset('frontColor', I.front.rawget('color'))
 else
  I.back.color = v
  I.rawset('frontColor', I.back.rawget('color'))
 end
end)
Bar.setField('backColor', Color.red, 'default', function(I,k,v,c)
 if I.leftToRight then
  I.back.color = v
  I.rawset('frontColor', I.back.rawget('color'))
 else
  I.front.color = v
  I.rawset('frontColor', I.front.rawget('color'))
 end
end)
Bar.setField('borderColor', Color.black, 'default', function(I,k,v,c)
 I.border.color = v
 I.rawset('borderColor', I.border.rawget('color'))
end)

Bar.setField('camera', 'camGame', 'default', function(I,k,v,c)
 I.border.camera = v
 I.back.camera = v
 I.front.camera = v
 I.rawset('camera',v)
end)

Bar.setField('x', 0, 'default', function(I,k,v,c)
 I.border.x = v
 I.back.x = v
 I.front.x = v
 I.rawset('x',v)
end)
Bar.setField('y', 0, 'default', function(I,k,v,c)
 I.border.y = v
 I.back.y = v
 I.front.y = v
 I.rawset('y',v)
end)

Bar.setField('add', function(I, t)
 I.border.add(t)
 I.back.add(t)
 I.front.add(t)
end)
Bar.setField('remove', function(I)
 I.border.remove()
 I.back.remove()
 I.front.remove()
end)

Bar.setField('min', 0, 'default', function(I,k,v,c)
 I.rawset('percent', (I.cur - v) / I.max)
 I.rawset('min', v)
 I.reloadBar()
end)
Bar.setField('max', 1, 'default', function(I,k,v,c)
 I.rawset('percent', (I.cur - I.min) / v)
 I.rawset('max', v)
 I.reloadBar()
end)
Bar.setField('cur', 0.5, 'default', function(I,k,v,c)
 I.rawset('percent', (v - I.min) / I.max)
 I.rawset('cur', v)
 I.reloadBar()
end)

Bar.setField('overlay', false)
Bar.setField('leftToRight', true)

Bar.setField('percent', 50, 'default', function(I,k,v,c)
 I.rawset('cur', (I.max - I.min) * (v/100))
 I.reloadBar()
end)
Bar.setField('visiblePercent', 50)

Bar.setField('barTween', nil)

Bar.setField('tween', true)

Bar.setField('reloadBar', function(I)
 I.rawset('barTween', Tween.reuse(I.barTween, I, {visiblePercent=(((I.cur-I.min)/I.max)*100)},0.25,'quadOut'))
 if I.leftToRight then
  I.front.set('_frame.frame.width', I.back.get('width') * (I.visiblePercent/100))
 else
  I.front.set('_frame.frame.width', I.back.get('width') - (I.back.get('width') * (I.visiblePercent/100)))
 end
 if I.overlay then
  setObjectOrder(I.border.rawget'tag', getObjectOrder(I.front.rawget'tag')+1)
 else
  setObjectOrder(I.border.rawget'tag', getObjectOrder(I.back.rawget'tag')-1)
 end
end)

Bar.setField('loadGraphic', function(I,g)
 I.border.loadGraphic(g)
 I.front.loadGraphic(g..'Fill')
 I.back.loadGraphic(g..'Fill')
 I.borderColor = Color.white
end)

Bar.update = function(I)
 I.front.color = I.frontColor
 I.back.color = I.backColor
 I.reloadBar()
end
Bar.setField('_update', Bar.update)

Bar.new = function()
 local I = Bar.createInstance()
 I.rawset('border', Sprite.new())
 I.rawset('front', Sprite.new())
 I.rawset('back', Sprite.new())

 I.rawset('barTween', Tween.new(I,{visiblePercent=50},0.25,'quadOut'))

 I.border.makeGraphic(500,40, Color.black)
 I.front.makeGraphic(500,40, Color.green)
 I.back.makeGraphic(500,40, Color.red)
 return I
end
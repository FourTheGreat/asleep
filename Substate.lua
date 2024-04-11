luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+asleep.)')..'?.lua;'
require'Event'
require'Class'

Substate = Class.new('Substate')
Substate.setField('name', '')
Substate.setField('pauseGame', false)
Substate.setField('firstFrame', true)

Substate.setField('children', {})
Substate.setField('clearChildren', function(I)
 for _,obj in pairs(I.children) do
  obj.destroy()
 end
 I.rawset('children', {})
end)
Substate.setField('addChild', function(I,child)
 table.insert(I.rawget('children'), child)
end)

Substate.setField('update', function(I,e)end)
Substate.setField('create', function(I,e)end)
Substate.setField('onDestroy', function(I,e)end)

Substate.open = function(sub)
 if runHaxeCode('return game.subState == null') then
  openCustomSubstate(sub.name, sub.pauseGame)
  sub.create()
 end
end
Substate.close = function()
 closeCustomSubstate()
end
Substate.update = function(e)end
Event.set('onCustomSubstateUpdate', function(name,e)
 Substate.update(e)
 for _,I in pairs(Substate.instances) do
  if name == I.name then
   I.update(e)
   if I.firstFrame then
    I.firstFrame = false
   end
  end
 end
end)
Event.set('onCustomSubstateDestroy', function(name)
 for _,I in pairs(Substate.instances) do
  if name == I.name then
   I.onDestroy()
  end
 end
end)

Substate.new = function(name, pauseGame)
 local I = Substate.createInstance()
 I.rawset('name', name)
 I.rawset('pauseGame', pauseGame)
 return I
end
luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+asleep.)')..'?.lua;'
require'Event'

Substate = Class.new('Substate')
Substate.setField('name', '')
Substate.setField('pause', false)
Substate.setField('open', false)

Substate.hasOpen = false
Substate.openedStates = {}
Substate.gamePaused = false
Substate.pauseTime = 0

Substate.new = function(name, pause)
 local I = Substate.createInstance()
 I.name = name
 I.pause = (type(pause) == 'boolean' and pause or false)
 return I
end
Substate.open = function(substate)
 
end
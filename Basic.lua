luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+asleep.)')..'?.lua;'
require'Event'
require'Class'
Basic = Class.new('Basic')
BasicCounter = 0

Basic.setField('_update', function()end)
Basic.setField('update', function()end)
Basic.setField('doUpdate', true)

Event.set('onUpdate')
Basic.new = function()
	BasicCounter = BasicCounter+1
	local I = Basic.createInstance()
	Event.set('onUpdate', function(e)
		I._update(e)
		I.update(e)
	end, 'ABasic'..BasicCounter)
	return I
end
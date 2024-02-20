luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+scripts/)')..'?.lua;'
require'asleep.Class'
Basic = Class.new('Basic')

Basic.setField('_update', function()end)
Basic.setField('update', function()end)
Basic.setField('doUpdate', true)
Basic.update = function(e)end

function onUpdate(e)
	for _, I in pairs(Basic.instances) do
		I._update(e)
		I.update(e)
	end
 Basic.update(e)
end
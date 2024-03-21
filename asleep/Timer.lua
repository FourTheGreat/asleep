luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+scripts/)')..'?.lua;'
require'asleep.Basic'
Timer = Basic.extend('Timer')

Timer.setField('curTime',0)
Timer.setField('maxTime',0)
Timer.setField('loops', 1)
Timer.setField('running', false)
Timer.setField('onComplete',function()end)
Timer.setField('run',function(I)
	I.rawset('curTime', 0)
	I.rawset('running',true)
end)
Timer.setField('cancel',function(I)
	I.destroy()
end)
Timer.setField('pause', function(I)
	I.rawset('running', false)
end)
Timer.setField('resume', function(I)
	I.rawset('running',true)
end)

Timer.onUpdate = function(I,e)
	if I.rawget('running') then I.rawset('curTime', I.rawget('curTime')+e) end
	if I.rawget('curTime') >= I.maxTime and I.rawget('running') then
		if I.rawget('loops') == -1 then
			I.run()
		else
			I.rawset('loops',I.rawget('loops')-1)
			if I.rawget('loops') > 0 then
				I.run()
			else
				I.rawset('running', false)
			end
		end
		I.onComplete(I.rawget('loops'))
 end
end

Timer.setField('_update', Timer.onUpdate)

Timer.new = function(time,loops,onComplete)
	local I = Timer.createInstance()
	I.rawset('maxTime',  time or 1)
	I.rawset('loops',  loops or 1)
	I.onComplete = onComplete or function()end
	return I
end

luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+scripts/)')..'?.lua;'
EaseFuncs = {
	linear = function(goal,start,t)
		if type(start) ~= 'number' then return 0 end
		if type(goal) ~= 'number' then return 0 end
		if type(t) ~= 'number' then return 0 end
  local diff = goal-start
		return diff*t --simplest there is, multiplies the difference by time.
		--t (time) is ALWAYS from 0-1 btw. no matter what the tween's length is, this is percentage.
	end,
	quadIn = function(goal, start, t)
		if type(start) ~= 'number' then return 0 end
		if type(goal) ~= 'number' then return 0 end
		if type(t) ~= 'number' then return 0 end
		local diff = goal - start
		return diff * t * t
	end,
	quadOut = function(goal, start, t)
		if type(start) ~= 'number' then return 0 end
		if type(goal) ~= 'number' then return 0 end
		if type(t) ~= 'number' then return 0 end
		local diff = goal - start
		return -diff * t * (t - 2)
	end,
}

luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+scripts/)')..'?.lua;'
EaseFuncs = {
	linear = function(goal,start,t)
  local diff = goal-start
		return diff*t --simplest there is, multiplies the difference by time.
		--t (time) is ALWAYS from 0-1 btw. no matter what the tween's length is, this is percentage.
	end
}

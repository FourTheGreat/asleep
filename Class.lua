luaDebugMode = true
Class = {}
Class.new = function(name)
	local self = {}
	self.instances = {}
	self.instanceVars = {}
	self.forceIndex = false
	self.setField = function(field, defVal, get, set)
		self.instanceVars[field] = {defVal, get or 'default', set or 'default'}
	end
	self.defaultSet = function(I,k,v,c)
		I.rawset(k,v)
	end
	self.defaultGet = function(I,k)
		return I.rawget(k)
	end
	self.setField('type', name)
	self.setField('is', function(I, class)
		return ((I.type == class.type) or (class.type == 'Any') or (class.type == class))
	end)
 self.getIndexOf = function(instance)
  for k,v in pairs(self.instances) do
   if v == instance then
    return k
   end
  end
 end
 self.setField('destroy', function(I)
  local id = self.getIndexOf(I)
  table.remove(self.instances,id)
  I = nil
 end)
	self.createInstance = function(...)
		local I = {vars={}}
		if self.super then
			I = self.super.new(...)
		end
		setmetatable(I,{})
		for k,v in pairs(self.instanceVars) do
			local val, get, set = v[1], v[2], v[3]
			if type(val) == 'function' then
				I[k] = function(...)val(I,...)end
			else
				I.vars[k] = {val, get, set}
			end
		end
		I.rawset = function(k,v)
			if I.vars[k] then
				I.vars[k][1] = v
			end
		end
		I.rawget = function(k)
			if I.vars[k] then
				return I.vars[k][1]
			end return nil
		end
		setmetatable(I,{
			__index = function(t,k)
				if I.vars[k] then
					field = I.vars[k]
					if type(field[2]) == 'function' then
						return field[2](I,k,I.vars[k][1])
					elseif field[2] == 'default' then
						return self.defaultGet(I,k,I.vars[k][1])
					end
				else
					if self.forceIndex then
						return self.defaultGet(I,k,nil)
					end
				end
			end,
			__newindex = function(t,k,v)
				if I.vars[k] then
					field = I.vars[k]
					if type(field[3]) == 'function' then
						field[3](I,k,v,I.vars[k][1])
					elseif field[2] == 'default' then
						self.defaultSet(I,k,v,I.vars[k][1])
					end
				end
			end
		})
		table.insert(self.instances, I)
		return I
	end
	self.new = function(...)
		return self.createInstance(...)
	end

	self.extend = function(newName)
		local nClass = Class.new(newName)
		nClass.super = self
		return nClass
	end

	return self
end

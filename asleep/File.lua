File = {
	getName = function(src)
		return src:match('(.+[%..+])'):sub(1,-2) or ''
	end,
	getExtention = function(src)
		return src:match('(%..+)') or ''
	end,
	getText = function(n,abs)
		return getTextFromFile(n,abs)
	end,
	save = function(n,c,abs)
		saveFile(n,c,abs)
	end,
	delete = function(n,abs)
		deleteFile(n,abs)
	end,
	move = function(n,f,abs)
		local e = getTextFromFile(n,abs)
		if type(e) == 'string' then
			local success = saveFile(f,e,abs)
			if success then deleteFile(n,abs) end
		end
	end,
}
-- Internal persistence library

--[[ Provides ]]
-- persistence.store(path, ...): Stores arbitrary items to the file at the given path
-- persistence.load(path): Loads files that were previously stored with store and returns them

--[[ Limitations ]]
-- Does not export userdata, threads or most function values
-- Function export is not portable

--[[ License: MIT (see bottom) ]]

-- Private methods
local write, writeIndent, writers, refCount;

local buffPersistCache
local function filewriteCache (data)
  buffPersistCache = buffPersistCache .. data
end


persistence =
{
	store = function (path, ...)
		local file, e
    print ("persist:open-before:", path)
    
		if type(path) == "string" then
			-- Path, open a file
      print ("persist:open-try file:", path)
			file, e = io.open(path, "w")
      print ("persist:opened file:", path)
      buffPersistCache = ""
			if not file then
				return nil, e; --error(e);
			end
		else
			-- Just treat it as file
      print ("persist:open FILE direct !!!!!", path)
			file = path;
		end

		local n = select("#", ...);
		-- Count references
		local objRefCount = {}; -- Stores reference that will be exported
		for i = 1, n do
			refCount(objRefCount, (select(i,...)));
		end;
		-- Export Objects with more than one ref and assign name
		-- First, create empty tables for each
		local objRefNames = {};
		local objRefIdx = 0;
		filewriteCache("-- Persistent Data\nlocal multiRefObjects = {\n");
		for obj, count in pairs(objRefCount) do
			if count > 1 then
				objRefIdx = objRefIdx + 1;
				objRefNames[obj] = objRefIdx;
				filewriteCache("{};"); -- table objRefIdx
			end;
		end;
		filewriteCache("\n} -- multiRefObjects\n");
		-- Then fill them (this requires all empty multiRefObjects to exist)
		for obj, idx in pairs(objRefNames) do
			for k, v in pairs(obj) do
				filewriteCache("multiRefObjects["..idx.."][");
				write(file, k, 0, objRefNames);
				filewriteCache("] = ");
				write(file, v, 0, objRefNames);
				filewriteCache(";\n");
			end;
		end;
		-- Create the remaining objects
		for i = 1, n do
			filewriteCache("local ".."obj"..i.." = ");
			write(file, (select(i,...)), 0, objRefNames);
			filewriteCache("\n");
		end
		-- Return them
		if n > 0 then
			filewriteCache("return obj1");
			for i = 2, n do
				filewriteCache(" ,obj"..i);
			end;
			filewriteCache("\n");
		else
			filewriteCache("return\n");
		end;
    print ("persist:flush cache")
    file:write (buffPersistCache);    -- flush cache
    buffPersistCache = ""  -- clr cache
		file:close();
    print ("persist:Close")
	end;

	load = function (path)
		local f, e = loadfile(path);
		if f then
			return f();
		else
			return nil, e;
		end;
	end;
}

-- Private methods

-- write thing (dispatcher)
write = function (file, item, level, objRefNames)
	writers[type(item)](file, item, level, objRefNames);
end;

-- write indent
writeIndent = function (file, level)
	for i = 1, level do
		filewriteCache("\t");
	end;
end;

-- recursively count references
refCount = function (objRefCount, item)
	-- only count reference types (tables)
	if type(item) == "table" then
		-- Increase ref count
		if objRefCount[item] then
			objRefCount[item] = objRefCount[item] + 1;
		else
			objRefCount[item] = 1;
			-- If first encounter, traverse
			for k, v in pairs(item) do
				refCount(objRefCount, k);
				refCount(objRefCount, v);
			end;
		end;
	end;
end;

-- Format items for the purpose of restoring
writers = {
	["nil"] = function (file, item)
			filewriteCache("nil");
		end;
	["number"] = function (file, item)
			filewriteCache(tostring(item));
		end;
	["string"] = function (file, item)
			filewriteCache(string.format("%q", item));
		end;
	["boolean"] = function (file, item)
			if item then
				filewriteCache("true");
			else
				filewriteCache("false");
			end
		end;
	["table"] = function (file, item, level, objRefNames)
			local refIdx = objRefNames[item];
			if refIdx then
				-- Table with multiple references
				filewriteCache("multiRefObjects["..refIdx.."]");
			else
				-- Single use table
				filewriteCache("{\n");
				for k, v in pairs(item) do
					writeIndent(file, level+1);
					filewriteCache("[");
					write(file, k, level+1, objRefNames);
					filewriteCache("] = ");
					write(file, v, level+1, objRefNames);
					filewriteCache(";\n");
				end
				writeIndent(file, level);
				filewriteCache("}");
			end;
		end;
	["function"] = function (file, item)
			-- Does only work for "normal" functions, not those
			-- with upvalues or c functions
			local dInfo = debug.getinfo(item, "uS");
			if dInfo.nups > 0 then
				filewriteCache("nil --[[functions with upvalue not supported]]");
			elseif dInfo.what ~= "Lua" then
				filewriteCache("nil --[[non-lua function not supported]]");
			else
				local r, s = pcall(string.dump,item);
				if r then
					filewriteCache(string.format("loadstring(%q)", s));    
				else
					filewriteCache("nil --[[function could not be dumped]]");
				end
			end
		end;
	["thread"] = function (file, item)
			filewriteCache("nil --[[thread]]\n");
		end;
	["userdata"] = function (file, item)
			filewriteCache("nil --[[userdata]]\n");
		end;
}

return persistence

--[[
 Copyright (c) 2010 Gerhard Roethlin

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
]]

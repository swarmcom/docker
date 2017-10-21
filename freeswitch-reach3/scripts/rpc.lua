-- retrieve the content of a URL
function fs_err(...)
	freeswitch.consoleLog("err", "LuaRPC " .. string.format(unpack{...}) .. "\n")
end

local lua_id = argv[1]
local uri = string.format("%s/lua/%s", os.getenv("REACH_HOST"), lua_id)

local http = require("socket.http")
local body, code = http.request(uri)
if code ~= 200 then
	fs_err("http lua script uri:%s error:%s", uri, code)
	return code
end

local script, error = loadstring(body)
if not script then
	fs_err("lua script syntax error: %s", error)
	return error
end

script()

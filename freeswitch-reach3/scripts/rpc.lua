-- retrieve the content of a URL
local uri = argv[1]

local http = require("socket.http")
local body, code = http.request(uri)
if code ~= 200 then
	freeswitch.consoleLog("err", "Lua rpc http error: " .. code .. "\n");
	return code
end

local script, error = loadstring(body)
if not script then
	freeswitch.consoleLog("err", "Lua rpc compile error: " .. error .. "\n");
	return error
end

script()

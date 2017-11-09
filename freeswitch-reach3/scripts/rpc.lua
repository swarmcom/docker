-- call format: rpc.lua lua_id lua_token args...
-- intended to be called from freeswitch directly and dynamically load and execute specified code piece
-- scripts can execute a pre-defined set of commands, rpc is one of them

local http = require("socket.http")
local json = require("json")

local lua_id = table.remove(argv, 1)
local lua_token = table.remove(argv, 1)

local uri = string.format("%s/lua/%s", os.getenv("REACH_HOST"), lua_id)
local lua_rpc_uri = string.format("%s/lua/rpc", os.getenv("REACH_HOST"))

function fs_err(...)
	freeswitch.consoleLog("err", "LuaRPC " .. string.format(unpack{...}) .. "\n")
end

function fs_info(...)
	freeswitch.consoleLog("info", "LuaRPC " .. string.format(unpack{...}) .. "\n")
end

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

function rpc(F, ...)
	local request = {
		auth = lua_token,
		type = "call",
		args = {"rpc_lua", F, {...}}
	}
	local encoded_request = json.encode(request)
	local body = {}
	local re, code = http.request{
		url = lua_rpc_uri,
		method = "POST",
		headers = {
			["content-type"] = "application/json",
			["content-length"] = tostring(#encoded_request)
		},
		source = ltn12.source.string(encoded_request),
		sink = ltn12.sink.table(body)
	}
	local response = json.decode(table.concat(body))
	return response.reply
end

local key, value = script(unpack(argv))
if key then
	rpc("result", key, value)
end

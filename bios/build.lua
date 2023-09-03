local data = require("component").data
local fs = require("filesystem")
local f
f = fs.open("/home/default.pub", "r")
local key = f:read(math.huge)
f:close()
local base64 = data.encode64(key)
f = fs.open("/home/bios/bios.lua", "r")
local bios = f:read(math.huge)
f:close()
bios = bios:gsub("BASE64", base64)
f = fs.open("/home/bios/out.lua", "w")
f:write(bios)
f:close()
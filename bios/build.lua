local data = require("component").data
local fs = require("filesystem")
local shell = require("shell")
local args, opts = shell.parse(...)

local key_path = opts["key"] or opts["k"] or "/home/default.pub"
key_path = shell.resolve(key_path)
local bios_path = args[1] or "bios.lua"
bios_path = shell.resolve(bios_path)
local out_path = opts["out"] or opts["o"] or "out.lua"
out_path = shell.resolve(out_path)

if opts["help"] or opts["h"] or not fs.exists(key_path) or not fs.exists(bios_path) then
  print("build [options] [bios file (default: bios.lua)]")
  print("-h --help : show this")
  print("-k --key <path> : public key to embed instead of /home/default.pub")
  print("-o --out <path> : file to output to instead of out.lua")
  return
end

local f
f = fs.open(key_path, "r")
local key = f:read(math.huge)
f:close()
local base64 = data.encode64(key)
f = fs.open(bios_path, "r")
local bios = f:read(math.huge)
f:close()
bios = bios:gsub("BASE64", base64)
f = fs.open(out_path, "w")
f:write(bios)
f:close()
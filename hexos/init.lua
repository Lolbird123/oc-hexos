require = function(file)
  if not fs.exists(file) then
    error("require: "..file.." not found")
  end
  if not fs.exists(file..".sig") then
    error("require: "..file..".sig not found")
  end

  local data = component.proxy(component.list("data")())
  local key = computer.getPublicKey()
  local f
  f = fs.open(file, "r")
  local code = fs.read(f, math.huge)
  fs.close(f)
  f = fs.open(file..".sig", "r")
  local sig = fs.read(f, math.huge)
  fs.close(f)
  if data.ecdsa(code, key, sig) then
    return load(code)()
  else
    error("require: "..file.." does not have a valid signature")
  end
end

local screen = component.list("screen")()
local gpu = component.proxy(component.list("gpu")())
gpu.bind(screen, true)
local w, h = gpu.getResolution()

local f
f = fs.open("/cfg/bg", "r")
gpu.setBackground(tonumber(fs.read(f, math.huge)))
fs.close(f)
f = fs.open("/cfg/fg", "r")
gpu.setForeground(tonumber(fs.read(f, math.huge)))
fs.close(f)
gpu.fill(1, 1, w, h, " ")

local print_line = 1
print = function(str)
  if print_line == h then
    gpu.copy(1, 1, w, h, 0, -1)
    gpu.set(1, print_line, str)
  else
    gpu.set(1, print_line, str)
    print_line = print_line + 1
  end
end

print("init done, loading shell")
require("/shell.lua")
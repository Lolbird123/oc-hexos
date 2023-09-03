local eeprom = component.proxy(component.list("eeprom")())
local tmp = component.list("data")()
if not tmp or not component.proxy(tmp).ecdsa then
  error("no data card or not tier 3")
end
local data = component.proxy(tmp)
tmp = nil
local success = false

local key_str = data.decode64("BASE64")
local key = data.deserializeKey(key_str, "ec-public")

computer.getBootAddress = function()
  return eeprom.getData()
end

computer.setBootAddress = function(addr)
  eeprom.setData(addr)
end  

computer.getPublicKey = function()
  return data.deserializeKey(key_str, "ec-public")
end

function boot(addr)
  fs = component.proxy(addr)
  if not fs then return end
  if not fs.exists("/init.lua") or not fs.exists("/init.lua.sig") then
    return
  end

  local f
  f = fs.open("/init.lua", "r")
  local code = fs.read(f, math.huge)
  fs.close(f)
  f = fs.open("/init.lua.sig", "r")
  local sig = fs.read(f, math.huge)
  fs.close(f)

  if data.ecdsa(code, key, sig) then
    return load(code)
  end
end

do
  local init = boot(computer.getBootAddress())
  if init then
    success = true
    init()
  end
end

if not success then
  for addr in component.list("filesystem") do
    local init = boot(addr)
    if init then
      success = true
      computer.setBootAddress(addr)
      init()
      break
    end
  end
end

if not success then
  error("no bootable filesystem found")
end
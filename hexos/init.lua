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

error(require("/test.lua"))
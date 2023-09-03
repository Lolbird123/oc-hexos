# oc-hexos
a wip opencomputers custom operating system and bios with integrity checking

### "building" bios
1. you need to generate a keypair ingame, specify its public key location with `--key=/path/key` when using the build script
2. run build.lua, it will generate out.lua, flash that to an eeprom
3. you will probably also want to make the eeprom readonly `component.eeprom.makeReadonly(component.eeprom.getChecksum())`

### note on signatures
every "executable" file in the os needs a signature, and they are contained in file.lua.sig

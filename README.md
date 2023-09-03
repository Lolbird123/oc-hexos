# oc-hexos
a wip opencomputers custom operating system and bios with integrity checking

### "building" bios
1. you need to generate a keypair ingame, and save it to /home/default.pub, will probably make it ask for key location at some point instead
2. run build.lua, it will generate out.lua, flash that to an eeprom
3. you will probably also want to make the eeprom readonly

### note on signatures
every "executable" file in the os needs a signature, and they are contained in (executable).lua.sig

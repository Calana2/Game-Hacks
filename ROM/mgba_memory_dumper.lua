--[[
     This script will freeze the emulator for a while.
     Dumps all the memory regions in the script current directory.
--]]

-- pack integers
function p8(val) return string.char(val & 0xFF) end
function p16(val) return string.char(val & 0xFF, (val >> 8) & 0xFF) end
function p32(val) return string.char(val & 0xFF, (val >> 8) & 0xFF, (val >> 16) & 0xFF, (val >> 24) & 0xFF)
end

DIRECTORY = debug.getinfo(1).source:match("@?(.*/)")

function dump_memory()
    for name, domain in pairs(emu.memory) do
        size = domain:size() 
        base = domain:base()
        rname = domain:name()
        console:log("Domain:" .. name)
        console:log("  Size (bytes):" .. size)
        console:log("  Name:" .. rname)
        console:log("  Base Address:" .. string.format("0x%08x", base))
        dump_region(domain)
    end
end

function dump_region(domain)
  size = domain:size()
  file = io.open(DIRECTORY .. emu:getGameTitle() .. "-" .. domain:name() .. ".bin","wb")
  for i = 0, size, 4 do
    if (i + 4 <= size) then
      file:write(p32(domain:read32(i)))
    else
      local diff = i + 4 - size
      for j = 0, diff -1 , 1 do
        file:write(p8(domain:read8(i+j)))
      end
    end
  end
end

dump_memory()

local RM = require("RobotMovies")
local com = require('component')
local computer = require("computer")
local event = require("event")
if not com.isAvailable("robot") then
  print("только роботы могут использовать эту программу")
  os.exit()
end
local r = require("robot")


local gen_inst, gen = false, nil
if com.isAvailable("generator") then
    gen = com.generator
    gen_inst = true
end

print("Выкидвать выпадающие блоки?(0/1):")
local throwing = tonumber(io.read())

print("Введите длину:")
local length = tonumber(io.read()) or 1

print("Введите ширину:")
local width = tonumber(io.read()) or 1

print("Введите высоту туннеля:")
local height = tonumber(io.read()) or 1

print("Введите направление туннеля - вверх(0)/вниз(1):")
local direction = tonumber(io.read()) or 0

local timestart = computer.uptime()
local fuelinv,turn = true
local inv = r.inventorySize()

local function status(msg)
  print("[ "..os.date("%H:%M:%S",computer.uptime()-timestart).." ] "..msg)
end

--дозаправка углём
local function checkfuel()
  if gen_inst then
    local gencount = gen.count()
    if gencount < 10 then
      local slot = r.select()
      for i = 1,inv do
        if r.count(i) > 0 then
          r.select(i)
          gen.insert()
        end
      end
      r.select(slot)
      if gen.count() > gencount then
        fuelinv = true
        status("заправился, угля в генераторе = "..gen.count())
      elseif fuelinv then
        fuelinv = false
        status("нет угля в инвентаре робота !!!")
        r.setLightColor(0xFF0000)
        computer.beep(1000, 1)
      end
    end
  end
  if computer.energy() <= 5000 then
    status("мало энергии !!!")
    r.setLightColor(0xFF0000)
    computer.beep(1000, 1)
  else
    r.setLightColor(0xFFFFFF)
  end
end

os.execute("cls")
status("время разъебать...")

for x = 1, height do
    for y = 1, width do
      for z = 1,length-1 do
        checkfuel()
        RM.F(nil, false, throwing)
      end
      checkfuel()
      if y == width then
        if x == height then
          break
        end
        if direction == 0 then
          RM.UP(nil, false, throwing)
        else
          RM.DOWN(nil, false, throwing)
        end
        if width % 2 == 1 then
          RM.flip()
          RM.F(length-1, false, throwing)
          RM.right()
          RM.F(width-1, false, throwing)
          RM.right()
        else
          RM.right()
          RM.F(width-1, false, throwing)
          RM.right()
        end
        break
      elseif y % 2 == 0 then
        turn = r.turnLeft
      else
        turn = r.turnRight
      end
      turn()
      RM.F(nil, false, throwing)
      turn()
    end
end 
status("готово :)")
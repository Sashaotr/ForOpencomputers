local RM = require("RobotMovies")
local com = require('component')
local computer = require("computer")
local event = require("event")
local r = require("robot")

if not com.isAvailable("robot") then
  print("только роботы могут использовать эту программу")
  os.exit()
end

local gen_inst, gen = false, nil
if com.isAvailable("generator") then
  gen = require("component").generator
  gen_inst = true
end

print("Введите длину:")
local length = tonumber(io.read()) or 1

print("Введите ширину:")
local width = tonumber(io.read()) or 1

print("Введите высоту:")
local height = tonumber(io.read()) or 1

local timestart = computer.uptime()
local fuelinv,turn = true
local inv = r.inventorySize()

local function status(msg)
  print("[ "..os.date("%H:%M:%S",computer.uptime()-timestart).." ] "..msg)
end

local function Wait(slot)
  if slot == inv then
    status("в инвентаре нет блоков !!!")
    r.setLightColor(0xFF0000)
    computer.beep(600, 0.5)
    computer.beep(300, 0.5)
    while true do
      local e = ({event.pull("inventory_changed")})[2]   
      if r.count(e) > 0 then 
        r.select(e)
        break
      end
    end
  r.setLightColor(0xFFFFFF)
  computer.beep(700, 0.5)
  computer.beep(1100, 0.5)
  status("продолжаю строить...")
  end
end

local function F(x)
	local y = x or 1
RM.F(y, r.detect())
end

local function Up(x)
	local y = x or 1
RM.UP(y, r.detectUp())
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
        computer.beep(700, 0.5)
        computer.beep(400, 0.5)
      end
    end
  end
  if computer.energy() <= 5000 then
    status("мало энергии !!!")
    r.setLightColor(0xFF0000)
    computer.beep(500, 1)
computer.beep(200, 1)
  else
    r.setLightColor(0xFFFFFF)
  end
end

--ставим блок под роботом
local function place()
  if r.count() == 0 then
    for slot = 1,inv do
      if r.count(slot) > 0 then 
        r.select(slot)
        break
      end
      Wait(slot)
    end
  end
  if r.detectDown() then
    r.swingDown()
	RM.compare()
    r.placeDown()
  else
    r.placeDown()  
end
  local x = r.select()
  if r.count(x) == 0 then
    if x == inv then
      Wait(x)
    else
      r.select(x+1)
    end
  end
end

os.execute("cls")
status("строю платформу...")

for x = 1, height do
  if x == 1 or x == height then
    for y = 1, width do
      for z = 1,length-1 do
        checkfuel()
        place()
        F()
      end
      checkfuel()
      place()
      if y == width then
        if x == height then
          break
        end
        UP()
        if width % 2 == 1 then
          RM.flip()
          F(length-1)
          RM.right()
          F(width-1)
          RM.right()
        else
          RM.right()
          F(width-1)
          RM.right()
        end
        break
      elseif y % 2 == 0 then
        turn = r.turnLeft
      else
        turn = r.turnRight
      end
      turn()
      F()
      turn()
    end
  else
    for n = 1,length-1 do
      checkfuel()
      place()
      F()
    end
    if width > 1 then
      RM.right()
      for n = 1,width -1 do
        checkfuel()
        place()
        F()
      end
      RM.right()
      for n = 1,length-1 do
        checkfuel()
        place()
        F()
      end
      RM.right()
      for n = 1,width -1 do
        checkfuel()
        place()
        F()
      end
      RM.right()
      UP()
    else
      place()
      RM.flip()
	UP()
    end
  end
end 
status("готово :)")

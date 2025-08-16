local RobotMovies = {}
local r = require("robot")
local inv = r.inventorySize()

local function throw(a)
    local x = tonumber(a) or 1
	r.select(a)
    if not r.detectDown() then
        r.dropDown()
    elseif not r.detect() then
        r.drop()
    else
        r.dropUp()
    end
end

function RobotMovies.compare()
  local x = r.select()
  local first = true
  for i = 1, inv do
    if i ~= x then
      if r.compareTo(i) then
        if i < x and first == true then
          r.select(i)
          x = i
          first = false
        end
      else
        throw(i)
        r.select(x)
      end
    end
  end
end

function RobotMovies.F(len, comp, thr)
    local length = tonumber(len) or 1
    local steps = 0
    while steps < length do
        if r.detect() then
            while r.detect() do
                r.swing()
            end
            local cmp = (comp ~= nil) and comp or false
            local th = (thr ~= nil) and thr or false
            if cmp then RobotMovies.compare() end
            if th then throw() end
        end
        if r.forward() then
            steps = steps + 1
        end
    end
end

function RobotMovies.UP(len, comp, thr)
    local height = tonumber(len) or 1
    local steps = 0
    while steps < height do
        if r.detectUp() then
            while r.detectUp() do
                r.swingUp()
                os.sleep(0.3)
            end
local cmp = (comp ~= nil) and comp or false
            local th = (thr ~= nil) and thr or false
            if cmp then RobotMovies.compare() end
            if th then throw() end

        end
        if r.up() then
            steps = steps + 1
        end
    end
end

function RobotMovies.DOWN(len, comp, thr)
    local depth = tonumber(len) or 1
    local steps = 0
    while steps < depth do
        if r.detectDown() then
            while r.detectDown() do
                r.swingDown()
                os.sleep(0.3)
            end
local cmp = (comp ~= nil) and comp or false
            local th = (thr ~= nil) and thr or false
            if cmp then RobotMovies.compare() end
            if th then throw() end

        end
        if r.down() then
            steps = steps + 1
        end
    end
end

function RobotMovies.flip()
    r.turnAround()
end

function RobotMovies.right()
    r.turnRight()
end

function RobotMovies.left()
    r.turnLeft()
end

return RobotMovies
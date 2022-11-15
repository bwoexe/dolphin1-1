import 'CoreLibs/frameTimer'

class('Bubble').extends(playdate.graphics.sprite)

-- local references


local min, max, abs, floor = math.min, math.max, math.abs, math.floor

local dt = 0.05					-- time between frames at 20fps
local ft = 0.02



local MAX_RUN_VELOCITY_BUB = 4
local MAX_FLOAT = 2

-- constants
local LEFT, RIGHT = 0, 1
local STEP_DISTANCE = 4
local spriteHeight, spriteWidth = 24, 24



-- class variables
local stepTimer = playdate.frameTimer.new(6)
stepTimer.repeats = true

local speed = 4
local float = 2
local runImageIndex = 1
local runImagePop = 7

function Bubble:init(x,y,d)

	Bubble.super.init(self)
	self.bubbleImages = playdate.graphics.imagetable.new('img/bubble')
	self:setImage(self.bubbleImages:getImage(1))
	self:setZIndex(900)
	self:setCenter(0.5, 1)	-- set center point to left bottom
	self:setCollideRect(2,2,spriteWidth-4,spriteHeight-4) -- make the collision rect a bit shorter than the actual sprite
	self:moveTo(x,y)
	
	self.speed = speed 
	--self.position = Point.new(x,y)
	self.float = float
	self:add()
	self.runImageIndex = runImageIndex
	self.runImagePop = runImagePop
	--self.velocity = vector2D.new(0,0)
	self.direction = d
	self.crushed = false

	
end



function Bubble:collisionResponse(other)
	if other:isa(Player) then
	self.speed = self.speed -.5
	return "overlap" 
	end
	if other:isa(Bubble) then
	return "overlap"
	end
	if other:isa(Coin) then
	return "overlap" 
	end
	
	self.direction = (self.direction + 1) % 2
	return "bounce"
	
end



function Bubble:changeDirections()
	self.direction = (self.direction + 1) % 2
end


function Bubble:crush()
	self.crushed = true
	self:setImage(self.bubbleImages:getImage(floor (runImagePop)))
	
		
	self:clearCollideRect()
end


function Bubble:update()	-- sprite callback

	local velocityStep = self.speed * dt
	self.speed = self.speed - velocityStep
	if self.speed > MAX_RUN_VELOCITY_BUB then self.speed = MAX_RUN_VELOCITY_BUB
	elseif self.speed < -MAX_RUN_VELOCITY_BUB then self.speed = -MAX_RUN_VELOCITY_BUB
	end

	local velocityFloat = self.float * ft
	self.float = self.float - velocityFloat
	if self.float > MAX_FLOAT then self.float = MAX_FLOAT
	elseif self.float < -MAX_FLOAT then self.float = -MAX_FLOAT
	end

	
	if self.crushed then
		
		self:setImage(self.bubbleImages:getImage(floor(self.runImagePop)))

		if self.runImagePop > 10 then
			self.runImagePop = 10 
		else
			self.runImagePop = self.runImagePop + 1
		end
	
		return
	end
	if self.direction == LEFT then
	self:moveWithCollisions(self.x - self.speed, self.y - self.float)

	else
		self:moveWithCollisions(self.x + self.speed, self.y - self.float)
	end

	

	
	
	

	--if self.speed < MIN_RUN_VELOCITY_BUB then self.speed = MIN_RUN_VELOCITY_BUB
	--elseif self.speed > -MIN_RUN_VELOCITY_BUB then self.speed = -MIN_RUN_VELOCITY_BUB
	--end

	-- if we're not crushed, step and move
	--if self.direction == LEFT then
		--self.x = self.x - STEP_DISTANCE
	--else
		--self.x = self.x + STEP_DISTANCE
	--end

	
	
		
		if self.crushed == false then
		self:setImage(self.bubbleImages:getImage(floor(self.runImageIndex)))
		
		if self.runImageIndex > 6 then
			self.runImageIndex = 4
		else
			self.runImageIndex = self.runImageIndex + 0.5
		end
	end
	

	
		
	
		
	
	-- if stepTimer.frame < 6 then
	-- 	self:setImage(self.bubbleImages:getImage(3))
	-- else
	-- 	self:setImage(self.bubbleImages:getImage(3), "flipX")
	-- end

	
end


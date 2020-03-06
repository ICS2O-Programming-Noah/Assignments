-----------------------------------------------------------------------------------------
-- Noah Sabbagh
-- main.lua
-- ICS2O Programming
-- This program displays three images that move around the screen. One of them moves
-- diagonally, one shrinks and one that fades out of the screen. 
-----------------------------------------------------------------------------------------

-- hide the status bar on the iPad
display.setStatusBar(display.HiddenStatusBar)

-- global variables
scrollSpeedMonkey = 8

-- add the background image with width and height
local backgroundImage = display.newImageRect("Images/background.jpg", 1024, 1000)
backgroundImage.x = 512
backgroundImage.y = 359

-- add a character image with width and height
local monkey = display.newImageRect("Images/monkey.png", 200, 200)

-- set your image to be transparent
monkey.alpha = 0

-- set the initial x and y position of the monkey
monkey.x = 0
monkey.y = display.contentHeight * 1/5

-- Function: MoveMonkey
-- Inpu: this function accepts an event listener
-- Output: none
-- Description: This function adds the scroll speed to the x-value of the monkey
local function MoveMonkey (event)
	-- add the scroll speed to the x-value of the monkey
	monkey.x = monkey.x + scrollSpeedMonkey
	-- change the transparency of the monkey every time it fades in
	monkey.alpha = monkey.alpha + 0.01
end

-- MoveMonkey will be called over and over again
Runtime:addEventListener("enterFrame", MoveMonkey)

-- create another global variables
scrollSpeedParrot = 8

-- character image with width and height
local parrot = display.newImageRect("Images/parrot.png", 200, 200)

-- set the image to be transparent
parrot.alpha = 1

-- set the initial x and y position of parrot
parrot.x = 0
parrot.y = display.contentHeight * 1/2

-- Function: MoveParrot
-- Input: this function accepts an event listener
-- Output: none
-- Description: This function adds the scroll speed to the x-value of the parrot
local function MoveParrot (event)
	-- add the scroll speed to the x-value of the parrot
	parrot.x = parrot.x + scrollSpeedParrot
end

-- MoveShip will be called over and over again
Runtime:addEventListener("enterFrame", MoveParrot)

-- create another global variables
scrollSpeedTiger = 3.5

-- character image with width and height
local tiger = display.newImageRect("Images/tiger.png", 200, 200)

-- set the image to be transparent
tiger.alpha = 1

-- set the initial x and y position of tiger
tiger.x = 0
tiger.y = display.contentHeight/1.3

-- Function: MoveTiger
-- Input: this function accepts an event listener
-- Output: none
-- Description: This function adds the scroll speed to the x-value of the tiger
local function MoveTiger (event)
	-- add the scroll speed to the x-value of the tiger
	tiger.x = tiger.x + scrollSpeedTiger
	tiger.y = tiger.y - scrollSpeedTiger
end

-- MoveTiger will be called over and over again
Runtime:addEventListener("enterFrame", MoveTiger)

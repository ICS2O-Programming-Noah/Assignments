-----------------------------------------------------------------------------------------
-- Noah Sabbagh
-- main.lua
-- ICS2O Programming
-- This program displays three images that move around the screen. One of them moves
-- diagonally, one shrinks and one that fades out of the screen. 
-----------------------------------------------------------------------------------------

-- hide the status bar on the iPad
display.setStatusBar(display.HiddenStatusBar)


------------------------------------------------------------------------------------------------
-- GLOBAL VARIABLES
-----------------------------------------------------------------------------------------
-- global variables
scrollSpeedMonkey = 8
scrollSpeedMonkey2 = 8
scrollSpeedParrot = 8
scrollSpeedParrot2 = 1024
scrollSpeedTiger = 3.5
scrollSpeedTiger2 = 0.01
goLeft = 1

-----------------------------------------------------------------------------------------
-- CREATE YOUR IMAGE VARIABLES AND SOUND VARIABLES
-----------------------------------------------------------------------------------------

-- add sound to the program
local jungleNoises = audio.loadSound("Sounds/jungleNoises.mp3")
local jungleNoisesSoundChannel

-- add the background image with width and height
local backgroundImage = display.newImageRect("Images/background.jpg", 1024, 1000)
backgroundImage.x = 512
backgroundImage.y = 359

-- add a character image with width and height
local monkey = display.newImageRect("Images/monkey.png", 200, 200)

-- character image with width and height
local parrot = display.newImageRect("Images/parrot.png", 200, 200)

-- character image with width and height
local tiger = display.newImageRect("Images/tiger.png", 200, 200)

-----------------------------------------------------------------------------------------
-- ADDING SOUND
-----------------------------------------------------------------------------------------
jungleNoisesSoundChannel = audio.play(jungleNoises)

-----------------------------------------------------------------------------------------
-- MONKEY FUNCTION
-----------------------------------------------------------------------------------------

-- set your image to be transparent
monkey.alpha = 0

-- set the initial x and y position of the monkey
monkey.x = 1024
monkey.y = display.contentHeight/1.25

-- Function: CalculateLine
-- Input: This funtion accepts an event listener
-- Output: none
-- Description: This function will allow the monkey to move on a parabolic path
local function CalculateLine(x)
	local yValue = (x - 400)*(x - 100)*(x - 800)/100000 + 500
	return yValue
end

-- Function: MoveMonkey
-- Inpu: this function accepts an event listener
-- Output: none
-- Description: This function adds the scroll speed to the x-value of the monkey
local function MoveMonkey (event)
	-- add the scroll speed to the x-value of the monkey
	monkey.x = monkey.x - scrollSpeedMonkey
	monkey.y = CalculateLine(monkey.x)
	-- change the transparency of the monkey every time it fades in
	monkey.alpha = monkey.alpha + 0.01
	-- Make the monkey rotate while moving
	monkey:rotate(8)
	timer.performWithDelay(10000)
end

-- MoveMonkey will be called over and over again
Runtime:addEventListener("enterFrame", MoveMonkey)

-----------------------------------------------------------------------------------------
-- PARROT FUNCTION
-----------------------------------------------------------------------------------------

-- set the image to be visible
parrot.alpha = 1

-- set the initial x and y position of parrot
parrot.x = 0
parrot.y = display.contentHeight * 1/2

-- Function: MoveParrot
-- Input: this function accepts an event listener
-- Output: none
-- Description: This function adds the scroll speed to the x-value of the parrot
local function MoveParrot (event)
	-- add the scroll speed to the parrot and make it move back and forth on the screen
	if (goLeft == 1) then
		parrot.x = parrot.x + scrollSpeedParrot
	else
		parrot.x = parrot.x - scrollSpeedParrot
	end

	if (parrot.x == 1024) then
		goLeft = 0
	elseif (parrot.x == 0) then
		goLeft = 1
	end
end

-- MoveParrot will be called over and over again
Runtime:addEventListener("enterFrame", MoveParrot)

-----------------------------------------------------------------------------------------
-- TIGER FUNCTION
-----------------------------------------------------------------------------------------

-- set the image to be visible
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
	-- make the tiger grow in size
	tiger.xScale = tiger.xScale + scrollSpeedTiger2
	tiger.yScale = tiger.yScale + scrollSpeedTiger2
end

-- MoveTiger will be called over and over again
Runtime:addEventListener("enterFrame", MoveTiger)

-----------------------------------------------------------------------------------------
-- TEXT OBJECT
-----------------------------------------------------------------------------------------

-- create the text object
local screenText = display.newText("In the Jungle", 750, 250, 'Times New Roman', 100)

-- change the color of the text
screenText:setTextColor( 86/255, 202/255, 238/255)

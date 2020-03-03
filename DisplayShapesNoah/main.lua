-----------------------------------------------------------------------------------------
-- Noah Sabbagh
-- main.lua
-- This program displays four different polygons on an iPad screen. 
-----------------------------------------------------------------------------------------

-- Your code here

-- Create local variables for the vertices of your shapes.
local verticesTri = { 0, 80, 130, -80, -70, -85 }  
local verticesPent = { 60, 0, 50, -80, -50, -80, -60, 0, 0, 80}
local verticesHex = { 40, 45, 90, -10, 60, -45, -45, -45, -80, -10, -40, 45 }
local verticesOct = { 20, 40, 39, 20, 39, -20, 20, -40, -20, -40,-40, -20, -40, 20,-20, 40 }
local myTriangle
local myPentagon
local myHexagon
local myOctagon
local areaOfTriangle
local baseTri = 10
local heightOfTri = 12
local areaText
local textSize = 25
local gradientPaint = {
	type = "gradient",
	color1 = {212/255, 38/255, 84/255},
	color2 = {43/255, 106/255, 125/255},
	direction = "down"
}

-- hide the status bar
display.setStatusBar(display.HiddenStatusBar)

-- set the background colour
display.setDefault("background", 172/255, 22/255, 22/255)

-- create your first polygon.
myTriangle = display.newPolygon (225, 140, verticesTri)

-- set color of the triangle
myTriangle:setFillColor(24/255, 177/255, 223/255)  

-- set the border for the triangle
myTriangle:setStrokeColor(30/255, 24/255, 223/255)
myTriangle.strokeWidth = 5

-- calculate the area of the triangle
areaOfTriangle = baseTri * heightOfTri / 2

-- display the text saying the area of the triangle
areaText = display.newText("The area of this triangle with a base of \n" ..
		baseTri .. " and a height of " .. heightOfTri .. " is " ..
		areaOfTriangle .. " pixels².", 225, 260, Arial, textSize)

-- create the next shape
myPentagon = display.newPolygon (800, 150, verticesPent)

-- set color of the pentagon
myPentagon:setFillColor(24/255, 177/255, 223/255)

-- create the border of the pentagon
myPentagon:setStrokeColor(30/255, 24/255, 223/255)
myPentagon.strokeWidth = 5

-- create the 3rd shape
myHexagon = display.newPolygon (225, 500, verticesHex)

-- set the gradient color of the myHexagon
myHexagon.fill = gradientPaint

-- set the border for the myHexagon
myHexagon:setStrokeColor(30/255, 24/255, 223/255)
myHexagon.strokeWidth = 5

-- create your last shape
myOctagon = display.newPolygon (800, 500, verticesOct)

-- set the color of the octagon
myOctagon:setFillColor(24/255, 177/255, 223/255)

-- create the border of the octagon
myOctagon:setStrokeColor(30/255, 24/255, 223/255)
myOctagon.strokeWidth = 5
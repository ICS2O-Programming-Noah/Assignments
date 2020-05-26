-----------------------------------------------------------------------------------------
--
-- splash_screen.lua
-- Created by: Noah Sabbagh
-- Date: May 25, 2020
-- Description: This is the splash screen of the game. It animates part of my  
-- company logo to come together on the screen.
-----------------------------------------------------------------------------------------

-- Use Composer Library
local composer = require( "composer" )

-- Name the Scene
sceneName = "splash_screen"

-----------------------------------------------------------------------------------------

-- Create Scene Object
local scene = composer.newScene( sceneName )


----------------------------------------------------------------------------------------
-- GLOBAL VARIABLES
----------------------------------------------------------------------------------------

scrollSpeedText = -5
scrollSpeedLine1 = 4
scrollSpeedLine2 = -4
scrollSpeedLine3 = 4
scrollSpeedLine4 = -4
movingText = true
movingLine1 = true
movingLine2 = true
movingLine3 = true
movingLine4 = true

----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------
 
-- The local variables for this scene
local text
local line1
local line2
local line3
local line4
local background
local sciFiSound = audio.loadSound("Sounds/scifi005.mp3")
local sciFiSoundChannel


--------------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
--------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------
-- MOVING TEXT FUNCTIONS
--------------------------------------------------------------------------------------------

local function MovingText()
    if (movingText == true) then
        text.x = text.x + scrollSpeedText
    end

    if (movingText == false) then
        text.x = 495
    end
end

local function StopText()
    if (text.x <= 495) then
        movingText = false
    end
end

--------------------------------------------------------------------------------------------
-- MOVING LINE 1 FUNCTIONS
--------------------------------------------------------------------------------------------

local function MovingLine1()
    if (movingLine1 == true) then
        line1.x = line1.x + scrollSpeedLine1
    end

    if (movingLine1 == false) then
        line1.x = 165
    end
end

local function StopMovingLine1()
    if (line1.x >= 165) then
        movingLine1 = false
    end
end

--------------------------------------------------------------------------------------------
-- MOVING LINE 2 FUNCTIONS
--------------------------------------------------------------------------------------------

local function MovingLine2()
    if (movingLine2 == true) then
        line2.x = line2.x + scrollSpeedLine2
    end

    if (movingLine2 == false) then
        line2.x = 817
    end
end

local function StopMovingLine2()
    if (line2.x <= 817) then
        movingLine2 = false
    end
end

--------------------------------------------------------------------------------------------
-- MOVING LINE 3 FUNCTIONS
--------------------------------------------------------------------------------------------

local function MovingLine3()
    if (movingLine3 == true) then
        line3.y = line3.y + scrollSpeedLine3
    end

    if (movingLine3 == false) then
        line3.y = 100
    end
end

local function StopMovingLine3()
    if (line3.y >= 100) then
        movingLine3 = false
    end
end

--------------------------------------------------------------------------------------------
-- MOVING LINE 4 FUNCTIONS
--------------------------------------------------------------------------------------------

local function MovingLine4()
    if (movingLine4 == true) then
        line4.y = line4.y + scrollSpeedLine4
    end

    if (movingLine4 == false) then
        line4.y = 610
    end
end

local function StopMovingLine4()
    if (line4.y <= 610) then
        movingLine4 = false
    end
end

--------------------------------------------------------------------------------------------

-- The function that will go to the main menu 
local function MainMenuScreenTransition()
    composer.gotoScene( "main_menu", {effect = "zoomOutIn", time = 1000} )
end

-----------------------------------------------------------------------------------------
-- GLOBAL SCENE FUNCTIONS
-----------------------------------------------------------------------------------------

-- The function called when the screen doesn't exist
function scene:create( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -- insert the background
    background = display.newImageRect("Images/background.png", 1024, 768)
    background.anchorX = 0
    background.anchorY = 0

    -- Insert the text image
    text = display.newImageRect("Images/text.png", 500, 100)

    -- set the initial x and y position of the text
    text.x = 1024
    text.y = 340

    -- Insert the line image
    line1 = display.newImageRect("Images/line1.png", 525, 25)

    -- set the initial x and y position of line 1
    line1.x = 0
    line1.y = 353
    line1:rotate(90)

    -- Insert the line image
    line2 = display.newImageRect("Images/line2.png", 525, 25)

    -- set the initial x and y position of line 1
    line2.x = 1024
    line2.y = 353
    line2:rotate(90)

    -- Insert the line image
    line3 = display.newImageRect("Images/line3.png", 640, 25)

    -- set the initial x and y position of line 1
    line3.x = 492  
    line3.y = 0

    -- Insert the line image
    line4 = display.newImageRect("Images/line4.png", 640, 25)

    -- set the initial x and y position of line 1
    line4.x = 492
    line4.y = 768

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( background )
    sceneGroup:insert( text )
    sceneGroup:insert( line1 )
    sceneGroup:insert( line2 )
    sceneGroup:insert( line3 )
    sceneGroup:insert( line4 )

end -- function scene:create( event )

--------------------------------------------------------------------------------------------

-- The function called when the scene is issued to appear on screen
function scene:show( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------

    local phase = event.phase

    -----------------------------------------------------------------------------------------

    -- Called when the scene is still off screen (but is about to come on screen).
    if ( phase == "will" ) then
       
    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        -- start the splash screen music
        sciFiSoundChannel = audio.play( sciFiSound, {channel = 1, loops = -1} )

        Runtime:addEventListener("enterFrame", MovingText)
        Runtime:addEventListener("enterFrame", StopText)

        Runtime:addEventListener("enterFrame", MovingLine1)
        Runtime:addEventListener("enterFrame", StopMovingLine1)

        Runtime:addEventListener("enterFrame", MovingLine2)
        Runtime:addEventListener("enterFrame", StopMovingLine2)

        Runtime:addEventListener("enterFrame", MovingLine3)
        Runtime:addEventListener("enterFrame", StopMovingLine3)

        Runtime:addEventListener("enterFrame", MovingLine4)
        Runtime:addEventListener("enterFrame", StopMovingLine4)

        -- Go to the main menu screen after the given time.
        timer.performWithDelay ( 3400, MainMenuScreenTransition)          
        
    end

end --function scene:show( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to leave the screen
function scene:hide( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view
    local phase = event.phase

    -----------------------------------------------------------------------------------------

    -- Called when the scene is on screen (but is about to go off screen).
    -- Insert code here to "pause" the scene.
    -- Example: stop timers, stop animation, stop audio, etc.
    if ( phase == "will" ) then  

    -----------------------------------------------------------------------------------------

    -- Called immediately after scene goes off screen.
    elseif ( phase == "did" ) then
        
        audio.stop(sciFiSoundChannel)
    end

end --function scene:hide( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to be destroyed
function scene:destroy( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------


    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end -- function scene:destroy( event )

-----------------------------------------------------------------------------------------
-- EVENT LISTENERS
-----------------------------------------------------------------------------------------

-- Adding Event Listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene

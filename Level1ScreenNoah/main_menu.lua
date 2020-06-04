-----------------------------------------------------------------------------------------
--
-- main_menu.lua
-- Created by: Your Name
-- Date: Month Day, Year
-- Description: This is the main menu, displaying the credits, instructions & play buttons.
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- INITIALIZATIONS
-----------------------------------------------------------------------------------------

-- Use Composer Library
local composer = require( "composer" )

-----------------------------------------------------------------------------------------

-- Use Widget Library
local widget = require( "widget" )

-----------------------------------------------------------------------------------------

-- Naming Scene
sceneName = "main_menu"

-----------------------------------------------------------------------------------------

-- Creating Scene Object
local scene = composer.newScene( sceneName )

-----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------

local bkg_image
local spaceship
local spaceship2
local playButton
local creditsButton
local instructionsButton
local muteButton
local unmuteButton

-----------------------------------------------------------------------------------------
-- GLOBAL VARIABLES
-----------------------------------------------------------------------------------------

scrollSpeedSpaceship = 3
moveSpaceship = true

-----------------------------------------------------------------------------------------
-- LOCAL SOUNDS
-----------------------------------------------------------------------------------------

local bkgMusic = audio.loadSound("Sounds/bkg.mp3")
local bkgMusicChannel

-----------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
-----------------------------------------------------------------------------------------

-- Creating Transition Function to Credits Page
local function CreditsTransition( )       
    composer.gotoScene( "credits_screen", {effect = "fade", time = 1000})
end 

-----------------------------------------------------------------------------------------

-- Creating Transition to Level1 Screen
local function Level1ScreenTransition( )
    composer.gotoScene( "level1_screen", {effect = "slideUp", time = 1000})
end    

-----------------------------------------------------------------------------------------

local function InstructionsTransition( )
    composer.gotoScene( "instructions_screen", {effect = "slideLeft", time = 1000})
end

-----------------------------------------------------------------------------------------

-- creating function to move the spaceships up the screen
local function MoveSpaceship()
    if (moveSpaceship == true) then
        spaceship.alpha = spaceship.alpha + 0.01
        spaceship.y = spaceship.y - scrollSpeedSpaceship
    end

    if (moveSpaceship == false) then
        spaceship.y = spaceship.y + scrollSpeedSpaceship
    end

    if (spaceship.y <= 100) then
        moveSpaceship = false
    end

    if (spaceship.y >= 500) then
        moveSpaceship = true
    end
end

-- creating function to move the spaceships up the screen
local function MoveSpaceship2()
    if (moveSpaceship == true) then
        spaceship2.alpha = spaceship2.alpha + 0.01
        spaceship2.y = spaceship2.y - scrollSpeedSpaceship
    end

    if (moveSpaceship == false) then
        spaceship2.y = spaceship2.y + scrollSpeedSpaceship
    end

    if (spaceship2.y <= 100) then
        moveSpaceship = false
    end

    if (spaceship2.y >= 500) then
        moveSpaceship = true
    end
end

-----------------------------------------------------------------------------------------
-- MUTE/UNMUTE FUNCTIONS
-----------------------------------------------------------------------------------------

function Mute (touch)

    if (touch.phase == "ended") then

        -- pause the background music
        audio.pause(bkgMusicChannel)

        -- make mute button visible
        muteButton.isVisible = true
        unmuteButton.isVisible = false
    end
end

function UnMute (touch)

    if (touch.phase == "ended") then

        --resume the background music
        audio.resume(bkgMusicChannel)

        -- make unmute button visible
        muteButton.isVisible = false
        unmuteButton.isVisible = true
    end
end

function AddMuteUnMuteListeners()
    muteButton:addEventListener("touch", UnMute)
    unmuteButton:addEventListener("touch", Mute)
end

function RemoveMuteUnMuteListeners()
    muteButton:removeEventListener("touch", UnMute)
    unmuteButton:removeEventListener("touch", Mute)
end
-----------------------------------------------------------------------------------------
-- GLOBAL SCENE FUNCTIONS
-----------------------------------------------------------------------------------------

-- The function called when the screen doesn't exist
function scene:create( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------
    -- BACKGROUND IMAGE & STATIC OBJECTS
    -----------------------------------------------------------------------------------------

    -- Insert the background image and set it to the center of the screen
    bkg_image = display.newImage("Images/main_menu.png")
    bkg_image.x = display.contentCenterX
    bkg_image.y = display.contentCenterY
    bkg_image.width = display.contentWidth
    bkg_image.height = display.contentHeight

    spaceship = display.newImageRect("Images/spaceship.png", 150, 200)
    spaceship.x = 100
    spaceship.y = 500
    spaceship.alpha = 0

    spaceship2 = display.newImageRect("Images/spaceship.png", 150, 200)
    spaceship2.x = 900
    spaceship2.y = 500
    spaceship2.alpha = 0

    muteButton = display.newImageRect("Images/mute.png", 70, 70)
    muteButton.x = 960
    muteButton.y = 60
    muteButton.isVisible = false

    unmuteButton = display.newImageRect("Images/unmute.png", 70, 70)
    unmuteButton.x = 960
    unmuteButton.y = 60
    unmuteButton.isVisible = true


    -- Associating display objects with this scene 
    sceneGroup:insert( bkg_image )
    sceneGroup:insert( spaceship )
    sceneGroup:insert( spaceship2 )

    -- Send the background image to the back layer so all other objects can be on top
    bkg_image:toBack()

    -----------------------------------------------------------------------------------------
    -- BUTTON WIDGETS
    -----------------------------------------------------------------------------------------   

    -- Creating Play Button
    playButton = widget.newButton( 
        {   
            -- Set its position on the screen relative to the screen size
            x = display.contentWidth/2,
            y = display.contentHeight*7/8,

            -- Insert the images here
            defaultFile = "Images/Start Button Unpressed.png",
            overFile = "Images/Start Button Pressed.png",

            -- When the button is released, call the Level1 screen transition function
            onRelease = Level1ScreenTransition          
        } )

    -----------------------------------------------------------------------------------------

    -- Creating Credits Button
    creditsButton = widget.newButton( 
        {
            -- Set its position on the screen relative to the screen size
            x = display.contentWidth*7/8,
            y = display.contentHeight*7/8,

            -- Insert the images here
            defaultFile = "Images/Credits Button Unpressed.png",
            overFile = "Images/Credits Button Pressed.png",

            -- When the button is released, call the Credits transition function
            onRelease = CreditsTransition
        } ) 
    
    
    -----------------------------------------------------------------------------------------

        -- Creating Credits Button
    instructionsButton = widget.newButton( 
        {
            -- Set its position on the screen relative to the screen size
            x = display.contentWidth*1/8,
            y = display.contentHeight*7/8,

            -- Insert the images here
            defaultFile = "Images/Instructions Button Unpressed.png",
            overFile = "Images/Instructions Button Pressed.png",

            -- When the button is released, call the instructions transition function
            onRelease = InstructionsTransition
        } ) 

    -----------------------------------------------------------------------------------------

    -- Associating button widgets with this scene
    sceneGroup:insert( playButton )
    sceneGroup:insert( creditsButton )
    sceneGroup:insert( instructionsButton )

end -- function scene:create( event )   



-----------------------------------------------------------------------------------------

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

    -- Called when the scene is now on screen.
    -- Insert code here to make the scene come alive.
    -- Example: start timers, begin animation, play audio, etc.
    elseif ( phase == "did" ) then       
       
    bkgMusicChannel = audio.play(bkgMusic, {channel = 2, loop = -1})

    Runtime:addEventListener("enterFrame", MoveSpaceship)
    Runtime:addEventListener("enterFrame", MoveSpaceship2)

    AddMuteUnMuteListeners()

    end

end -- function scene:show( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to leave the screen
function scene:hide( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------

    local phase = event.phase

    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.

    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        RemoveMuteUnMuteListeners()
    end

end -- function scene:hide( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to be destroyed
function scene:destroy( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

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

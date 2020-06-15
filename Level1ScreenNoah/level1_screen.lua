-----------------------------------------------------------------------------------------
--
-- level1_screen.lua
-- Created by: Ms Raffin
-- Date: Nov. 22nd, 2014
-- Edited by: Noah Sabbagh
-- Editied on: Apr. 28th, 2020
-- Description: This is the level 1 screen of the game.
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- INITIALIZATIONS
-----------------------------------------------------------------------------------------

-- Use Composer Libraries
local composer = require( "composer" )
local widget = require( "widget" )

-- load physics
local physics = require("physics")

-----------------------------------------------------------------------------------------

-- Naming Scene
sceneName = "level1_screen"

-----------------------------------------------------------------------------------------

-- Creating Scene Object
local scene = composer.newScene( sceneName )

-----------------------------------------------------------------------------------------
-- GLOBAL VARIABLES
-----------------------------------------------------------------------------------------

soundOn = true
scrollSpeedFireball1 = 3
scrollSpeedFireball2 = 1.6
scrollSpeedFireball3 = 4

numLives = 3

-----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------

-- The local variables for this scene
local bkg_image

local platform1
local platform2
local platform3
local platform4

local fireball1
local fireball2
local fireball3

local blackHole
local character

local rArrow 
local uArrow
local lArrow

local heart1
local heart2

local motionx = 0
local SPEED = 7.5
local LINEAR_VELOCITY = -200
local GRAVITY = 8

local leftW 
local rightW
local topW
local floor

local questionsAnswered

local moveFireball1R = true
local moveFireball1D = false
local moveFireball1L = false
local moveFireball1U = false

local moveFireball2R = true
local moveFireball2D = false
local moveFireball2L = false
local moveFireball2U = false

local moveFireball3R = false
local moveFireball3D = false
local moveFireball3L = true
local moveFireball3U = false

local oxygenTank1
local oxygenTank2
local oxygenTank3
local theOxygenTank

-----------------------------------------------------------------------------------------
-- LOCAL SOUNDS
-----------------------------------------------------------------------------------------

local bkgMusicL1 = audio.loadSound("Sounds/bkg.mp3")
local bkgMusicL1Channel

local hittingfireballound = audio.loadSound("Sounds/hitfireball.mp3")
local hittingfireballoundChannel

-----------------------------------------------------------------------------------------
-- LOCAL SCENE FUNCTIONS
----------------------------------------------------------------------------------------- 
 
-- When right arrow is touched, move character right
local function right (touch)
    motionx = SPEED
    character.xScale = 1
end

-- When up arrow is touched, add vertical so it can jump
local function up (touch)
    if (character ~= nil) then
        character:setLinearVelocity( 0, LINEAR_VELOCITY )
    end
end

-- When left arrow is touched, move character left
local function left (touch)
    motionx = -SPEED
    character.xScale = -1
end

-- Move character horizontally
local function movePlayer (event)
    character.x = character.x + motionx
end
 
-- Stop character movement when no arrow is pushed
local function stop (event)
    if (event.phase =="ended") then
        motionx = 0
    end
end


local function AddArrowEventListeners()
    rArrow:addEventListener("touch", right)
    uArrow:addEventListener("touch", up)
    lArrow:addEventListener("touch", left)
end

local function RemoveArrowEventListeners()
    rArrow:removeEventListener("touch", right)
    uArrow:removeEventListener("touch", up)
    lArrow:removeEventListener("touch", left)
end

local function AddRuntimeListeners()
    Runtime:addEventListener("enterFrame", movePlayer)
    Runtime:addEventListener("touch", stop )
end

local function RemoveRuntimeListeners()
    Runtime:removeEventListener("enterFrame", movePlayer)
    Runtime:removeEventListener("touch", stop )
end

local function MoveFireball1()
    if (moveFireball1R == true) then
       fireball1.x = fireball1.x + scrollSpeedFireball1
        if (fireball1.x >= 540) then
            moveFireball1R = false
            moveFireball1D = true
            moveFireball1L = false
            moveFireball1U = false
        end

    elseif (moveFireball1D == true) then
        fireball1.y = fireball1.y + scrollSpeedFireball1
        if (fireball1.y >= 650) then
            moveFireball1D = false
            moveFireball1R = false
            moveFireball1L = true
            moveFireball1U = false
        end
    elseif (moveFireball1L == true) then
        fireball1.x = fireball1.x - scrollSpeedFireball1
        if (fireball1.x <= 210) then
            moveFireball1D = false
            moveFireball1R = false
            moveFireball1L = false
            moveFireball1U = true
        end
    elseif (moveFireball1U == true) then
        fireball1.y = fireball1.y - scrollSpeedFireball1
        if (fireball1.y <= 400) then
            moveFireball1D = false
            moveFireball1R = true
            moveFireball1L = false
            moveFireball1U = false
        end
    end
end

local function MoveFireball2()
    if (moveFireball2R == true) then
       fireball2.x = fireball2.x + scrollSpeedFireball2
        if (fireball2.x >= 1000) then
            moveFireball2R = false
            moveFireball2D = false
            moveFireball2L = true
            moveFireball2U = false
        end
    elseif (moveFireball2L == true) then
        fireball2.x = fireball2.x - scrollSpeedFireball2
        if (fireball2.x <= 800) then
            moveFireball2D = false
            moveFireball2R = true
            moveFireball2L = false
            moveFireball2U = false
        end
    end
end

local function MoveFireball3()
    if (moveFireball3L == true) then
       fireball3.x = fireball3.x - scrollSpeedFireball3
        if (fireball3.x <= 470) then
            moveFireball3R = false
            moveFireball3D = true
            moveFireball3L = false
            moveFireball3U = false
        end
    elseif (moveFireball3D == true) then
        fireball3.y = fireball3.y + scrollSpeedFireball3
        if (fireball3.y >= 330) then
            moveFireball3D = false
            moveFireball3R = true
            moveFireball3L = false
            moveFireball3U = false
        end
    elseif (moveFireball3R == true) then
        fireball3.x = fireball3.x + scrollSpeedFireball3
        if (fireball3.x >= 780) then
            moveFireball3D = false
            moveFireball3R = false
            moveFireball3L = false
            moveFireball3U = true
        end
    elseif (moveFireball3U == true) then
        fireball3.y = fireball3.y - scrollSpeedFireball3
        if (fireball3.y <= 135) then
            moveFireball3D = false
            moveFireball3R = false
            moveFireball3L = true
            moveFireball3U = false
        end
    end
end

local function YouLoseTransition()
    composer.gotoScene( "you_lose" )
end

local function LoseHearts()
    if (numLives == 2) then
        heart1.isVisible = true
        heart2.isVisible = false
    elseif (numLives == 1) then
        heart1.isVisible = false
        heart2.isVisible = false
        YouLoseTransition()
    end
end

local function ReplaceCharacter()
    character = display.newImage("Images/astronaut.png", 50, 50)
    character.x = display.contentWidth * 0.5 / 8
    character.y = display.contentHeight  * 0.1 / 3
    character.width = 75
    character.height = 100
    character.myName = "Astronaut"

    -- intialize horizontal movement of character
    motionx = 0

    -- add physics body
    physics.addBody( character, "dynamic", { density=0, friction=0.5, bounce=0, rotation=0 } )

    -- prevent character from being able to tip over
    character.isFixedRotation = true

    -- add back arrow listeners
    AddArrowEventListeners()

    -- add back runtime listeners
    AddRuntimeListeners()
end

local function MakeOxygenTanksVisible()
    oxygenTank1.isVisible = true
    oxygenTank2.isVisible = true
    oxygenTank3.isVisible = true
end

local function MakeHeartsVisible()
    heart1.isVisible = true
    heart2.isVisible = true
end

local function onCollision( self, event )
    -- for testing purposes
    --print( event.target )        --the first object in the collision
    --print( event.other )         --the second object in the collision
    --print( event.selfElement )   --the element (number) of the first object which was hit in the collision
    --print( event.otherElement )  --the element (number) of the second object which was hit in the collision
    --print( event.target.myName .. ": collision began with " .. event.other.myName )

    if ( event.phase == "began" ) then

        --Pop sound
        hittingfireballoundChannel = audio.play(hittingfireballound)

        if  (event.target.myName == "fireball1") or 
            (event.target.myName == "fireball2") or
            (event.target.myName == "fireball3") then

            if (soundOn == true) then    
                -- add sound effect here
                hittingfireballoundChannel = audio.play(hittingfireballound)
            end

            -- remove runtime listeners that move the character
            RemoveArrowEventListeners()
            RemoveRuntimeListeners()

            -- remove the character from the display
            display.remove(character)

            -- decrease number of lives
            numLives = numLives - 1

            if (numLives == 2) then
                -- update hearts
                heart1.isVisible = true
                heart2.isVisible = false
                timer.performWithDelay(200, ReplaceCharacter) 

            elseif (numLives == 1) then
                -- update hearts
                heart1.isVisible = false
                heart2.isVisible = false
                timer.performWithDelay(200, ReplaceCharacter)
                timer.performWithDelay(200, YouLoseTransition)
            end
        end

        if  (event.target.myName == "oxygenTank1") or
            (event.target.myName == "oxygenTank2") or
            (event.target.myName == "oxygenTank3") then

            -- get the oxygenTank that the user hit
            theOxygenTank = event.target

            -- stop the fireballs from moving
            scrollSpeedFireball1 = 0
            scrollSpeedFireball2 = 0
            scrollSpeedFireball3 = 0

            -- stop the character from moving
            motionx = 0

            -- make the character invisible
            character.isVisible = false

            -- show overlay with math question
            composer.showOverlay( "level1_question", { isModal = true, effect = "fade", time = 100})

            -- increment questions answered
            questionsAnswered = questionsAnswered + 1
        end

        if (event.target.myName == "blackHole") then
            --check to see if the user has answered 3 questions
            if (questionsAnswered == 3) then
                -- after getting 3 questions right, go to the you win screen
                composer.gotoScene( "you_win" )
            end
        end        

    end
end 

local function AddCollisionListeners()
    -- if character collides with fireball, onCollision will be called
    fireball1.collision = onCollision
    fireball1:addEventListener( "collision" )
    fireball2.collision = onCollision
    fireball2:addEventListener( "collision" )
    fireball3.collision = onCollision
    fireball3:addEventListener( "collision" )

    -- if character collides with oxygenTank, onCollision will be called    
    oxygenTank1.collision = onCollision
    oxygenTank1:addEventListener( "collision" )
    oxygenTank2.collision = onCollision
    oxygenTank2:addEventListener( "collision" )
    oxygenTank3.collision = onCollision
    oxygenTank3:addEventListener( "collision" )

    blackHole.collision = onCollision
    blackHole:addEventListener( "collision" )
end

local function RemoveCollisionListeners()
    fireball1:removeEventListener( "collision" )
    fireball2:removeEventListener( "collision" )
    fireball3:removeEventListener( "collision" )

    oxygenTank1:removeEventListener( "collision" )
    oxygenTank2:removeEventListener( "collision" )
    oxygenTank3:removeEventListener( "collision" )

    blackHole:removeEventListener( "collision")

end

local function AddPhysicsBodies()

    physics.addBody( platform1, "static", { density=1, friction=0.3, bounce=0.2 } )
    physics.addBody( platform2, "static", { density=1, friction=0.3, bounce=0.2 } )
    physics.addBody( platform3, "static", { density=1, friction=0.3, bounce=0.2 } )
    physics.addBody( platform4, "static", { density=1, friction=0.3, bounce=0.2 } )

    physics.addBody(leftW, "static", {density=1, friction=0.3, bounce=0.2} )
    physics.addBody(rightW, "static", {density=1, friction=0.3, bounce=0.2} )
    physics.addBody(topW, "static", {density=1, friction=0.3, bounce=0.2} )
    physics.addBody(floor, "static", {density=1, friction=0.3, bounce=0.2} )

    physics.addBody(oxygenTank1, "static", {density=0, friction=0, bounce=0})
    physics.addBody(oxygenTank2, "static", {density=0, friction=0, bounce=0})
    physics.addBody(oxygenTank3, "static", {density=0, friction=0, bounce=0})

    physics.addBody(fireball1, "static", {density=1.0, friction=0.3, bounce=0.2})
    physics.addBody(fireball2, "static", {density=1.0, friction=0.3, bounce=0.2})
    physics.addBody(fireball3, "static", {density=1.0, friction=0.3, bounce=0.2})

    physics.addBody(blackHole, "static", {density=1, friction=0.3, bounce=0.2})

end

local function RemovePhysicsBodies()

    physics.removeBody(platform1)
    physics.removeBody(platform2)
    physics.removeBody(platform3)
    physics.removeBody(platform4)

    physics.removeBody(fireball1)
    physics.removeBody(fireball2)
    physics.removeBody(fireball3)

    physics.removeBody(leftW)
    physics.removeBody(rightW)
    physics.removeBody(topW)
    physics.removeBody(floor)
 
end

-----------------------------------------------------------------------------------------
-- GLOBAL FUNCTIONS
-----------------------------------------------------------------------------------------

function ResumeGame()

    print ("***numLives" .. numLives)
    LoseHearts()

    -- make character visible again
    character.isVisible = true

    -- start the fireball movements
    scrollSpeedFireball1 = 3
    scrollSpeedFireball2 = 1.6
    scrollSpeedFireball3 = 4
    
    if (questionsAnswered > 0) then
        print ("***questionsAnswered = " .. questionsAnswered)
        if (theOxygenTank ~= nil) and (theOxygenTank.isBodyActive == true) then
            physics.removeBody(theOxygenTank)
            theOxygenTank.isVisible = false
        end
    end

end

-----------------------------------------------------------------------------------------
-- GLOBAL SCENE FUNCTIONS
-----------------------------------------------------------------------------------------

-- The function called when the screen doesn't exist
function scene:create( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -- Insert the background image
    bkg_image = display.newImageRect("Images/bkg.png", display.contentWidth, display.contentHeight)
    bkg_image.x = display.contentWidth / 2 
    bkg_image.y = display.contentHeight / 2

    -- Insert background image into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( bkg_image )  

    platform1 = display.newImageRect("Images/platform.png", 175, 35)
    platform1.x = 90
    platform1.y = display.contentHeight/2

    sceneGroup:insert( platform1 ) 

    platform2 = display.newImageRect("Images/platform.png", 175, 35)
    platform2.x = display.contentWidth * 3/8
    platform2.y = display.contentHeight * 6.2/8

    sceneGroup:insert( platform2 )

    platform3 = display.newImageRect("Images/platform.png", 175, 35)
    platform3.x = display.contentWidth * 4.9/8
    platform3.y = display.contentHeight * 3/8

    sceneGroup:insert( platform3 )   

    platform4 = display.newImageRect("Images/platform.png", 175, 35)
    platform4.x = 938
    platform4.y = display.contentHeight * 5/8

    sceneGroup:insert( platform4 )  

    fireball1 = display.newImageRect("Images/fireball.png", 50, 50)
    fireball1.x = display.contentWidth * 3 / 8
    fireball1.y = display.contentHeight * 2.8 / 5
    fireball1.myName = "fireball1"
        
    sceneGroup:insert( fireball1)

    fireball2 = display.newImageRect("Images/fireball.png", 50, 50)
    fireball2.x = display.contentWidth * 6.37 / 8
    fireball2.y = display.contentHeight * 2 / 5
    fireball2.myName = "fireball2"
        
    sceneGroup:insert( fireball2)

    fireball3 = display.newImageRect("Images/fireball.png", 50, 50)
    fireball3.x = display.contentWidth * 4.9 / 8
    fireball3.y = display.contentHeight * 0.8 / 5
    fireball3.myName = "fireball3"
        
    sceneGroup:insert( fireball3)

    -- Insert the black hole
    blackHole = display.newImageRect("Images/blackHole.png", 200, 200)
    blackHole.x = display.contentWidth* 8/9
    blackHole.y = display.contentHeight*6.1/7
    blackHole.myName = "blackHole"

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( blackHole )

    -- Insert the Hearts
    heart1 = display.newImageRect("Images/heart.png", 100, 100)
    heart1.x = 50
    heart1.y = 50
    heart1.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( heart1 )

    heart2 = display.newImageRect("Images/heart.png", 100, 100)
    heart2.x = 160
    heart2.y = 50
    heart2.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( heart2 )

    --Insert the right arrow
    rArrow = display.newImageRect("Images/Arrow.png", 110, 50)
    rArrow.x = display.contentWidth * 2.07 / 10
    rArrow.y = display.contentHeight * 9.5 / 10
    rArrow:rotate(180)
   
    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( rArrow)

    --Insert the left arrow
    uArrow = display.newImageRect("Images/Arrow.png", 110, 50)
    uArrow.x = display.contentWidth* 1.34/10
    uArrow.y = display.contentHeight * 8.4 / 10
    uArrow:rotate(90)

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( uArrow)

    --Insert the left arrow
    lArrow = display.newImageRect("Images/Arrow.png", 110, 50)
    lArrow.x = display.contentWidth * 0.6 / 10
    lArrow.y = display.contentHeight * 9.5 / 10
       
    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( lArrow)

    --WALLS--
    leftW = display.newLine( 0, 0, 0, display.contentHeight)
    leftW.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( leftW )

    rightW = display.newLine( 0, 0, 0, display.contentHeight)
    rightW.x = display.contentCenterX * 2
    rightW.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( rightW )

    topW = display.newLine( 0, 0, display.contentWidth, 0)
    topW.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( topW )

    floor = display.newImageRect("Images/Level-1Floor.png", 1024, 100)
    floor.x = display.contentCenterX
    floor.y = display.contentHeight * 1.06
    
    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( floor )

    --oxygenTank1
    oxygenTank1 = display.newImageRect ("Images/oxygenTank.png", 60, 75)
    oxygenTank1.x = display.contentWidth * 3/8
    oxygenTank1.y = 540
    oxygenTank1.myName = "oxygenTank1"

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( oxygenTank1 )

    --oxygenTank2
    oxygenTank2 = display.newImageRect ("Images/oxygenTank.png", 60, 75)
    oxygenTank2.x = 625
    oxygenTank2.y = 235
    oxygenTank2.myName = "oxygenTank2"

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( oxygenTank2 )

    --oxygenTank3
    oxygenTank3 = display.newImageRect ("Images/oxygenTank.png", 60, 75)
    oxygenTank3.x = 940
    oxygenTank3.y = 428
    oxygenTank3.myName = "oxygenTank3"
    
    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( oxygenTank3 )

end --function scene:create( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to appear on screen
function scene:show( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view
    local phase = event.phase

    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then

        -- Called when the scene is still off screen (but is about to come on screen).
    -----------------------------------------------------------------------------------------
        -- start physics
        physics.start()

        -- set gravity
        physics.setGravity( 0, GRAVITY )

    elseif ( phase == "did" ) then

        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.

        numLives = 3
        questionsAnswered = 0

        -- make all soccer oxygen tanks visible
        MakeOxygenTanksVisible()

        -- make all lives visible
        MakeHeartsVisible()

        -- add physics bodies to each object
        AddPhysicsBodies()

        -- add collision listeners to objects
        AddCollisionListeners()

        -- create the character, add physics bodies and runtime listeners
        ReplaceCharacter()

        -- add the mute and unmute functionality to the buttons
        AddMuteUnMuteListeners()

        -- add the fireball movement functionalities
        Runtime:addEventListener("enterFrame", MoveFireball1)
        Runtime:addEventListener("enterFrame", MoveFireball2)
        Runtime:addEventListener("enterFrame", MoveFireball3)
    end

end --function scene:show( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to leave the screen
function scene:hide( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view
    local phase = event.phase

    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.

    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        -- stop the background music
        audio.stop(bkgMusicL1Channel)

        -- Called immediately after scene goes off screen.
        RemoveCollisionListeners()
        RemovePhysicsBodies()

        physics.stop()
        RemoveArrowEventListeners()
        RemoveRuntimeListeners()
        RemoveMuteUnMuteListeners()

        display.remove(character)
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
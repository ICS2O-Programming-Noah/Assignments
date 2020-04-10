----------------------------------------------------------------------------------------------------
-- Title: MathFun
-- Name: Noah Sabbagh
-- Course: ICS2O
-- This prorgram displaScreenshot 3Wys a numeric text field and goes through a boolean expression
-- choosing addition, subtraction, multiplication or division. 
----------------------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar(display.HiddenStatusBar) 

-- sets the background colour
display.setDefault("background", 100/255, 22/255, 97/255)

------------------------------------------------------------------------------------------------
-- LOCAL VARIABLES
------------------------------------------------------------------------------------------------

-- create local variables
local randomOperator

local questionObject
local correctObject
local incorrectObject

local numericField

local randomNumber1
local randomNumber2

local userAnswer
local correctAnswer = 1
local correctAnswerText
local incorrectAnswer
local counter = 1

local gameOver

local points = 0
local wrongs = 0

-- variables for the timer
local totalSeconds = 10
local secondsLeft = 10
local clockText
local countDownTimer

-- variables for the heart
local lives = 5
local heart1
local heart2

local stopGame = false

------------------------------------------------------------------------------------------------
-- SOUNDS
------------------------------------------------------------------------------------------------

-- Correct sound
local correctSound = audio.loadSound("Sounds/correctSound.mp3")
local correctSoundChannel

-- Incorrect sound
local incorrectSound = audio.loadSound("Sounds/incorrectSound.mp3")
local incorrectSoundChannel

-- Game Over sound
local gameOverSound = audio.loadSound("Sounds/gameOver.mp3")
local gameOverSoundChannel

-- Background music
local backgroundSound = audio.loadSound("Sounds/backgroundMusic.mp3")
local backgroundSoundChannel

-- Play the background music when the game begins
backgroundSoundChannel = audio.play(backgroundSound)

------------------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
------------------------------------------------------------------------------------------------

local function LoseLives()

	incorrectSoundChannel = audio.play(incorrectSound)

	lives = lives - 1

	secondsLeft = totalSeconds

	if (lives == 4) then
		heart4.isVisible = false
	elseif (lives == 3) then
		heart3.isVisible = false
	elseif (lives == 2) then
		heart2.isVisible = false
	elseif (lives == 1) then
		heart1.isVisible = false
		gameOverSoundChannel = audio.play(gameOverSound)
		numericField.isVisible = false
		gameOver.isVisible = true
		timer.cancel(countDownTimer)
		incorrectObject.isVisible = false
		clockText.isVisible = false
		stopGame = true
		backgroundSound = audio.stop(backgroundSoundChannel)
	end
end

local function AskQuestion()
    -- generate a random number between 1 and 4
    randomOperator = math.random(1, 4)

	-- generate 2 random numbers between a max. and a min. number
	randomNumber1 = math.random(0, 4)
    randomNumber2 = math.random(0, 4)
    
    -- if the random operator is 1, then do addition
    if (randomOperator == 1) then

        -- calculate the correct answer
        correctAnswer = randomNumber1 + randomNumber2

        -- create question in text object
        questionObject.text = randomNumber1 .. " + " .. randomNumber2 .. " = "
    
    -- otherwise, if the random operator is 2, do subtraction
    elseif (randomOperator == 2) then
        
        if (randomNumber2 > randomNumber1) then
        
        -- calculate answer with numbers flipped
        correctAnswer = randomNumber2 - randomNumber1

        -- create question in text object
        questionObject.text = randomNumber2 .. " - " .. randomNumber1 .. " = "
        else 
	    -- calculate the correct answer
	    correctAnswer = randomNumber1 - randomNumber2

	    -- create question in text object
        questionObject.text = randomNumber1 .. " - " .. randomNumber2 .. " = "
        end

    -- otherwise, if the random operator is 3, do multiplication
    elseif (randomOperator == 3) then

        -- calculate the correct answer
        correctAnswer = randomNumber1*randomNumber2

        -- create question in text object
        questionObject.text = randomNumber1 .. " * " .. randomNumber2 .. " = "

     -- otherwise, if the random operator is 4, do division
    elseif (randomOperator == 4) then

        -- calculate the correct answer
        correctAnswer = randomNumber1/randomNumber2
		correctAnswer = correctAnswer * 10
		correctAnswer = math.round(correctAnswer)
		correctAnswer = correctAnswer / 10

         -- create question in text object
        questionObject.text = randomNumber1 .. " / " .. randomNumber2 .. " = "
    elseif (randomOperator == 5) then
    	while ()

    end
end

local function UpdateTime()

	-- decrement the number of seconds
	secondsLeft = secondsLeft - 1

	-- display the number of seconds left in the clock object
	clockText.text = secondsLeft .. ""

	if (secondsLeft == 0) then
		-- reset the number of seconds left
		LoseLives()
		AskQuestion()
	end
end

-- function that calls the timer
local function StartTimer()
		-- create a countdown timer that loops infinitely
		countDownTimer = timer.performWithDelay(1000, UpdateTime, 0)
end

local function HideCorrect()
	correctObject.isVisible = false
	AskQuestion()
end

local function HideIncorrect()
	incorrectObject.isVisible = false
	if (stopGame == false) then
	AskQuestion()
	end
end

local function HideCorrectAnswerText()
	correctAnswerText.isVisible = false
end

local function NumericFieldListener( event )

	-- user begins editing "numericField"
	if ( event.phase == "began" ) then

		-- clear text field
		event.target.text = ""

	elseif event.phase == "submitted" then

		-- when the answer is submitted (enter key is pressed) set user input to user's answer
		userAnswer = tonumber(event.target.text)

		-- if the user's answer and the correct answer are the same:
		if (userAnswer == correctAnswer) then
		
			-- give a point if the user gets the correct answer, display "Correct!", and play a correct answer sound
			points = points + 1
			correctObject.isVisible = true
			correctSoundChannel = audio.play(correctSound)
			secondsLeft = totalSeconds

			-- update it in the display object
			pointsText.text = "Points = " .. points

			-- perform HideCorrect with a delay and clear the text field
			timer.performWithDelay(1500, HideCorrect)
			event.target.text = ""

		else

			-- display "Incorrect!", show the right answer, and subtract one life
			incorrectObject.isVisible = true
			correctAnswerText = display.newText( "The correct answer is " .. correctAnswer, display.contentWidth/2, display.contentHeight*(4/5), nil, 50)
			timer.performWithDelay(2000, HideIncorrect)
			timer.performWithDelay(2000, HideCorrectAnswerText)
			event.target.text = ""
			LoseLives()

			-- play incorrect answer sound
			incorrectSoundChannel = audio.play(incorrectSound)
		end	
	end
end

------------------------------------------------------------------------------------------------
-- OBJECT CREATION
------------------------------------------------------------------------------------------------

-- create the lives to display on the screen
heart1 = display.newImageRect("Images/heart.png", 100, 100)
heart1.x = display.contentWidth * 7 / 8
heart1.y = display.contentWidth * 1 / 7

heart2 = display.newImageRect("Images/heart.png", 100, 100)
heart2.x = display.contentWidth * 6 / 8
heart2.y = display.contentWidth * 1 / 7

heart3 = display.newImageRect("Images/heart.png", 100, 100)
heart3.x = display.contentWidth * 5 / 8
heart3.y = display.contentWidth * 1 / 7

heart4 = display.newImageRect("Images/heart.png", 100, 100)
heart4.x = display.contentWidth * 4 / 8
heart4.y = display.contentWidth * 1 / 7

-- display the amount of points as a text object
pointsText = display.newText("Points = " .. points, display.contentWidth*(1/4), display.contentHeight*(1/5), nil, 50)
pointsText:setTextColor(255/255, 255/255, 255/255)

-- display the number of seconds remaining
clockText = display.newText( secondsLeft .. "", display.contentWidth*(5/6), display.contentHeight*(6/7), nil, 150)
clockText:setTextColor(255/255, 0/255, 0/255)
clockText.isVisible = true

-- displays a question and sets the colour
questionObject = display.newText("", display.contentWidth/2 - 50, display.contentHeight/2, nil, 100)
questionObject:setTextColor(165/255, 195/255, 144/255)

-- create the correct text object and make it invisible
correctObject = display.newText("Correct!", display.contentWidth/2, display.contentHeight*2/3, nil, 50)
correctObject:setTextColor(0/255, 0/255, 204/255)
correctObject.isVisible = false

-- create the incorrect text object and make it invisible
incorrectObject = display.newText("Incorrect!", display.contentWidth/2, display.contentHeight*2/3, nil, 50)
incorrectObject:setTextColor(204/255, 0/255, 102/255)
incorrectObject.isVisible = false

-- create game over image
gameOver = display.newImageRect("Images/0lives.jpg", 300, 300)
gameOver.x = display.contentWidth * 1 / 2
gameOver.y = display.contentWidth * 1 / 3
gameOver:scale(3, 3)
gameOver.isVisible = false

-- create numeric field
numericField = native.newTextField(display.contentWidth*(3/4), display.contentHeight/2, 150, 100)
numericField.inputType = "number"

-- add the event listeners for the numeric field
numericField:addEventListener("userInput", NumericFieldListener)

------------------------------------------------------------------------------------------------
-- FUNCTION CALLS
------------------------------------------------------------------------------------------------

-- call the function to ask the question
AskQuestion()

-- update the timer
StartTimer()
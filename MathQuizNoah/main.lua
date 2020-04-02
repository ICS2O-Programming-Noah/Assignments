-----------------------------------------------------------------------------------------
-- Noah Sabbagh
-- main.lua
--ICS2O
-- This program is very similar to math fun. A addition, subtraction, multiplication,
-- division, or factorial question is asked. If they answer wrong or do not answer
-- before the time runs out, they lose a life. Once they lose all their lives, 
-- they receive a game over picture. 
-----------------------------------------------------------------------------------------


-- hide the status bar 
display.setStatusBar(display.HiddenStatusBar)

-- change the background colour
display.setDefault("background", 95/255, 230/255, 226/255)

-----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------

local randomOperator

local randomNumber1
local randomNumber2

local mulRandomNumber1
local mulRandomNumber2

local divRandomNumber1
local divRandomNumber2

local correctAnswer
local tempAnswer
local questionObject
local userCorrectAnswers = 0
local userCorrectAnswersText

local numericField
local incorrectObject
local correctObject

local correctSound = audio.loadSound("Sounds/correctSound.mp3")
local correctSoundChannel
local incorrectSound = audio.loadSound("Sounds/incorrectSound.mp3")
local incorrectSoundChannel
local backgroundMusic = audio.loadSound("Sounds/backgroundMusic.mp3")
local backgroundMusicChannel
local gameOver

-- variables for the timer
local totalSeconds = 10
local secondsLeft = 10
local clockText
local countDownTimer

-- variables for lives
local lives = 3
local heart1
local heart2


-----------------------------------------------------------------------------------------
-- ADDING SOUND
-----------------------------------------------------------------------------------------

backgroundMusicChannel = audio.play(backgroundMusic)

-----------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
-----------------------------------------------------------------------------------------

-- Function: AskQuestionListener
-- Input: event listener
-- Output: none
-- Description: This funciton accepts an event listener
local function AskQuestion()
	-- generate a random number between 1 and 4
	randomOperator = math.random(1,4)

	-- generate 2 random numbers for addition and subtraction
	randomNumber1 = math.random(1,20)
	randomNumber2 = math.random(1,20)

	--generate 2 random numbers for multiplication
	mulRandomNumber1 = math.random(1,10)
	mulRandomNumber2 = math.random(1,10)

	-- generate 2 random numbers for division
	divRandomNumber1 = math.random(1,100)
	divRandomNumber2 = math.random(1,100)

	-- if random operator is 1, then do addtion
	if (randomOperator == 1) then
		-- calculate the correct answer
		correctAnswer = randomNumber1 + randomNumber2

		-- create question text object
		questionObject.text = randomNumber1 .. " + " .. randomNumber2 .. " = "
	
	-- however, if the random operator is 2, do subtraction
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
		-- but, if the random operator is 3, do multiplication
	elseif (randomOperator == 3) then
		--calculate the correct answer
		correctAnswer = randomNumber1 * randomNumber2

		-- create question text object
		questionObject.text = randomNumber1 .. " * " .. randomNumber2 .. " = "

	-- otherwise, if random operator is 4, do division
	elseif (randomOperator == 4) then
		tempAnswer = divRandomNumber1 * divRandomNumber2
		correctAnswer = tempAnswer / divRandomNumber1

		-- create question text object
		questionObject.text = tempAnswer .. " / " .. divRandomNumber1 .. " = "
	end
end
 
local function HideCorrect()
	correctObject.isVisible = false
	AskQuestion()
end

local function HideIncorrect()
	incorrectObject.isVisible = false
	AskQuestion()
end

local function AddCorrectPoints()
	if (userAnswer == correctAnswer) then
		userCorrectAnswers = userCorrectAnswers + 1
		userCorrectAnswersText.text = "Correct Answers = " .. userCorrectAnswers
	end
end

local function LoseLives()
	if (userAnswer ~= correctAnswer) then
		lives = lives - 1
		if (lives == 2) then
			heart2.isVisible = false
		elseif (lives == 1) then
			heart1.isVisible = false
		elseif (lives == 0) then
			timer.cancel(countDownTimer)
		end
	end
end

-- Function: NumericFieldListener
-- Input: event listener
-- Ouput: none
-- Description: This function accepts an event listener 
local function NumericFieldListener (event)
	-- User begins editing the numeric field
	if ( event.phase == "began" ) then
		
		-- clear the text field
		event.target.text = ""

	elseif ( event.phase == "submitted" ) then

		-- when the answer is submitted (enter key is pressed) set user input to user's answer
		userAnswer = tonumber(event.target.text)

		-- if the users answer and the correct answer are the same:
		if (userAnswer == correctAnswer) then
			correctObject.isVisible = true
			incorrectObject.isVisible = false
			timer.performWithDelay(2000, HideCorrect)	
			-- clear the text field
			event.target.text = ""
			AddCorrectPoints()
			correctSoundChannel = audio.play(correctSound)
			secondsLeft = totalSeconds
		else 
			incorrectObject.text = "Sorry! That's incorrect.\nThe correct answer is \n".. correctAnswer
			incorrectObject.isVisible = true
			correctObject.isVisible = false
			timer.performWithDelay(2000, HideIncorrect)
			LoseLives()
			-- clear the text field
			event.target.text = ""
			incorrectSoundChannel = audio.play(incorrectSound)
		end
	end
end

local function UpdateTime()
	-- decrement the number of seconds
	secondsLeft = secondsLeft - 1

	-- display the number of seconds left in the clock object
	clockText.text = secondsLeft .. ""
	
	if (secondsLeft == 0) then
		secondsLeft = totalSeconds
		LoseLives()
	end
end

--function that calls the timer
local function StartTimer()
	--create a countdown timer that loops infinitely
	countDownTimer = timer.performWithDelay(1000, UpdateTime, NumericFieldListener, 0)
end

--------------------------------------ScSc---------------------------------------------------
-- OBJECT CREATIO
-----------------------------------------------------------------------------------------

-- create the question text object
questionObject = display.newText( "", display.contentWidth/3, display.contentHeight/2, nil, 75)
questionObject:setTextColor(11/255, 16/255, 189/255)

-- create the numeric field
numericField = native.newTextField( display.contentWidth*2/3, display.contentHeight*2/3, 200, 100)
numericField.inputType = "decimal"

-- create the correct text object and make it invisible
correctObject = display.newText( "Correct!", display.contentWidth*3/4, display.contentHeight*1/2, nil, 50 )
correctObject:setTextColor(199/255, 41/255, 205/255)
correctObject.isVisible = false

-- create the incorrect text object and make it invisible
incorrectObject = display.newText( "", display.contentWidth*4/5, display.contentHeight*1/2, nil, 40 )
incorrectObject:setTextColor(2/255, 60/255, 219/255)
incorrectObject.isVisible = false

-- create the game over image
gameOver = display.newImageRect("Images/0lives.jpg", 1024, 1000)
gameOver.x = 512
gameOver.y = 334
gameOver.alpha = false

-- create the lives to display on the screen
heart1 = display.newImageRect("Images/heart.png", 100, 100)
heart1.x = display.contentWidth * 7/8
heart1.y = display.contentHeight * 1/7

heart2 = display.newImageRect("Images/heart.png", 100, 100)
heart2.x = display.contentWidth * 6/8
heart2.y = display.contentHeight * 1/7

-- create the text object for the clock
clockText = display.newText( secondsLeft .. "", display.contentWidth*1/6, display.contentHeight*1/7, nil, 150)
clockText:setTextColor(11/255, 16/255, 189/255)

-- create the text object for the correct userCorrectAnswers
userCorrectAnswersText = display.newText("Correct Answers = " .. userCorrectAnswers, display.contentWidth/2, display.contentHeight*1/3, nil, 50)

-----------------------------------------------------------------------------------------
-- FUNCTION CALLS
-----------------------------------------------------------------------------------------

-- call the function to ask the question
AskQuestion()

-- create the event listener for the numeric field
numericField:addEventListener( "userInput", NumericFieldListener)

-- call the function to start the timer
StartTimer()
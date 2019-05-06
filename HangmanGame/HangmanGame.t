%Alexander Li
%HangmanGame.t
%10/01/2018
%Mr. Rosen
%This program is a hangman game with ICS terms that the player must
%guess (one letter at a time) before they run out of incorrect guesses.

%Set screen up
import GUI
setscreen ("noecho")

%Declaration Section
var mainWin := Window.Open ("position: 400;300, graphics: 640;400")
var mainMenuButton : int := 0
var answerArray : array 1 .. 2, 1 .. 20 of string :=    %Reference array containing all answers (in the first row) and hints (in the second row).
    init ("Hard Disk Drive", "variable", "boolean", "Operating System", "Central Processing Unit", "Read-Only Memory", "primary storage", "Gigabyte", "local variable", "program comments", "string", "KISS", "User Input", "main program", "procedure", "programming language", "Turing", "import", "Graphical User Interface", "loop",
    "A magnetic storage device usually with a capacity of hundreds of GBs", "A (stored) value that can change", "Can either be true or false", "Computer software that connects the hardware to other programs", "A microchip that handles basic logic and calculations", "Memory that cannot be written to", "Memory that can be quickly accessed and written to", "A unit of storage approximately 1,000,000,000 bytes", "A variable declared within a procedure/method", "Text showing information about the program but not affecting it", "A variable type that stores text", "Rule 1: KEEP IT SHORT and SIMPLE", "Information recieved by the user, via mouse, keyboard, etc.", "Where all procedures are called and program flow is organized", "A structure that contains code that can be repeatedly called", "A set of vocabulary and syntax that gives instructions to a computer", "A programming language developed in 1982 used in Ontario high schools", "A command that allows a program to use files stored in a seperate folder", "User input object that uses interactive images", "Keeps executing code until a condition is met to stop it")
var gameAnswerArray : array 1 .. 2, 1 .. 20 of string   %Provides random answers and hints for game usage
var letterArray : array 1 .. 2, 1 .. 26 of string   %Tracks which letters have been guessed
var answer : string
var answerHint : string
var guess : string (1)
var guessString : string    %Tracks all letters in the phrase guessed, is compared to var answer to check if the user has guessed the phrase
var difficultyLevel : int := 2  %Determines if hint is shown in-game
var maxRandInt : int := 0   %Controls what answers can be picked
var wrongGuesses : int  %Tracks the number of wrong guesses, chooses which stickman image to show, ends game at 8
var userInputRan : boolean  %Prevents wrong guess being added on first turn
var gameIsOver : boolean := false    %Stops music process, ends game if true
var isValidGuess : boolean := true  %Checks if guess is a letter
var isNotGuessed : boolean := true
var isCorrectGuess : boolean := false
%Fonts and images
var titleFont : int := Font.New ("Arial:20:bold")
var headingFont : int := Font.New ("Garamond:14:bold")
var picLeftGallows := Pic.FileNew ("LeftGallows.jpg")
var picRightGallows := Pic.FileNew ("RightGallows.jpg")
%Stickman (image) states, labelled by number of wrong guesses required to show them
var picStickman0 := Pic.FileNew ("Stickman0.jpg")
var picStickman1 := Pic.FileNew ("Stickman1.jpg")
var picStickman2 := Pic.FileNew ("Stickman2.jpg")
var picStickman3 := Pic.FileNew ("Stickman3.jpg")
var picStickman4 := Pic.FileNew ("Stickman4.jpg")
var picStickman5 := Pic.FileNew ("Stickman5.jpg")
var picStickman6 := Pic.FileNew ("Stickman6.jpg")
var picStickman7 := Pic.FileNew ("Stickman7.jpg")
var picStickman8 := Pic.FileNew ("Stickman8.jpg")

%Forward procedures
forward procedure mainMenu
forward procedure instructions
forward procedure mainGame
forward procedure display
forward procedure userInput

%AUXILLARY PROCEDURES

%Plays game music during mainGame
process playMusic
    loop
	Music.PlayFile ("mainGameMusic.wav")
	exit when gameIsOver = true
    end loop
end playMusic

%Program title
procedure title
    cls
    Font.Draw ("Hangman Game", 215, 380, titleFont, 17)
    locate (3, 1)
end title

%Sets difficultyLevel to 1 if "Play Game (Level 1)" is selected
procedure levelSelector
    difficultyLevel := 1
    mainGame
end levelSelector

%Sets variables answer and answerHint to a random element from gameAnswerArray
procedure randAnswer
    var randIndex : int
    %Checks if program has run out of answers, re-declares gameAnswerArray if it has
    if maxRandInt <= 0 then
	for x : 1 .. 20
	    gameAnswerArray (1, x) := answerArray (1, x)
	    gameAnswerArray (2, x) := answerArray (2, x)
	end for
	maxRandInt := 20
    end if
    %Generates a random index in gameAnswerArray, assigns the answer and hint from it
    randint (randIndex, 1, maxRandInt)
    answer := gameAnswerArray (1, randIndex)
    answerHint := gameAnswerArray (2, randIndex)
    Window.Show (mainWin)
    %Replaces guessed answers with the last unguessed answer in the array
    gameAnswerArray (1, randIndex) := gameAnswerArray (1, maxRandInt)
    gameAnswerArray (2, randIndex) := gameAnswerArray (2, maxRandInt)
    maxRandInt -= 1
    delay (5000)
end randAnswer

%MAIN PROCEDURES

%Program introduction and game code
procedure intro
    var xCoord : int := -20
    var yCoord : int := -20
    mainMenuButton := GUI.CreateButtonFull (270, 30, 0, "Main Menu", mainMenu, 0, '^D', true)
    title
    put "This program helps ICS students learn new computer-related terms and test their"
    put "knowledge of them."
    GUI.Show (mainMenuButton)
    %Draw gallows
    for x : 0 .. 30
	drawline (560 + x, 260 - x, 565 + x, 260 - x, 113)
    end for
    drawfillbox (500, 80, 600, 90, 114)
    drawfillbox (590, 90, 600, 250, 114)
    drawfillbox (535, 250, 600, 260, 114)
    drawline (540, 225, 540, 250, 17)
    for x : 0 .. 230    %Animation of the stickman going up and right, onto the screen
	drawfillbox (xCoord - 26, yCoord - 91, xCoord + 25, yCoord + 15, 31)    %Erase
	drawoval (xCoord, yCoord, 15, 15, 17)   %Head
	drawline (xCoord, yCoord - 15, xCoord, yCoord - 60, 17) %Body
	drawline (xCoord, yCoord - 20, xCoord - 25, yCoord - 10, 17)    %Left arm
	drawline (xCoord, yCoord - 20, xCoord + 25, yCoord - 10, 17)    %Right arm
	drawline (xCoord, yCoord - 60, xCoord - 20, yCoord - 90, 17)    %Left leg
	drawline (xCoord, yCoord - 60, xCoord + 20, yCoord - 90, 17)    %Right leg
	drawfilloval (xCoord - 5, yCoord + 5, 1, 1, 17) %Left eye
	drawfilloval (xCoord + 5, yCoord + 5, 1, 1, 17) %Right eye
	drawfilloval (xCoord, yCoord - 6, 6, 2, 17) %Mouth
	delay (10)
	xCoord += 1
	yCoord += 1
    end for
    for x : 0 .. 330    %Animation of the stickman going right, to gallows
	drawfillbox (xCoord - 26, yCoord - 90, xCoord + 25, yCoord + 15, 31)    %Erase
	drawoval (xCoord, yCoord, 15, 15, 17)   %Head
	drawline (xCoord, yCoord - 15, xCoord, yCoord - 60, 17) %Body
	drawline (xCoord, yCoord - 20, xCoord - 25, yCoord - 40, 17)    %Left arm
	drawline (xCoord, yCoord - 20, xCoord + 25, yCoord - 40, 17)    %Right arm
	drawline (xCoord, yCoord - 60, xCoord - 20, yCoord - 90, 17)    %Left leg
	drawline (xCoord, yCoord - 60, xCoord + 20, yCoord - 90, 17)    %Right leg
	drawfilloval (xCoord - 5, yCoord + 5, 1, 1, 17) %Left eye
	drawfilloval (xCoord + 5, yCoord + 5, 1, 1, 17) %Right eye
	drawfilloval (xCoord, yCoord - 6, 6, 2, 17) %Mouth
	delay (7)
	xCoord += 1
    end for
end intro

%Main menu, option select
body procedure mainMenu
    title
    fork playMusic
    GUI.Hide (mainMenuButton)
    Font.Draw ("Main Menu", 275, 300, headingFont, 17)
    var playLevel1Button : int := GUI.CreateButton (250, 250, 0, "Play Game (Level 1)", levelSelector)
    var playLevel2Button : int := GUI.CreateButton (250, 228, 0, "Play Game (Level 2)", mainGame)
    var instructionsButton : int := GUI.CreateButton (250, 205, 135, "Instructions", instructions)
    var quitButton : int := GUI.CreateButton (250, 182, 135, "Exit Program", GUI.Quit)
    Pic.Draw (picLeftGallows, 20, 150, picMerge)
    Pic.Draw (picRightGallows, 494, 150, picMerge)
end mainMenu

%Game instructions
body procedure instructions
    title
    locate (3, 35)
    put "Instructions:"
    put "Try to guess a randomly selected ICS-related term!"
    put "Enter a letter and see if it's in the term."
    put "You have 8 incorrect guesses before you lose. (Look at the hangman.)"
    put "You win if you guess the entire term before running out of incorrect guesses."
    GUI.Show (mainMenuButton)
end instructions

%Controls flow of game section
body procedure mainGame
    wrongGuesses := 0
    userInputRan := false
    guessString := ""
    title
    randAnswer
    GUI.Hide (mainMenuButton)
    for x : 1 .. 26     %Declares array letters and T/F value
	letterArray (1, x) := chr (x + 96)
	letterArray (2, x) := 'T'
    end for
    for y : 1 .. length (answer)    %Declares guessString as var answer but with all letters changed to underscores
	if answer (y) = " " or answer (y) = "-" then
	    guessString += answer (y)
	else
	    guessString += "_"
	end if
    end for
    %Controls flow of the game code
    loop
	display
	exit when gameIsOver = true
	loop    %Loop replaces recursion which causes the "previously guessed" message to show every time when a non-valid guess is entered
	    userInput
	    exit when isValidGuess = true and isNotGuessed = true
	end loop
    end loop
    GUI.Show (mainMenuButton)
    difficultyLevel := 2
    gameIsOver := false
    Music.PlayFileStop
end mainGame

%Displays game information, updates stickman, and displays game end messages
body procedure display
    title
    %Checks if guess is correct, displays correct message
    if userInputRan and isCorrectGuess then
	put guess, " is in the term!"
    elsif userInputRan then
	put guess, " is NOT in the term!"
	wrongGuesses += 1
    end if
    %Checks if the hint should be shown
    if difficultyLevel = 1 then
	locate (15, 37 - length (answerHint) div 2)
	put "Hint: ", answerHint
    end if
    locate (17, 40 - length (guessString))
    for x : 1 .. length (guessString)
	put guessString (x), " " ..
    end for
    %Puts a list of not-guessed letters
    locate (19, 5)
    put "Letters not guessed: " ..
    for y : 1 .. 26
	if letterArray (2, y) = 'T' then    %Checks if letter has not been guessed
	    put letterArray (1, y), " " ..
	else
	    put "  " ..
	end if
    end for
    %Draws hangman and gallows. If structure checks how many wrong guesses, how many parts to draw
    if wrongGuesses = 8 then
	Pic.Draw (picStickman8, 450, 190, picMerge)
    elsif wrongGuesses = 7 then
	Pic.Draw (picStickman7, 450, 190, picMerge)
    elsif wrongGuesses = 6 then
	Pic.Draw (picStickman6, 450, 190, picMerge)
    elsif wrongGuesses = 5 then
	Pic.Draw (picStickman5, 450, 190, picMerge)
    elsif wrongGuesses = 4 then
	Pic.Draw (picStickman4, 450, 190, picMerge)
    elsif wrongGuesses = 3 then
	Pic.Draw (picStickman3, 450, 190, picMerge)
    elsif wrongGuesses = 2 then
	Pic.Draw (picStickman2, 450, 190, picMerge)
    elsif wrongGuesses = 1 then
	Pic.Draw (picStickman1, 450, 190, picMerge)
    else
	Pic.Draw (picStickman0, 450, 190, picMerge)
    end if
    %Checks for game end conditions
    if wrongGuesses >= 8 then   %For game loss
	locate (21, 24 - length (answer) div 2)
	colour (40)
	put "Game over! The correct term was: ", answer, "."
	colour (17)
	GUI.Show (mainMenuButton)
	gameIsOver := true
	Music.PlayFile ("GameLossSound.wav")
    elsif guessString = answer then     %For game win
	Font.Draw ("Congratulations, you won!", 214, 70, headingFont, 2)
	GUI.Show (mainMenuButton)
	gameIsOver := true
	Music.PlayFile ("GameWinSound.wav")
    end if
end display

%User input and processing using var guess
body procedure userInput
    isValidGuess := true
    isNotGuessed := true
    userInputRan := true
    isCorrectGuess := false
    %Ask for entered char
    locate (5, 1)
    put "Guess a letter: " ..
    getch (guess)
    %Errorcheck, also converts uppercase input to respective lowercase letter
    if ord (guess) >= 65 and ord (guess) <= 90 then     %Uppercase to lowercase convertor
	guess := chr (ord (guess) + 32) 
    elsif not (ord (guess) >= 97 and ord (guess) <= 122) then   %Errorcheck
	locate (3, 1)
	put "Error: you can only enter a letter for your guess." ..
	locate (4, 1)
	put "Please try again." ..
	isValidGuess := false
    end if
    for x : 1 .. 26     %Sets guessed letter's T/F value in letterArray to F to prevent it from being displayed
	if guess = letterArray (1, x) and letterArray (2, x) = 'F' then %Checks if letter has been previously guessed
	    isNotGuessed := false
	elsif guess = letterArray (1, x) then   %Specifies guessed letter as guessed
	    letterArray (2, x) := 'F'
	end if
    end for
    %Checks if guess is in the term, edits guessString to add guessed characters
    for x : 1 .. length (answer)
	if guess = answer (x) or ord (guess) = ord (answer (x)) + 32 then
	    guessString := guessString (1 .. x - 1) + answer (x) + guessString (x + 1 .. *)
	    isCorrectGuess := true
	end if
    end for
    %Checks if the letter has already been guessed, does not add a wrong guess
    if isValidGuess then
	locate (3, 1)
	put "You've already guessed ", guess, "." ..
	locate (4, 1)
	put "Please try again." ..
    end if
end userInput

%Displays program/creator info and closes window
procedure goodbye
    gameIsOver := true
    title
    Music.PlayFileStop
    %Free all fonts and images from memory
    Pic.Free (picLeftGallows)
    Pic.Free (picRightGallows)
    Pic.Free (picStickman0)
    Pic.Free (picStickman1)
    Pic.Free (picStickman2)
    Pic.Free (picStickman3)
    Pic.Free (picStickman4)
    Pic.Free (picStickman5)
    Pic.Free (picStickman6)
    Pic.Free (picStickman7)
    Pic.Free (picStickman8)
    Font.Free (titleFont)
    Font.Free (headingFont)
    put "Thanks for playing!"
    put ""
    put "HangmanGame.t was programmed by Alexander Li for the ICS-2O3"
    put "culminating assignment by commission from the TDSB."
    delay (5000)
    Window.Close (mainWin)
end goodbye

%Main Program
intro
loop
    exit when GUI.ProcessEvent
end loop
goodbye
%End Main Program

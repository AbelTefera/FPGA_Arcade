# Arcade on the FPGA

* [What is this?](./Development-Guide#what-is-this)
* [Background Info](./Development-Guide#background-info)
    * [What's Breakout?](./Development-Guide#whats-breakout)
    * [What's Pong?](./Development-Guide#whats-pong)
    * [How the VGA controller module works](./Development-Guide#how-the-vga-controller-module-works)
    * [How to *use* the VGA controller module](./Development-Guide#how-to-use-the-vga-controller-module)
* [Game](./Development-Guide#menu)
    * [General](./Development-Guide#General)
    * [What each state does](./Development-Guide#what-each-state-does)
* [Breakout](./Development-Guide#breakout)
    * [General](./Development-Guide#General)
    * [What each state does](./Development-Guide#what-each-state-does)
* [Pong](./Development-Guide#breakout)
    * [General](./Development-Guide#General)
    * [What each state does](./Development-Guide#what-each-state-does)
* [Conclusion](./Development-Guide#conclusion)
* [Credits](./Development-Guide#credits)

## What is this?
The goal of this project is to have multiple games run on an Altera DE1 board. The player would have the option to choose from a library of games. It was written in Verilog.

Currently two games have been implemented, Breakout and Pong. You pick the game you want to play from a menu screen which you can return to play other games.

### Known issues
The player point counter in the pong game sometimes counts up by a number greater than one when the ball goes of the screen. 
When a game of pong is completed, the option to replay doesn't work, this could be to an error in the finite state machine.
When playing Breakout there is slight chance that when the ball reaches the top of the screen it takes you to the gameover screen.

#### TODO
* Continue debugging.
* Check for timing issues.
* Check finite state machine in Pong module for replay option.

## Background Info
### What's Breakout?
Breakout is classic game in which the player controls a bar on the bottome of the screen with a fixed y position, moving it left and right. There are also multiple blocks (18 in this implementation) on the top of the screen. The goal is the 'break' all the blocks by catching a ball that bounces around, the game ends if you break all blocks or you don't catch the ball (the ball moves past the player bar).

### What's Pong?
Pong is another classic game. It can be multiplayer (usually max of 2 players) or single player where you against an ai. For this project it is strictly player vs player (no ai). There are two player controlled bars on either end of the screen with a ball bouncing between the two. If a ball makes it past a player's bar then the other player gets a point. In this implementation of pong the first player to have points pass a threshold (5 points in this case) wins the game.

### How the VGA controller module works
The VGA controller was copied of from this site [here](https://timetoexplore.net/blog/arty-fpga-vga-verilog-01), it has detailed explanations on how the VGA works at a basic level.

### How to *use* the VGA controller module
The module outputs an x and y value, telling you what pixel it is currently drawing. On the cyclone II / DE1 Altera board each color on the VGA is 4 bits. If a VGA signal is high or equal to 1 then the pixel will have that color. The more VGA signals are on the brigher the pixel will be. To achieve different colors, you would have different combinations of VGA signals on and off.

## Game
### Module Hierarchy
   
### What each state does
* MENU: the menu state displays the menu screen. You can also pick different games to play in this state. press KEY0 to play Breakout or KEY1 to play Pong.
* Breakout: the breakout state sends a start signal to the breakout module which enables it to send VGA signals to display the game. When the module sends a done signal, the fsm in the game module switches to the menu state.
* Pong: the pong state operates in the same manner as the breakout state.

## Breakout
### General
* The Breakout game is implemented as one module that has a start and done signal. If it's start signal is high it will output to the VGA.
* All objects in the game are outputs which are on if the x and y value output from the VGA controller are with in a certain range. 
* The module outputs vga signals that are either sent to the vga controller depending on what state the game module is in.
* The VGA signals in the breakout module are then controlled internally with another finite state machine in the Breakout module.

### What each state does
* start_game
   * initializes the positions of the ball (ball_x and ball_y) and player bar (bar_x).
   * if start signal is high the game starts, until then it is all objects on the screen are frozen.
   * all blocks are turned on.
* playing 
   * this is where all the game logic happens.
   * positions of the player bar and ball are stored in the registers as well as height, width, dir, x_sp, y_sp, etc...
   * these are all updated on the clock. A counter within the module is used to make the updates more reasonable timed.
   * the ball's x and y values are stored on to registers which are updated through a counter within
   * the coordinates of the blocks are hard coded in, but they have a reg called block_on that determins if the corresponding block is high or low givin that x and y are within that blocks x and y range.
   * collision is determined by checking for x and y values of objects. For example, if the x and y range of the ball are within the x and y range of the player bar, that is a collision. 
* game_done
   * Either a green or red screen is generated depending on if you lose or win.
   * You can press KEY0 on the fpga to playagain or KEY3 to go back to main menu.

## Pong
### General
* Pong shared many of Breakouts rules and thus we could re-use code from our Breakout module to speed up development.
* One big difference was the score counter for the players in the game.
* The ball also bounces at a random angle depending on the value of count value, in the exact way as the ball in the breakout module.
* VGA works in the same way as the breakout module.

### What each state does
* start_game: initializes ball speed, dir and position. Initialize the bars' coordinates. Initializes the scores to 0. If start is high it starts the game.

* play_setup: Initializes ball speed, dir and position. Initialize the bars' coordinates. 

* playing: the ball position is update on the clock based on the x and y speeds and direction of the ball. The x and y speed of the ball is set to a random value between 1 and 3 depending on count2. To move the player 1 bar press KEY0 or KEY1. To move the player 2 bar press KEY2 or KEY3. These too update their position on the clock. The bars and ball bounce of the right and left of the screen. First player to get 5 points wins.

* game_done: press KEY0 to play again, press KEY3 to go back to menu. If player 1 wins a red square is drawn. If player 2 wins a blue square is drawn

## Conclusion
One major herdal was getting the ball to bounce randomly in both games. At first I attempted to use a linear fead back register. But the ball would go to fast due to the range of the numbers which were generated making the game unplayable. Generating a new seed every time you would play again also became challenging. 

Collision wasn't hard but rather tedious to do. 

More games could be added to the Arcade. The menu, game_over and win screens can also be drastically improved

When designing the module it was critical for us to start from the bottom up, making sure the individual games worked first before putting them into the game module. We first tried to do almost everything at once and compile, but when we were debugging so many things were wrong it was impossible to tell what was doing what. On attempt 2 we focused first on Breaker then Pong, then we put them together with the menu screen.

## Credits
* VGA controller module from [Will Green](https://timetoexplore.net/blog/arty-fpga-vga-verilog-01)

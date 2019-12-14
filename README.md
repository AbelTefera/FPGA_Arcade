# Arcade on the FPGA

* [What is this?](./Development-Guide#what-is-this)
* [Background Info](./Development-Guide#background-info)
    * [What's Breakout?](./Development-Guide#whats-breakout)
    * [What's Pong?](./Development-Guide#whats-pong)
    * [How the VGA controller module works](./Development-Guide#how-the-vga-controller-module-works)
    * [How to *use* the VGA controller module](./Development-Guide#how-to-use-the-vga-controller-module)
* [Menu](./Development-Guide#menu)
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
The goal of this project was to have multiple games run on an Altera DE1 board. The player would have the option to choose from a library of games. It was written on Verilog.

Currently two games have been implemented, Breakout and Pong. After losing or wining a games you have the option to play again or go back to the main menu.

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
### What each state does
* MENU: the menu state displays the menu screen. You can also pick different games to play in this state.
* Breakout: the breakout state sends a start signal to the breakout module which enables it to send VGA signals to display the game. When the module sends a done signal

## Menu
### General
* 

### What each state does
* asdf

## Breakout
### General
* The Breakout game is implemented as one module that has a start and done signal. If it's start signal is high it will output to the vga.
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
* thisthsdg

### What each state does
* asdfsfsf

## Conclusion
Some of the problems that I found while I was debugging had to do with the if-elseif-else statement being evaluated at the same time. I was also confused about structures that are like the following snippet.

    if (count == 4'd5)
        count <= 4'd0;
    else
        count <= count + 1;

I wasn't sure whether this can potentially cause problems or not, so I ended up adding another state (yes, I should've written a test module).

I was surprised to know how such a simple concept called finite state machine can create and execute a complex logic (at least to me it was complex enough).

One thing that I missed so much from the programming languages I know was temporary variables. I had to use so many counters because of the "everything gets executed at once" nature, and I wished there was the idea "name scope" in Verilog HDL.

## Credits
* VGA controller module from [Dr. John S. Loomis](http://www.johnloomis.org/vita.html) [vgalab1](http://www.johnloomis.org/digitallab/vgalab/vgalab1/vgalab1.html)

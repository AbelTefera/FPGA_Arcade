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
Breakout is classic game in which the player controls a bar on the bottome of the screen with a fixed y position, moving it left and right. There are also multiple blocks on the top of the screen. The goal is the 'break' all the blocks by catching a ball that bounces around, the game ends if you break all blocks or you don't catch the ball (the ball moves past the player bar).

### What's Pong?
Pong is another classic game. It can be multiplayer (usually max of 2 players) or single player where you against an ai. For this project it is strictly player vs player (no ai). There are two player controlled bars on either end of the screen with a ball bouncing between the two. If a ball makes it past a player's bar then the other player gets a point. In this implementation of pong the first player to have points pass a threshold (5 points in this case) wins the game.

### How the VGA controller module works
The VGA controller was copied of from this site [here](https://timetoexplore.net/blog/arty-fpga-vga-verilog-01), it has detailed explanations on how the VGA works at a basic level.

### How to *use* the VGA controller module
The module outputs an x and y value, telling you what pixel it is currently drawing. On the cyclone II / DE1 Altera board each color on the VGA is 4 bits. If a VGA signal is high or equal to 1 then the pixel will have that color. The more VGA signals are on the brigher the pixel will be. To achieve different colors, you would have different combinations of VGA signals on and off.

## Menu
### General
* asdf

### What each state does
* asdf

## Breakout
### General
* hitsfdsfsdf

### What each state does
* INIT
    * Prepares the field for a new game. Uses the `init_x` and `init_y` to paint the entire fi

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

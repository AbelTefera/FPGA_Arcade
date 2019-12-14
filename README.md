# Tetris game on an FPGA board

* [What is this?](./Development-Guide#what-is-this)
* [Background Info](./Development-Guide#background-info)
    * [What's Tetris?](./Development-Guide#whats-tetris)
    * [How the SRAM works](./Development-Guide#how-the-sram-works)
    * [How the VGA controller module works](./Development-Guide#how-the-vga-controller-module-works)
    * [How to *use* the VGA controller module](./Development-Guide#how-to-use-the-vga-controller-module)
* [Design](./Development-Guide#design)
    * [What each state does](./Development-Guide#what-each-state-does)
* [Result (an alternative design)](./Development-Guide#result-an-alternative-design)
* [Conclusion](./Development-Guide#conclusion)
* [Credits](./Development-Guide#credits)

## What is this?
The goal of this project was to run the game [Tetris](http://en.wikipedia.org/wiki/Tetris) on an Altera DE2 board. It was written in Verilog HDL.

Current feature of the game is minimal. The Tetrominoes fall, you stack them, and completed lines get erased. Nothing more. No points, no hold, no "next Tetromino."

### Known issues
The Tetrominoes sometimes (but rarely) stops in mid-air. I am guessing that there is some logical error inside the `WAIT` state but the exact cause is not confirmed yet. I think it has something to do with the move signal no being reset.

#### TODO
* Continue debugging.
* Create separate module that checks if movable.

## Background Info
### What's Tetris?
Tetris is a game in which the user controls 7 types of Tetrominoes that falls down from the "sky" by moving it to the left or right, or rotating it within a field of size 10x22. The user tries to place the Tetrominoes so that one or more rows are completed. Completed rows are erased, and whatever is above that erased line falls until the bottom hits another Tetromino. If you've never played Tetris or if you're already getting bored reading, you can play Tetris [here](http://www.freetetris.org/game.php).

### How the SRAM works
Although at first it may sound like it's hard to use SRAM (it did for me), there are basically only 3 things that you need to know when using it.

1. You specify the address to `SRAM_ADDR`.
2. If you have `SRAM_WE` set to `1`, meaning you're going to write something, whatever you set to `SRAM_DQ` will be written to that address.
3. If you have `SRAM_WE` set to `0`, whatever's already on that address of the SRAM will pop out of `SRAM_DQ`.

Keep in mind that when you're reading, it takes 1 clock cycle to set the address, and another to get the data. This is the reason why there are states in my design called "something_BUFFER". It's basically there just to "buy time."

### How the VGA controller module works
I have no idea. [UTSL](http://catb.org/jargon/html/U/UTSL.html)!

### How to *use* the VGA controller module
The module scans from the top-left corner of the monitor all the way to the top-right corner (and after that starts from 1px down from the top-left corner), setting the current coordinates to `mCoord_X` and `mCoord_Y`. It'll write whatever's set to `mVGA_R`, `mVGA_G`, and `mVGA_B` to that coordinate.

## Design
The basic idea of this game, and many other games is that this is a loop of "Draw -> Erase -> Move". This loop is shown in the following state diagram as the flow that starts from `SET_COLOR`, goes to `WRITE_TO_SRAM` and eventually come back to `SET_COLOR`.

![State diagrom](images/fsm.png)

I reused the state `WRITE_TO_SRAM` to both add and remove color from the SRAM because that state is a fairly large state with around 400 lines of code. What it does is described later. There is also a `PRE_WAIT` in the actual code. This was introduced because I thought that the changing of the `forceReset` caused some issues regarding the resetting of the timer (`sec` register).

Since Tetris is a game that uses grids, it was more convenient to view the monitor in larger grids rather than in pixels. Many of the sample programs that I saw used the combination of x-coordinate and y-coordinate as the address for SRAM (like `SRAM_ADDR = {x_coord, y_coord}`). Deciding that one grid should be a 20px square, I used the following code to determine the address.

    grid_x = (x_coord_in_pixel - 220) / 20;
    grid_y = (y_coord_in_pixel - 20) / 20;
    SRAM_ADDR = {grid_x, grid_y};

The numbers 220 and 20 were calculated from the screen resolution: 10 columns * 20px is used for the field in a 640px-wide monitor. If you wanted the equal space on both sides of the field, the equation would be (640 - 10 * 20) / 2 = 220.

### What each state does
* INIT
    * Prepares the field for a new game. Uses the `init_x` and `init_y` to paint the entire field white.
* GENERATE
    * Uses a linear feedback shifter to get a random number in the range of 0-7. Since 7 is not assigned to any Tetromino, the random number is "trimmed" by the mod operator with the cost of biasing the probability.
    * Although the LFS, which is the `RandomTetromino` module, does not use seeds, this module outputs a random number in a 50MHz frequency. Even though the sequence of the number is the same every run, the interval of picking a number from that sequence is random (depends on the amount of time it takes for a Tetromino to hit the bottom i.e. depends on the user input).
* SET_COLOR
    * Since the `WRITE_TO_SRAM` state simply write whatever is set to `color` to the SRAM, this state sets the `color` according to the current Tetromino.
* WRITE_TO_SRAM
    * Uses the current spin state of the Tetromino and the pivot to write the current state of the Tetromino to the SRAM.
![How deltas are decided](images/plain.png)
    * The most left form is the original spin state, which is how it looks like when it's generated.
    * The top-left corner of the 4x4 grids is always used as the pivot. The grids that should be colorized are presented with the deltas from the pivot. For example, the top grid for the I Tetromino will be `x = tetromino_x + 1`, `y = tetromino_y` where `tetromino_x` and `tetromino_y` are the pivots.
    * The grids in a lighter color shows the grids that overlap with the previous form (before rotated left once). Check for whether the target grid is `WHITE` or not is not done to these grids when checking for spin-ability.
    * This state uses a counter because you can't write all 4 grids to the SRAM in 1 clock cycle.
* WAIT
    * This state waits for a certain amount of time if there are no inputs for moves. The amount of time it waits until the Tetromino moves one down can be varied by using the fact that `SecTimer` increments the counter every 0.02 second.
* REMOVE_COLOR
    * Does basically the same thing as `SET_COLOR` except it sets the color to white, hence, erasing the Tetromino from the field.
* CHECK_IF_MOVABLE
    * Depending on the Tetromino and the current spin state, this state looks at the grids that are going to be painted next, and checks if there's really nothing there by checking if that grid is `WHITE` or not.
    * This state also uses a counter because you can't check all 4 grids at the same time.
    * It also uses a "buffer" state in order to set the `SRAM_ADDR` and then read from the SRAM in 2 clock cycles.
* MOVE_ONE_DOWN
* MOVE_LEFT
* MOVE_RIGHT
* SPIN_LEFT
    * All 4 of these states simply change the pivot coordinate or change the spin state.
* CHECK_COMPLETE_ROW
    * Starts reading from the bottom of the field, one row at a time, and see if all of the grids in the row are `WHITE`. If it finds a `WHITE` grid, it'll go one row up until it hits the top of the field.
* DELETE_ROW
    * When a complete row is found, it'll first delete that row (in other words, paint the row in white).
    * This state is not really necessary, since I could've gone straight to shifting the rows. But still, I felt better to delete the row first and then move on to shifting.
* SHIFT_ALL_BLOCKS_ABOVE
    * After deleting the row, the next thing to do is shift the rows above --one by one to the top. In order to shift one row, each grid in that row had to be replaced with the color of the grid that's right above it. Doing this 10 times will shift one row. `SHIFT_BLOCKS_READ_ABOVE` and `SHIFT_BLOCKS_WRITE_TO_CURRENT` were used to do this, as well as the helper state `DECREMENT_SHIFT_COUNT_Y` and `INCREMENT_SHIFT_COUNT_X`.
    * Note that the y-coordinate decreases as it gets closer to the top of the field.
    * After all the rows are shifted, it goes back to `CHECK_COMPLETE_ROW` to see if there are any other rows that has been completed.

## Result (an alternative design)
I had 2 ideas when I designed this project. One was the approach that was used --reading and writing to the SRAM and move if the next grid is white. The other one was about using a "band."

For example, the field with one L Tetromino can be shown as the following.

    0000000000
    0000000000
    0000000000
    (many rows of 0)
    0000100000
    0000100000
    0000110000

Now, let's say the Tetromino that just spawned was an S Tetromino. This is what I called the "band" (there might be a better name for it but that was what came up on my mind first).

    0000110000
    0000011000

The actual field that will be rendered will be `band | field` and checking whether the S Tetromino is movable or not can be done by checking whether `band_moved_one_down & field` is all `0`. Also, moving right or left can be done easily by using the shift operator (`<<` and `>>`).

However, there were some problems to this approach. One was how to check if it's spin-able. Another was how to memorize which (existing) grid is what color. Therefore, I came to the conclusion that reading and writing to the SRAM would be an easier approach.

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
    * Used in [`fpga_tetris.v` line 1-105](https://github.com/NigoroJr/fpga_tetris/blob/master/fpga_tetris.v#L1-105)

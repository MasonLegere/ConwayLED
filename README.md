## :rotating_light: ConwayLED :rotating_light:

Conway's Game of Life is a cellular automaton determined completely by an initial state a few simple rules: 

1. Any live cell with two or three live neighbours survives.
2. Any dead cell with three live neighbours becomes a live cell.
3. All other live cells die in the next generation. Similarly, all other dead cells stay dead.

![Alt Text](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life#/media/File:Gospers_glider_gun.gif)

The goal of this project was to increase understanding of the internals of a computer through progamming 
complex features in ARM assembly. 

## Technologies 
Code was ran on an Atmel SAM4S and written directly in ARM assembly. LED display was done on a 32x32 LED matrix 
requiring manual row/column-wise refreshing. 


MIT © [Mason Legere]()

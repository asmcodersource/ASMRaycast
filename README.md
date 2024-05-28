# Raycasting render in Assembly

This repository contains a simple raycasting game engine written in x86 assembly. The engine renders a 3D view from a 2D map using raycasting techniques, similar to early first-person shooters like Wolfenstein 3D. The game runs in real mode and uses BIOS interrupts for graphics and input handling.

![image](https://github.com/asmcodersource/ASMRaycast/assets/126491635/8ee6fbc5-930f-4585-be31-6472d93933db)


## Features

- **Raycasting Rendering**: The engine performs raycasting to render a 3D view from a 2D map.
- **Basic Graphics**: Low-level graphics routines for drawing pixels, lines, circles, and boxes.
- **Sprite Drawing**: Ability to draw sprites on the screen.
- **User Controls**: Basic keyboard input to move the player and change the viewing angle.

## Code Overview

### Main Sections

- **Initialization and Setup**: Sets up the video mode and initializes necessary variables.
- **Graphics Routines**: Functions to draw various shapes and handle pixel operations.
- **Raycasting Logic**: Core logic for raycasting to calculate visible walls and their distances.
- **Player Controls**: Handles keyboard input to control player movement and view direction.
- **Map Data**: A simple 2D array representing the game map.

### Key Functions

- `put_pix`: Draws a single pixel on the screen.
- `put_box`: Draws a filled rectangle (box) on the screen.
- `put_line`: Draws a line between two points.
- `put_circle`: Draws a circle with a specified radius.
- `draw_sprite`: Draws a sprite at a specified location.
- `ray_throw`: Casts a single ray to detect walls and obstacles.
- `raycast_render`: Main rendering loop for raycasting and drawing the scene.

## Controls

- `W`: Move forward
- `S`: Move backward
- `A`: Turn left
- `D`: Turn right

## Build and Run

### Prerequisites

- An x86 assembler (like NASM or MASM)
- An emulator or virtual machine to run the DOS environment (like DOSBox)

### Build Steps

1. Assemble the code:
    ```sh
    nasm -f bin -o game.bin game.asm
    ```

2. Run the binary in an emulator:
    ```sh
    dosbox game.bin
    ```

## Map Format

The map is defined as a 2D array in the `map` section. Each value represents a different type of tile:
- `0`: Empty space
- `1`: Wall type 1
- `2`: Wall type 2
- `3`: Wall type 3
- `4`: Wall type 4

## Player Structure

The player structure holds the player's position, viewing angle, speed, and other relevant information:
```asm
player_pos:
    .x     dd 3.0
    .y     dd 3.0    
    .angle dd 90
    .speed dd 0.05  
    .center_of_view dd 45.0

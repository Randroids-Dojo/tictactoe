# 3D Tic Tac Toe

A fully Claude Code generated game.
A simplified 3D implementation of the classic Tic Tac Toe game using Godot Engine 4.4.

![Screenshot](<screenshot.png>)

## Features

- Full 3D game board with 3×3×3 grid (27 possible positions)
- Visually appealing materials with glowing spheres
- Interactive gameplay with mouse and trackpad controls
- Orbital camera with auto-rotation
- Win detection for all possible win conditions in 3D space
- Visual feedback and animations

## Game Rules

- Players take turns placing their marker (X or O) on the 3D grid
- The first player to get three of their markers in a straight line wins
- A line can be formed in any direction (horizontal, vertical, diagonal)
- If all 27 positions are filled without a winner, the game is a draw

## Controls

- **Left-click**: Place a marker at the selected position
- **Right-click + drag**: Rotate the camera around the board
- **Mouse wheel**: Zoom in and out
- **Trackpad pinch**: Zoom in/out
- **Alt/Command + trackpad pan**: Rotate the camera
- **Reset Button**: Start a new game

## Architecture

The game follows Godot best practices with a clean, modular structure:

- **GameLogic**: Core game logic class that manages the game state and rules
- **Main**: Main scene controller that handles UI, board creation, and input
- **CameraController**: Camera management with orbital controls

Each component has a single responsibility and communicates through signals for loose coupling.

## Requirements

- Godot Engine 4.4 or later

## Web Export

To export the game for web:

1. Open the project in Godot Engine
2. Go to Project > Export...
3. Select the "Web" preset 
4. Set the Export Path to "export/web/index.html"
5. Click "Export Project"

**Important**: Web exports cannot be run directly by opening the HTML file due to browser security restrictions. You must:

1. **Use the included server script** (easiest):
   ```bash
   # Run the included script
   ./serve_web.sh
   
   # Then visit http://localhost:8080 in your browser
   ```

2. **Use your own local web server**:
   ```bash
   # Install a simple server if needed
   npm install -g http-server
   
   # Navigate to export directory
   cd export/web
   
   # Start server
   http-server
   
   # Then visit http://localhost:8080 in your browser
   ```

3. **Upload to a web hosting service** for sharing your game online
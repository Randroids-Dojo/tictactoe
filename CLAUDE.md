# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Godot Engine Commands
- Run project: `godot project.godot`
- Export project: `godot --export "preset_name" path/to/output`
- Run tests: `godot --script path/to/test_script.gd`
- Check scripts: `godot --check-only --script path/to/script.gd`

## Web Export Notes
When exporting for web platforms:
- Web exports cannot be run directly by opening the HTML file due to browser security restrictions
- Use the included `serve_web.sh` script to run a local web server (`./serve_web.sh`)
- Alternatively, use any HTTP server to serve the files from the export directory
- If you encounter "Failed to fetch" errors, it's likely due to trying to open the HTML file directly
- Always test web exports using a proper web server

## 3D Game Structure
- Main controller script (`main.gd`) is the entry point that orchestrates the game
- Game logic is separated into a dedicated class (`game_logic.gd`)
- Camera controls are handled in a dedicated controller (`camera_controller.gd`)
- UI is organized in the scene hierarchy
- 3D objects are created dynamically at runtime

## Code Style Guidelines
- Use PascalCase for class names and node names
- Use snake_case for variables, functions, signals, and files
- Indent with tabs (Godot standard)
- Order: constants, signals, exports, variables, _ready(), other built-in functions, custom functions
- Document functions with comments above declaration
- For error handling, use if/else with appropriate error messages
- Group related functionality in dedicated scripts
- Follow Godot's node-based architecture patterns
- Use typed variables when possible (var foo: int = 0)
- Prefix private functions with underscore (_private_func)

## Godot 4 Best Practices
- Create loosely coupled systems (communicate via signals)
- Follow single responsibility principle for nodes and scripts
- Use appropriate node types for each task
- Keep scenes focused on a specific purpose
- Use strong typing where possible
- Organize code with clear, descriptive comments
- Create reusable components when functionality is needed in multiple places
- Write self-documenting code with clear naming
- Follow Godot's established patterns and conventions

## Ray Casting in 3D
- Use `get_world_3d().direct_space_state` to get physics space
- Create a `PhysicsRayQueryParameters3D` object for ray configuration
- Set proper collision mask for ray casting
- Implement fallback detection for cases where direct ray casting fails
- Use StaticBody3D with proper collision shapes for clickable objects

## Material Creation
- Use StandardMaterial3D for basic materials
- Set properties like albedo_color, metallic, roughness, emission
- For transparent materials, set transparency mode and alpha
- Consider using rim_enabled and rim properties for edge highlighting
- Use emission_energy_multiplier to control glow intensity
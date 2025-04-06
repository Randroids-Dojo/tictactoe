# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Godot Engine Commands
- Run project: `godot project.godot`
- Export project: `godot --export "preset_name" path/to/output`
- Run tests: `godot --script path/to/test_script.gd`
- Check scripts: `godot --check-only --script path/to/script.gd`

## Code Style Guidelines
- Use PascalCase for class names and node names
- Use snake_case for variables, functions, and signals
- Indent with tabs (Godot standard)
- Order: constants, signals, exports, variables, _ready(), other built-in functions, custom functions
- Document functions with comments above declaration
- For error handling, use if/else with appropriate error messages
- Group related functionality in dedicated scripts
- Follow Godot's node-based architecture patterns
- Use typed variables when possible (var foo: int = 0)
- Prefix private functions with underscore (_private_func)

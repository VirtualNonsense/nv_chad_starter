# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration built on top of NvChad framework. The configuration extends NvChad with custom plugins, keybindings, and language-specific setups.

## Architecture

- **Base Framework**: NvChad v2.5 imported as a plugin
- **Plugin Manager**: lazy.nvim with automatic bootstrapping
- **Structure**: Modular configuration split across `lua/` directory
- **Entry Point**: `init.lua` bootstraps lazy.nvim and loads all modules

### Key Files Structure

```
init.lua               # Main entry point, bootstraps lazy.nvim
lua/
├── plugins/init.lua   # Custom plugin definitions
├── configs/           # Plugin configuration files
│   ├── lspconfig.lua  # LSP server configurations
│   ├── treesitter.lua # Treesitter parser settings
│   ├── dap.lua        # Debug adapter configurations
│   └── conform.lua    # Code formatting settings
├── mappings.lua       # Custom keybindings
├── options.lua        # Vim options and settings
├── lsp_mappings.lua   # LSP-specific keybindings per filetype
└── autocmds.lua       # Autocommands
```

## Language Support

### Configured Languages
- **Rust**: Full setup with rustaceanvim, macro expansion, debugging via codelldb
- **C/C++**: clangd LSP, header/source switching, debugging via codelldb  
- **LaTeX**: texlab LSP with build automation, PDF forward search via zathura
- **Lua**: Enhanced with lazydev for Neovim API completions
- **Python**: Basic LSP support configured

### LSP Configuration Pattern
Language servers are configured in `lua/configs/lspconfig.lua` with filetype-specific keybindings defined in `lua/lsp_mappings.lua`. The `lsp_mappings.on_attach` function provides different keybindings per language.

## Debug Configuration

Debug adapters are set up in `lua/configs/dap.lua`:
- **codelldb**: For Rust/C/C++ debugging
- **DAP UI**: Automatically opens/closes debug interface
- **Mason integration**: Auto-installs debuggers

## Plugin Management

Custom plugins are defined in `lua/plugins/init.lua`. The configuration uses lazy.nvim's declarative plugin specification with dependency management and lazy loading.

### Key Plugins
- `claude-code.nvim`: Integration for Claude Code
- `rustaceanvim`: Advanced Rust tooling 
- `auto-session`: Session management
- `nvim-dap`: Debug adapter protocol support
- `conform.nvim`: Code formatting

## Keybinding Patterns

- **Leader key**: Space
- **Quick save**: `<C-s>` in normal/insert mode
- **Debug controls**: F5 (continue), F10 (step over), F11 (step into), F12 (step out)
- **Language-specific**: Defined per filetype in `lsp_mappings.lua`
  - LaTeX: `<leader>lb` (build), `<leader>lf` (forward search)
  - C/C++: `<leader>hh` (switch header/source)
  - Rust: `<leader>me` (expand macro), `<F5>` (runnables)

## Common Development Tasks

### Adding New Language Support
1. Add language server to `servers` table in `lua/configs/lspconfig.lua`
2. Add treesitter parser to `ensure_installed` in `lua/configs/treesitter.lua`
3. Add filetype-specific keybindings in `lua/lsp_mappings.lua`
4. Configure debug adapter in `lua/configs/dap.lua` if needed

### Plugin Configuration
- Add plugin spec to `lua/plugins/init.lua`
- Create config file in `lua/configs/` if complex setup needed
- Use lazy loading with `ft`, `event`, or `keys` options when appropriate
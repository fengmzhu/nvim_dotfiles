# nvim_dotfiles

Personal Neovim and related config dotfiles, with setup automation for `~/.config` symlinks. Includes backup and easy restore script.

## Features
- Modern Neovim configuration (Lua-based)
- Easy setup script to symlink configs into `~/.config`
- Automatic backup of existing configs before linking
- Extendable: add more app configs under `config/`

## Structure
```
nvim_dotfiles/
├── nvim/         # Neovim config (init.lua, etc.)
├── config/       # Other app configs (add subfolders here)
├── setup         # Setup script for symlinking and backup
└── README.md     # This file
```

## Setup
1. Clone this repo:
   ```sh
   git clone https://github.com/fengmzhu/nvim_dotfiles.git ~/nvim_dotfiles
   cd ~/nvim_dotfiles
   ```
2. Run the setup script:
   ```sh
   chmod +x setup
   ./setup
   ```
   - This will backup your existing `~/.config/nvim` and symlink the new config.
   - It will also symlink any subfolders in `config/` to `~/.config/` (except `nvim`).

## Adding More Configs
- Place any app config (e.g., `alacritty`, `starship`) in `config/<appname>`.
- Re-run `./setup` to symlink them into `~/.config/`.

## License
MIT 
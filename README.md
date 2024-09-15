# 🐠 Ubuntu Fish Pro Setup

![Ubuntu Fish Pro Banner](https://via.placeholder.com/800x200?text=Ubuntu+Fish+Pro+Setup)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)
[![Fish Shell](https://img.shields.io/badge/Fish%20Shell-3.x-blue)](https://fishshell.com/)

> Transform your Ubuntu terminal into a powerhouse of productivity and style!

Ubuntu Fish Pro Setup is a sophisticated script that automates the installation and configuration of Fish shell on Ubuntu systems, providing an advanced, feature-rich, and visually appealing command-line experience.

## ✨ Features

- 🚀 Automatic installation of essential and advanced dependencies
- 🎨 Custom Fish shell configuration with powerful aliases and functions
- 🔍 Fuzzy finding capabilities with fzf integration
- 📊 System information display using neofetch (optional)
- 🔄 Automatic update checks for the setup script
- ⚙️ Sets Fish as the default shell
- 🌟 Starship prompt installation for a minimalist and informative prompt (optional)
- 🧰 VS Code integration with Fish-friendly extensions (optional)

## 🛠️ Prerequisites

- Ubuntu-based system (tested on Ubuntu 20.04 LTS and above)
- Sudo privileges
- Internet connection

## 🚀 Quick Start


1. **Download the script:**
   ```bash
   wget https://raw.githubusercontent.com/likhown/ubuntu-fish/main/setup_fish.sh
   ```

2. **Make the script executable:**
   ```bash
   chmod +x setup_fish.sh
   ```

3. **Run the script:**
   ```bash
   ./setup_fish.sh
   ```

4. **Follow the on-screen prompts** to customize your setup.

5. **Restart your terminal** or log out and log back in to apply all changes.

## 🎛️ What's Included

The Ubuntu Fish Pro Setup enhances your terminal with:

- **Fish Shell**: A smart and user-friendly command line shell.
- **Advanced Aliases**: Shortcuts for common commands and git operations.
- **Custom Functions**: Utilities like `mkcd` and `extract` for improved workflow.
- **Modern CLI Tools**:
  - `exa`: A modern replacement for `ls`.
  - `bat`: A `cat` clone with syntax highlighting.
  - `fzf`: A command-line fuzzy finder.
  - `htop`: An interactive process viewer.
  - `tldr`: Simplified and community-driven man pages.
- **Starship Prompt** (Optional): A minimal, blazing-fast, and infinitely customizable prompt.
- **VS Code Integration** (Optional): Sets up VS Code with Fish-friendly extensions.

## 🎨 Customization

You can further customize your Fish shell by editing the config file:

```bash
nano ~/.config/fish/config.fish
```

For Starship prompt customization, edit:

```bash
nano ~/.config/starship.toml
```

## 🔄 Updating

The script checks for updates automatically. If an update is available, you'll be notified and provided with a link to download the latest version.

## 🐛 Troubleshooting

If you encounter any issues:

1. Ensure you have an active internet connection.
2. Verify that you have sudo privileges.
3. Check system logs for any error messages.

For persistent problems, please [open an issue](https://github.com/likhown/ubuntu-fish/issues) on the GitHub repository.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

Created with ❤️ by [@likhown](https://github.com/likhown)

For more information and updates, visit [https://t.me/likhondotxyz](https://t.me/likhondotxyz)

---

<p align="center">
  Made with 🐠 by the Likhon Sheikh
</p>

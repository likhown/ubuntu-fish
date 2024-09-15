#!/bin/bash

# Define colors
Color_Off='\033[0m'
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
Cyan='\033[0;36m'

# Define paths and variables
config="$HOME/.config/fish/config.fish"
update_check_url="https://raw.githubusercontent.com/likhown/ubuntu-fish/main/version.txt"
author_handle="@likhown"
current_version="1.4"

# Function to display spinner
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Function to log messages
log_message() {
    echo -e "${2:-$Green}$(date '+%Y-%m-%d %H:%M:%S') - $1${Color_Off}"
}

# Function to check and install dependencies
prerequisite() {
    log_message "Installing Dependencies..." "$Cyan"
    local deps=(fish figlet neofetch curl fzf bat htop tldr zsh git ripgrep fd-find jq tmux ranger vim)
    local to_install=()

    for dep in "${deps[@]}"; do
        if ! command -v $dep &> /dev/null; then
            to_install+=($dep)
        fi
    done

    if [ ${#to_install[@]} -eq 0 ]; then
        log_message "All dependencies are already installed!"
    else
        log_message "Installing: ${to_install[*]}" "$Yellow"
        sudo apt update -y
        for dep in "${to_install[@]}"; do
            log_message "Installing $dep..."
            sudo apt install -y $dep
            if [ $? -ne 0 ]; then
                log_message "Failed to install $dep. Exiting." "$Red"
                exit 1
            fi
        done
        log_message "Dependencies successfully installed!"
    fi
}

# Function to check for updates
check_for_updates() {
    log_message "Checking for updates..." "$Cyan"
    local latest_version=$(curl -sL "$update_check_url")
    if [ "$latest_version" = "$current_version" ]; then
        log_message "You are using the latest version ($current_version) of the setup script."
    else
        log_message "An update is available: $latest_version (current: $current_version)" "$Yellow"
        log_message "Visit https://github.com/likhown/ubuntu-fish to download the latest version." "$Blue"
    fi
}

# Function to clear system messages and remove default Ubuntu welcome
clear_system_messages() {
    log_message "Clearing system messages and removing default Ubuntu welcome..." "$Cyan"
    sudo sh -c 'echo "" > /etc/motd'
    sudo sh -c 'echo "" > /etc/issue'
    sudo sh -c 'echo "" > /etc/issue.net'
    sudo sed -i '/^session    optional     pam_motd.so/d' /etc/pam.d/sshd
    sudo sed -i '/^session    optional     pam_motd.so/d' /etc/pam.d/login
    log_message "System messages and default Ubuntu welcome removed."
}

# Function to remove old Fish configuration
remove_old_fish_config() {
    log_message "Removing old Fish configuration..." "$Cyan"
    rm -f "$config"
    log_message "Old Fish configuration removed."
}

# Function to setup Fish configuration
setup_fish_config() {
    log_message "Setting up Fish configuration..." "$Cyan"
    mkdir -p "$HOME/.config/fish"
    cat << EOF > "$config"
function fish_greeting
    echo -e "${Yellow}Welcome to your advanced Ubuntu Fish environment!${Color_Off}"
    echo -e "${Cyan}Current Date: $(date)${Color_Off}"
    echo -e "${Green}Uptime: $(uptime -p)${Color_Off}"
    echo
    neofetch
end

# Advanced aliases
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias search='apt search'
alias ..='cd ..'
alias ...='cd ../..'
alias l='exa -lah --git'
alias tree='exa --tree'
alias cat='bat'
alias top='htop'
alias df='df -h'
alias du='du -h'
alias free='free -m'
alias fishconfig='vim ~/.config/fish/config.fish'
alias weather='curl wttr.in'
alias cheat='tldr'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Custom functions
function mkcd
    mkdir -p \$argv[1] && cd \$argv[1]
end

function extract
    if test -f \$argv[1]
        switch \$argv[1]
            case '*.tar.bz2'
                tar xjf \$argv[1]
            case '*.tar.gz'
                tar xzf \$argv[1]
            case '*.bz2'
                bunzip2 \$argv[1]
            case '*.rar'
                unrar x \$argv[1]
            case '*.gz'
                gunzip \$argv[1]
            case '*.tar'
                tar xf \$argv[1]
            case '*.tbz2'
                tar xjf \$argv[1]
            case '*.tgz'
                tar xzf \$argv[1]
            case '*.zip'
                unzip \$argv[1]
            case '*.Z'
                uncompress \$argv[1]
            case '*.7z'
                7z x \$argv[1]
            case '*'
                echo "'\$argv[1]' cannot be extracted via extract()"
        end
    else
        echo "'\$argv[1]' is not a valid file"
    end
end

# Advanced fuzzy finder functions
function fzf_find_file
    begin
        fd --type f --hidden --follow --exclude .git | fzf --preview 'bat --style=numbers --color=always {}'
    end | read -l result; and commandline -i (echo \$result | string escape)
    commandline -f repaint
end

function fzf_find_history
    history | fzf --no-sort --exact | read -l command
    if test \$command
        commandline -r \$command
    end
    commandline -f repaint
end

function fzf_find_directory
    begin
        fd --type d --hidden --follow --exclude .git | fzf --preview 'tree -C {} | head -100'
    end | read -l result; and cd \$result
    commandline -f repaint
end

# Key bindings
function fish_user_key_bindings
    bind \cf fzf_find_file
    bind \cr fzf_find_history
    bind \cd fzf_find_directory
end

# Set environment variables
set -gx PATH \$HOME/.local/bin \$PATH
set -gx EDITOR vim

# Set color scheme
set -U fish_color_normal normal
set -U fish_color_command 00FF00
set -U fish_color_quote 44FF44
set -U fish_color_redirection 00AFFF
set -U fish_color_end 009900
set -U fish_color_error FF0000
set -U fish_color_param 30BE30
set -U fish_color_comment 666A6E
set -U fish_color_match 008800
set -U fish_color_selection white --bold --background=brblack
set -U fish_color_search_match bryellow --background=brblack
set -U fish_color_history_current --bold
set -U fish_color_operator 00a6b2
set -U fish_color_escape 00a6b2
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_valid_path --underline
set -U fish_color_autosuggestion 555 brblack
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_cancel -r
set -U fish_pager_color_prefix white --bold --underline
set -U fish_pager_color_completion normal
set -U fish_pager_color_description B3A06D yellow
set -U fish_pager_color_progress brwhite --background=cyan

# Load Starship prompt if installed
if command -v starship > /dev/null
    starship init fish | source
end

# Advanced features
set -g fish_key_bindings fish_vi_key_bindings
set -g fish_cursor_default block
set -g fish_cursor_insert line
set -g fish_cursor_replace_one underscore
set -g fish_cursor_visual block
EOF
    log_message "Advanced Fish configuration set up successfully."
}

# Function to install and configure Starship prompt
install_starship() {
    log_message "Installing Starship prompt..." "$Cyan"
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y
    if [ $? -ne 0 ]; then
        log_message "Failed to install Starship. Exiting." "$Red"
        exit 1
    fi
    mkdir -p ~/.config && touch ~/.config/starship.toml
    cat << EOF > ~/.config/starship.toml
[character]
success_symbol = "[➜](bold green) "
error_symbol = "[✗](bold red) "

[cmd_duration]
min_time = 500
format = "took [$duration](bold yellow)"

[directory]
truncation_length = 3
format = "[$path]($style)[$read_only]($read_only_style) "

[git_branch]
format = "on [$symbol$branch]($style) "
symbol = "🌱 "
style = "bold purple"

[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'
style = "bold red"

[nodejs]
format = "via [🤖 $version](bold green) "

[package]
format = "via [🎁 $version](208 bold) "

[python]
format = "via [🐍 $version](bold blue) "

[rust]
format = "via [⚙️ $version](bold red) "

[time]
disabled = false
format = '[\[ $time \]]($style) '
time_format = "%T"
style = "bright-black"
EOF
    log_message "Starship prompt installed and configured."
}

# Function to set up VS Code with Fish integration
setup_vscode() {
    log_message "Setting up VS Code with Fish integration..." "$Cyan"
    if command -v code &> /dev/null; then
        code --install-extension ms-vscode.cpptools
        code --install-extension ms-python.python
        code --install-extension dbaeumer.vscode-eslint
        code --install-extension esbenp.prettier-vscode
        code --install-extension eamodio.gitlens
        code --install-extension bmalehorn.vscode-fish
        code --install-extension vscodevim.vim
        code --install-extension ms-azuretools.vscode-docker
        code --install-extension ms-vscode-remote.remote-containers
        log_message "VS Code extensions installed."
    else
        log_message "VS Code not found. Skipping VS Code setup." "$Yellow"
    fi
}

# Function to install Zsh and Oh My Zsh
install_zsh() {
    log_message "Installing Zsh and Oh My Zsh..." "$Cyan"
    sudo apt install -y zsh
    if [ $? -ne 0 ]; then
        log_message "Failed to install Zsh. Exiting." "$Red"
        exit 1
    fi
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_message "Zsh and Oh My Zsh installed successfully."
}

# Function to install Node.js (JavaScript)
install_nodejs() {
    log_message "Installing Node.js (JavaScript)..." "$Cyan"
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
    if [ $? -ne 0 ]; then
        log_message "Failed to install Node.js. Exiting." "$Red"
        exit 1
    fi
    log_message "Node.js installed successfully."
}

# Function to install GitHub CLI
install_github_cli() {
    log_message "Installing GitHub CLI..." "$Cyan"
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh -y
    if [ $? -ne 0 ]; then
        log_message "Failed to install GitHub CLI. Exiting." "$Red"
        exit 1
    fi
    log_message "GitHub CLI installed successfully."
}

# Function to set Fish as default shell
set_fish_as_default() {
    log_message "Setting Fish as the default shell..." "$Cyan"
    sudo chsh -s $(which fish) $USER
    if [ $? -ne 0 ]; then
        log_message "Failed to set Fish as default shell. Exiting." "$Red"
        exit 1
    fi
    log_message "Fish set as the default shell."
}

# Main script execution
clear
echo -e $Red
figlet -f slant "Ubuntu Fish Pro"
echo -e $Color_Off
log_message "Welcome to the Advanced Automated Ubuntu Fish Pro Setup Script" "$Green"
log_message "Starting setup process..." "$Cyan"

# Run functions
prerequisite
check_for_updates
clear_system_messages
remove_old_fish_config
setup_fish_config
install_starship
setup_vscode
install_zsh
install_nodejs
install_github_cli
set_fish_as_default

log_message "Setup completed successfully!" "$Green"
log_message "For support, join our Telegram group: $author_handle" "$Yellow"
log_message "The system will now switch to Fish shell. Please log out and log back in for all changes to take effect." "$Cyan"

# Switch to Fish shell
exec fish


#!/bin/bash

# Define colors
Color_Off='\033[0m'
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
Cyan='\033[0;36m'

# Define paths
config="$HOME/.config/fish/config.fish"
update_check_url="https://github.com/likhown/ubuntu-fish/blob/main/setup_fish.sh"
author_url="https://t.me/likhondotxyz"
author_handle="@likhown"

# Function to display spinner
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Function to check and install dependencies
prerequisite() {
    echo -e "${Green}Installing Dependencies...${Cyan}"
    echo
    local deps=(fish figlet neofetch curl fzf exa bat htop tldr)
    local to_install=()

    for dep in "${deps[@]}"; do
        if ! command -v $dep &> /dev/null; then
            to_install+=($dep)
        fi
    done

    if [ ${#to_install[@]} -eq 0 ]; then
        echo "${Green}All dependencies are already installed!"
    else
        echo "${Yellow}Installing: ${to_install[*]}"
        sudo apt update -y
        sudo apt install -y "${to_install[@]}" &
        spinner $!
        if [ $? -eq 0 ]; then
            echo
            echo "${Green}Dependencies successfully installed!"
        else
            echo
            echo "${Red}Error occurred, failed to install dependencies."
            echo -e $Color_Off
            exit 1
        fi
    fi
}

# Function to check for updates
check_for_updates() {
    echo -e "${Green}Checking for updates...${Cyan}"
    echo
    local latest_version=$(curl -sL "$update_check_url" | grep -oP '(?<=Version: )[0-9.]+')
    local current_version="1.2"  # Update this when you release a new version
    if [ "$latest_version" = "$current_version" ]; then
        echo -e "${Green}You are using the latest version ($current_version) of the setup script."
    else
        echo -e "${Yellow}An update is available: $latest_version (current: $current_version)"
        echo -e "${Blue}Visit $update_check_url to download the latest version."
    fi
    echo
}

# Function to open URL in default browser
open_in_browser() {
    local url="$1"
    if command -v xdg-open &> /dev/null; then
        xdg-open "$url" &> /dev/null
    elif command -v gnome-open &> /dev/null; then
        gnome-open "$url" &> /dev/null
    elif command -v open &> /dev/null; then
        open "$url" &> /dev/null
    else
        echo -e "${Red}No suitable command found to open the browser.${Color_Off}"
    fi
}

# Function to setup fish configuration
setup_fish_config() {
    echo -e "${Green}Setting up fish configuration...${Cyan}"
    mkdir -p "$HOME/.config/fish"
    cat << EOF > "$config"
function fish_greeting
    echo -e "${Yellow}Welcome to your advanced Ubuntu Fish setup!${Color_Off}"
    echo -e "${Cyan}Current date: $(date)${Color_Off}"
    echo -e "${Green}Uptime: $(uptime -p)${Color_Off}"
    echo -e "${Blue}Fish shell version: $(fish --version | cut -d ' ' -f 3)${Color_Off}"
    echo
end

function __fish_command_not_found_handler --on-event fish_command_not_found
    command-not-found \$argv[1]
end

function cls
    clear
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
alias fishconfig='nano ~/.config/fish/config.fish'
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
                echo "'\\$argv[1]' cannot be extracted via extract()"
        end
    else
        echo "'\\$argv[1]' is not a valid file"
    end
end

# Custom key bindings
function fish_user_key_bindings
    bind \cr 'history-search-backward'
    bind \cf 'fzf_select_file'
end

# Fuzzy file finder function
function fzf_select_file
    set -l file (fzf)
    if test -n "\$file"
        commandline -i "\$file"
    end
    commandline -f repaint
end

# Set environment variables
set -gx PATH \$HOME/.local/bin \$PATH
set -gx EDITOR nano

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
EOF

    if [ "$add_neofetch" = "y" ]; then
        echo "neofetch" >> "$config"
    fi
    echo -e "${Green}Advanced Fish configuration set up successfully.${Color_Off}"
}

# Function to install and configure Starship prompt
install_starship() {
    echo -e "${Green}Installing Starship prompt...${Cyan}"
    curl -fsSL https://starship.rs/install.sh | sh
    echo 'starship init fish | source' >> "$config"
    mkdir -p ~/.config && touch ~/.config/starship.toml
    echo 'format = "$all"' > ~/.config/starship.toml
    echo -e "${Green}Starship prompt installed and configured.${Color_Off}"
}

# Function to set up VS Code with Fish integration
setup_vscode() {
    echo -e "${Green}Setting up VS Code with Fish integration...${Cyan}"
    if command -v code &> /dev/null; then
        code --install-extension ms-vscode.cpptools
        code --install-extension ms-python.python
        code --install-extension dbaeumer.vscode-eslint
        code --install-extension esbenp.prettier-vscode
        code --install-extension eamodio.gitlens
        code --install-extension bmalehorn.vscode-fish
        echo -e "${Green}VS Code extensions installed.${Color_Off}"
    else
        echo -e "${Yellow}VS Code not found. Skipping VS Code setup.${Color_Off}"
    fi
}

# Main script execution
clear
echo -e $Red
figlet -f slant "Ubuntu Fish Pro"
echo -e $Color_Off
echo

prerequisite
check_for_updates

# Ask user if they want to add neofetch
echo -e "${Green}[*] Adding neofetch to homepage...${Red}"
read -p "Do you want the Ubuntu logo on the homepage? (y/n): " add_neofetch

setup_fish_config

# Ask user if they want to install Starship prompt
echo -e "${Green}[*] Starship prompt installation...${Red}"
read -p "Do you want to install the Starship prompt? (y/n): " install_starship_prompt
if [ "$install_starship_prompt" = "y" ]; then
    install_starship
fi

# Ask user if they want to set up VS Code
echo -e "${Green}[*] VS Code setup...${Red}"
read -p "Do you want to set up VS Code with Fish integration? (y/n): " setup_vscode_integration
if [ "$setup_vscode_integration" = "y" ]; then
    setup_vscode
fi

# Set fish as the default shell
echo -e "${Green}[*] Setting fish as the default shell...${Cyan}"
chsh -s /usr/bin/fish

# Final message and open URL in browser
echo -e "${Green}Advanced Ubuntu Fish setup complete!\n\nPlease restart your terminal to apply all changes.\n"
echo -e "For more information, visit ${Blue}${author_url}${Green} and follow ${Blue}${author_handle}${Green}."
read -p "Press Enter to open the author's page in your browser..."
open_in_browser "$author_url"

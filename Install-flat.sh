#!/bin/bash

# Check if flatpak is installed
if command -v flatpak &> /dev/null
then
    echo "Flatpak is installed."
else
    echo "Flatpak is not installed. Detecting distribution..."
    
    # Function to detect distribution
    detect_distro() {
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            case "$ID" in
                arch) 
                    echo "Arch"
                    ;;
                fedora) 
                    echo "Fedora"
                    ;;
                rhel) 
                    echo "RHEL"
                    ;;
                centos) 
                    echo "CentOS"
                    ;;
                ubuntu) 
                    echo "Ubuntu"
                    ;;
                debian) 
                    echo "Debian"
                    ;;
                opensuse) 
                    echo "OpenSuse"
                    ;; 
                *) 
                    echo "Unknown distribution"
                    ;;
            esac
        else
            echo "Cannot determine distribution. /etc/os-release file not found."
            echo "Please visit https://flathub.org/setup for manual Flatpak installation instructions."
            exit 1
        fi
    }

    # Function to detect desktop environment
    detect_desktop() {
        if [ "$XDG_CURRENT_DESKTOP" ]; then
            echo "Desktop Environment: $XDG_CURRENT_DESKTOP"
        elif [ "$DESKTOP_SESSION" ]; then
            echo "Desktop Session: $DESKTOP_SESSION"
        else
            echo "Cannot determine desktop environment."
        fi
    }

    # Call the functions
    distro=$(detect_distro)
    echo "Detected Distribution: $distro"
    detect_desktop

    # Install Flatpak based on distribution and desktop environment
    case "$distro" in
        "Ubuntu" | "Debian")
            echo "Installing Flatpak on $distro..."
            sudo apt update
            sudo apt install -y flatpak
            sudo add-apt-repository -y ppa:flatpak/stable
            sudo apt update
            sudo apt install -y flatpak
            sudo apt install -y gnome-software-plugin-flatpak
            if [[ "$XDG_CURRENT_DESKTOP" == *"KDE"* ]]; then
                sudo apt install -y plasma-discover-backend-flatpak
            fi
            echo "Flatpak installed. Please reboot your system."
            ;;
        "Fedora")
            echo "Installing Flatpak on Fedora..."
            sudo dnf install -y flatpak
            ;;
        "Arch")
            echo "Installing Flatpak on Arch..."
            sudo pacman -S --noconfirm flatpak
            ;;
        "RHEL" | "CentOS")
            echo "Installing Flatpak on $distro..."
            sudo yum install -y flatpak
            flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            ;;
        "OpenSuse")
            echo "Installing Flatpak on OpenSuse..."
            sudo zypper install -y flatpak
            ;;
        *)
            echo "Unknown distribution. Please visit https://flathub.org/setup for manual Flatpak installation instructions."
            ;;
    esac
fi


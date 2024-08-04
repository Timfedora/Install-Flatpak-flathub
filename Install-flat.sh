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

    # Provide installation instructions based on distribution and desktop environment
    case "$distro" in
        "Ubuntu" | "Debian")
            echo "To install Flatpak on $distro, run the following commands:"
            echo "sudo apt update"
            echo "sudo apt install flatpak"
            echo "sudo add-apt-repository ppa:flatpak/stable"
            echo "sudo apt update"
            echo "sudo apt install flatpak"
            echo "sudo apt install gnome-software-plugin-flatpak"
            if [[ "$XDG_CURRENT_DESKTOP" == *"KDE"* ]]; then
                echo "sudo apt install plasma-discover-backend-flatpak"
            fi
            echo "After installing, reboot your system."
            ;;
        "Fedora")
            echo "To install Flatpak on Fedora, run the following commands:"
            echo "sudo dnf install flatpak"
            ;;
        "Arch")
            echo "To install Flatpak on Arch, run the following commands:"
            echo "sudo pacman -S flatpak"
            ;;
        "RHEL" | "CentOS")
            echo "To install Flatpak on $distro, run the following commands:"
            echo "sudo yum install flatpak"
            echo "flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo"
            ;;
        "OpenSuse")
            echo "To install Flatpak on OpenSuse, run the following commands:"
            echo "sudo zypper install flatpak"
            ;;
        *)
            echo "Unknown distribution. Please visit https://flathub.org/setup for manual Flatpak installation instructions."
            ;;
    esac
fi

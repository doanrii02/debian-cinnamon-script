#!/bin/bash

# Function to check if package is installed
is_installed() {
    dpkg -l | grep -qw "$1"
}

echo "Starting Debian Cinnamon debloat and setup script..."

# Remove "deb cdrom" entry from sources.list
echo "Removing CD-ROM repository from APT sources..."
sudo sed -i '/^deb cdrom:/d' /etc/apt/sources.list

# Add contrib, non-free, and non-free-firmware to sources.list if not present
if ! grep -q "contrib non-free non-free-firmware" /etc/apt/sources.list; then
    echo "Adding contrib, non-free, and non-free-firmware components to APT sources..."
    sudo sed -i 's/main/main contrib non-free non-free-firmware/' /etc/apt/sources.list
fi

# Update and upgrade system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Remove unwanted apps
APPS_TO_REMOVE=(
    libreoffice*
    transmission*
    thunderbird
    rhythmbox
    gnome-games
    hexchat
    simple-scan
    xplayer
    drawing
    pix
    celluloid
    pidgin
)

for app in "${APPS_TO_REMOVE[@]}"; do
    if is_installed "$app"; then
        echo "Removing $app..."
        sudo apt remove --purge -y "$app"
    else
        echo "$app is not installed, skipping..."
    fi
done

# Clean up system
echo "Cleaning up unnecessary packages..."
sudo apt autoremove -y
sudo apt autoclean
sudo apt clean

# Install essential apps
echo "Installing essential applications..."
sudo apt install -y flatpak gimp kdenlive obs-studio

# Enable Flatpak for Discord
echo "Setting up Flatpak..."
sudo apt install -y gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Discord via Flatpak
echo "Installing Discord..."
flatpak install -y flathub com.discordapp.Discord

# Install Steam via APT (better access to mounted drives)
echo "Enabling Steam repository and installing Steam..."
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y steam

# Install CoolerControl from Cloudsmith Repo
echo "Installing CoolerControl..."
sudo apt install -y curl apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/coolercontrol/coolercontrol/setup.deb.sh' | sudo -E bash
sudo apt update
sudo apt install -y coolercontrol
sudo systemctl enable --now coolercontrold

# Install VS Code from Microsoft Repo
echo "Installing Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
sudo apt update
sudo apt install -y code

# Install NVIDIA Drivers for GTX 970
echo "Installing NVIDIA proprietary drivers..."
sudo apt install -y linux-headers-$(uname -r) build-essential dkms
sudo apt install -y nvidia-driver firmware-misc-nonfree

# Secure Boot MOK Enrollment Notice
if [ -d /sys/firmware/efi ]; then
    echo "Secure Boot detected! You need to enroll the Machine Owner Key (MOK) after reboot."
    echo "Follow the on-screen instructions when prompted after reboot."
fi

# Configure dracut if system uses it
if command -v dracut &> /dev/null; then
    echo "Configuring dracut for NVIDIA..."
    echo 'install_items+=" /etc/modprobe.d/nvidia-blacklists-nouveau.conf /etc/modprobe.d/nvidia.conf /etc/modprobe.d/nvidia-options.conf "' | sudo tee /etc/dracut.conf.d/10-nvidia.conf
fi

# Check if NVIDIA installation was successful
if is_installed "nvidia-driver"; then
    echo "NVIDIA driver installed successfully!"
else
    echo "NVIDIA driver installation failed!"
fi

# Check for NVIDIA driver updates
echo "Checking for NVIDIA driver updates..."
sudo apt update
NVIDIA_UPGRADE=$(apt list --upgradable 2>/dev/null | grep nvidia-driver)

if [ -n "$NVIDIA_UPGRADE" ]; then
    echo "A newer NVIDIA driver is available:"
    echo "$NVIDIA_UPGRADE"
    echo "Upgrading NVIDIA driver..."
    sudo apt upgrade -y nvidia-driver
    echo "NVIDIA driver updated successfully! A reboot is required."
else
    echo "You are already on the latest NVIDIA driver."
fi

echo "Debloat and setup complete!"


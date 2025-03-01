# Debian Cinnamon Setup & Debloat Script

This script automates the setup of **Debian 12 (Bookworm) Cinnamon** by:  
- Removing **bloatware**  
- Fixing **APT sources** (removes `deb cdrom` and adds `contrib non-free non-free-firmware`)  
- Installing **essential apps**: Steam (APT), Discord (Flatpak), OBS, GIMP, Kdenlive  
- Installing **NVIDIA drivers (v535.183.01) for GTX 970 and newer**  

## 🚀 Installation

### 1️⃣ Download & Make Executable
```bash
git clone https://github.com/doanrii02/debian-cinnamon-script.git
cd debian-cinnamon-script
chmod +x install-nvidia.sh
```

### 2️⃣ Run the Script
```bash
sudo ./install-nvidia.sh
```

### 3️⃣ Reboot System
```bash
sudo reboot
```

## 🎮 Installed Applications
| Package       | Install Method |
|--------------|---------------|
| **Steam**   | APT (No Flatpak) |
| **Discord** | Flatpak (Flathub) |
| **OBS Studio** | APT |
| **GIMP** | APT |
| **Kdenlive** | APT |

## ❄️ NVIDIA Driver Installation
- Installs **NVIDIA driver v535.183.01**  
- **Secure Boot detected?** Enroll MOK after reboot  

## 🔥 Bloatware Removed
- LibreOffice  
- Transmission  
- Thunderbird  
- Rhythmbox  
- Gnome Games  
- HexChat  
- Simple Scan  
- XPlayer  
- Drawing  
- Pix  
- Celluloid  

## 🛠️ Customization
Edit `install-nvidia.sh` using:
```bash
nano install-nvidia.sh
```

## ⚠️ Troubleshooting
- **Secure Boot Issues?** Disable Secure Boot in BIOS or enroll MOK after reboot.  
- **NVIDIA Driver Not Working?** Try reinstalling:
  ```bash
  sudo apt reinstall nvidia-driver firmware-misc-nonfree
  ```
- **Steam Issues?** Ensure `dpkg --add-architecture i386` is enabled.  

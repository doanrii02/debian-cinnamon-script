# Debian Cinnamon Setup & Debloat Script

This script automates the setup of a **Debian 12 (Bookworm) Cinnamon** system by:
- Removing **bloatware** (pre-installed apps you don't need)
- **Fixing APT sources** (removes `deb cdrom` and ensures `contrib non-free non-free-firmware` is added)
- Installing **essential apps**: Steam (APT), Discord (Flatpak), OBS, GIMP, Kdenlive
- Installing **NVIDIA drivers (v535.183.01) for GTX 970 and newer**
- Enabling **Wayland support** for NVIDIA
- Handling **Secure Boot (MOK Enrollment)** if needed

---

## 🚀 Installation

### 1️⃣ **Download & Make the Script Executable**
```bash
git clone https://github.com/doanrii02/debian-cinnamon-script.git
cd debian-cinnamon-script
chmod +x install-nvidia.sh
```

### 2️⃣ **Run the Script with Sudo**
```bash
sudo ./install-nvidia.sh
```

### 3️⃣ **Reboot Your System**
```bash
sudo reboot
```

---

## 🎮 **What's Installed?**
| Package       | Install Method | Purpose |
|--------------|---------------|---------|
| **Steam**   | APT (No Flatpak) | Native game support, access to mounted drives |
| **Discord** | Flatpak (Flathub) | Voice chat & gaming community |
| **OBS Studio** | APT | Live streaming & recording |
| **GIMP** | APT | Advanced image editing |
| **Kdenlive** | APT | Video editing |

---

## ❄️ **NVIDIA Driver Setup**
- **Installs NVIDIA driver v535.183.01** for GTX 970 and newer
- Adds **Wayland compatibility** (`modeset=1`)
- **Secure Boot detected?** You’ll need to **enroll MOK** after reboot  
  *(Follow on-screen instructions when prompted)*  

---

## 🔥 **Bloatware Removed**
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

---

## 🛠️ **Customization**
Want to modify the apps installed or removed?  
- **Edit the script** using:
  ```bash
  nano install-nvidia.sh
  ```
- Find the sections with `APPS_TO_REMOVE` and `sudo apt install`  

---

## ⚠️ **Troubleshooting**
- **Secure Boot Issues?** Disable Secure Boot in BIOS or enroll MOK after reboot.
- **NVIDIA Driver Not Working?** Try reinstalling:
  ```bash
  sudo apt reinstall nvidia-driver firmware-misc-nonfree
  ```
- **Wayland Not Enabled?** Check with:
  ```bash
  cat /sys/module/nvidia_drm/parameters/modeset
  ```
  If it returns `N`, run:
  ```bash
  echo "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia-options.conf
  sudo reboot
  ```

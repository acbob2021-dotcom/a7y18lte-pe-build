# Samsung Galaxy A7 (2018) - PixelExperience 11 Cloud Build

This repository contains the complete automated cloud build setup for **PixelExperience 11** and **Custom Recovery** for the Samsung Galaxy A7 (2018) (`a7y18lte` / Exynos 7885).

---

## How to Run the Build on GitHub Actions (1-Click Free Cloud Build)

1. Open your terminal and log in to your GitHub account:
   ```bash
   gh auth login
   ```
2. Navigate to this folder and create a private or public GitHub repo:
   ```bash
   cd /Users/abc/Desktop/Samsung_A7_PixelExperience
   git init
   git add .
   git commit -m "feat: automated PixelExperience build for a7y18lte"
   gh repo create a7y18lte-pe-build --public --source=. --push
   ```
3. Trigger the build:
   ```bash
   gh workflow run build_pe.yml
   ```
4. Watch the build progress:
   ```bash
   gh run watch
   ```
5. When finished, download the build artifacts:
   ```bash
   gh run download
   ```
   You will get:
   - `PixelExperience_a7y18lte-11.0-xxxx-UNOFFICIAL.zip` (Flashable ROM)
   - `recovery.tar` (Flashable via Samsung Odin AP Slot)
   - `recovery.img` (Custom recovery image)

---

## Flashing Instructions for Samsung Galaxy A7 (2018)

1. **Reboot to Download Mode:**
   - Power off the phone.
   - Hold **Volume Down + Volume Up** and insert USB cable connected to PC.
2. **Flash Recovery via Odin:**
   - Put `recovery.tar` in Odin's **AP** slot and click **Start**.
3. **Boot into Recovery:**
   - Immediately press and hold **Volume Up + Power** until recovery appears.
4. **Wipe:**
   - Tap **Factory Reset** -> **Format data / factory reset**.
5. **Install ROM:**
   - Select **Apply update** -> **Apply from ADB**.
   - On PC run: `adb sideload PixelExperience_a7y18lte-11.0-xxxx-UNOFFICIAL.zip`
6. **Reboot:** Enjoy PixelExperience!

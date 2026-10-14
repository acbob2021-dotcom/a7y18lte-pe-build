#!/usr/bin/env bash
set -e

echo "=== Samsung Galaxy A7 (2018) PixelExperience 11 Automated Builder ==="

# Check OS
if [ "$(uname)" != "Linux" ]; then
    echo "ERROR: AOSP builds strictly require a Linux environment (Ubuntu 20.04/22.04 LTS)."
    echo "Please run this script on an Ubuntu VPS/server or use the GitHub Actions workflow."
    exit 1
fi

echo "=== 1. Installing Required Packages ==="
sudo apt-get update
sudo apt-get install -y bc bison build-essential ccache curl flex g++-multilib gcc-multilib \
  git gnupg gperf imagemagick lib32readline-dev lib32z1-dev libelf-dev liblz4-tool \
  libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush \
  rsync schedtool squashfs-tools xsltproc zip zlib1g-dev python-is-python3 tar

# Repo tool
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH

echo "=== 2. Setting up Source Directory ==="
BUILD_DIR="$HOME/android/pe"
mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"

echo "=== 3. Initializing PixelExperience 11 ==="
repo init -u https://github.com/PixelExperience/manifest -b eleven --depth=1

echo "=== 4. Copying Roomservice Manifest & Syncing ==="
mkdir -p .repo/local_manifests
cp "$(dirname "$0")/manifests/a7y18lte.xml" .repo/local_manifests/
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags --prune

echo "=== 5. Applying PixelExperience Patches ==="
cp "$(dirname "$0")/patches/aosp_a7y18lte.mk" device/samsung/a7y18lte/
cp "$(dirname "$0")/patches/AndroidProducts.mk" device/samsung/a7y18lte/

echo "=== 6. Setting Up CCACHE & Building ==="
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
ccache -M 30G

source build/envsetup.sh
lunch aosp_a7y18lte-userdebug

echo "=== 7. Compiling Custom Recovery ==="
make recoveryimage -j$(nproc --all)
cd out/target/product/a7y18lte/
tar -cvf recovery.tar recovery.img
cd "$BUILD_DIR"

echo "=== 8. Compiling Flashable ROM Zip ==="
mka bacon -j$(nproc --all)

echo "=========================================================="
echo "BUILD COMPLETE!"
echo "Flashable ROM Zip: $(ls out/target/product/a7y18lte/PixelExperience_*.zip)"
echo "Odin Recovery (.tar): out/target/product/a7y18lte/recovery.tar"
echo "Recovery (.img): out/target/product/a7y18lte/recovery.img"
echo "=========================================================="

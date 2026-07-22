# 05 · Build a Custom NetHunter Kernel (optional)

> **Assumes:** you want Wi‑Fi **monitor mode + packet injection**, BadUSB/HID, and the
> other kernel‑level NetHunter features. This is the hardest part. Take your time.

We build from **[`kimocoder/nethunter_kernel_oneplus7`](https://github.com/kimocoder/nethunter_kernel_oneplus7)**,
which is an SM8150 kernel tree pre‑loaded with NetHunter patches (RTL88xx drivers,
mac80211 injection, HID gadget, etc.).

- **SoC:** SM8150 (Snapdragon 855+) → defconfig base `sm8150-perf_defconfig`
- **Branch used:** `nethunter-12.1`
- **Output:** `Image.gz-dtb` (+ dtbo) packaged with AnyKernel3 into a flashable zip

> ⚠️ Flashing a bad kernel = bootloop. Always keep your **stock LineageOS `boot.img`**
> handy so you can `fastboot flash boot boot.img` to recover.

## 1. Build host & toolchain

On a Linux box (Ubuntu/Debian shown):

```bash
sudo apt update
sudo apt install -y git bc bison flex libssl-dev make libncurses-dev \
  gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi build-essential zip
```

For newer trees you may also want Clang (AOSP prebuilt). GCC (`aarch64-linux-gnu-gcc`)
is enough for the `nethunter-12.1` branch.

## 2. Clone the kernel source

```bash
mkdir -p ~/android/kernel && cd ~/android/kernel
git clone --depth=1 -b nethunter-12.1 \
  https://github.com/kimocoder/nethunter_kernel_oneplus7.git
cd nethunter_kernel_oneplus7
```

## 3. Set up the build environment

```bash
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-
# If using Clang, also set CC=clang and CLANG_TRIPLE=aarch64-linux-gnu-
```

## 4. Configure

```bash
make O=out sm8150-perf_defconfig
```

### ⚠️ The gotcha that bites everyone (duplicate defconfig symbols)

If you (or a script) appended NetHunter fragments onto the defconfig and the build
dies early with **`exit code 2`** and warnings about **duplicate / redefined config
symbols**, the fix is:

1. **Don't blindly cat fragments onto the defconfig.** Merge properly with the kernel's
   own merge script:
   ```bash
   ./scripts/kconfig/merge_config.sh -m -O out \
     out/.config arch/arm64/configs/nethunter.config
   make O=out olddefconfig
   ```
2. Or, if you must hand‑edit, **de‑duplicate first** — each `CONFIG_*` may appear only
   once. Remove earlier definitions before appending the NetHunter additions:
   ```bash
   awk -F= '{print $1}' fragment.config | while read k; do sed -i "/^$k=/d;/^# $k /d" out/.config; done
   cat fragment.config >> out/.config
   make O=out olddefconfig
   ```

Make sure these NetHunter options end up **set** in `out/.config`:
- `CONFIG_CFG80211` / `CONFIG_MAC80211` with injection support
- `CONFIG_RTL8812AU` (and friends: 88XXAU/8814AU) for external USB Wi‑Fi adapters
- `CONFIG_USB_CONFIGFS_F_HID` / HID gadget (BadUSB)
- `CONFIG_USB_CONFIGFS_F_MASS_STORAGE`, `..._F_ACM`, etc.

## 5. Build

```bash
make O=out -j"$(nproc)" 2>&1 | tee build.log
```

Successful output lands at:
```
out/arch/arm64/boot/Image.gz-dtb
out/arch/arm64/boot/dtbo.img        # if the tree builds one
```

## 6. Package with AnyKernel3

```bash
cd ~/android/kernel
git clone https://github.com/osm0sis/AnyKernel3.git
cp nethunter_kernel_oneplus7/out/arch/arm64/boot/Image.gz-dtb AnyKernel3/
# copy dtbo.img too if present
```
Edit `AnyKernel3/anykernel.sh` and set the device block name for `hotdog`
(e.g. `device.name1=hotdog`, `do.devicecheck=1`, and the correct `block=/dev/block/bootdevice/by-name/boot`).
Then:
```bash
cd AnyKernel3
zip -r9 nethunter-kernel-hotdog.zip . -x '*.git*' README.md '*placeholder'
```

## 7. Flash

**Via Magisk (as a module‑style zip is not ideal for kernels) — prefer fastboot or a
custom recovery.** Simplest reliable route:

```bash
# extract the raw boot.img AnyKernel3 produces, OR flash the zip in TWRP/OrangeFox
# For fastboot, repack via AnyKernel3's boot.img output, then:
adb reboot bootloader
fastboot flash boot new-boot.img
fastboot reboot
```

> If you have a custom recovery, just flash `nethunter-kernel-hotdog.zip` there — it
> patches the current boot image in place. **Re‑install Magisk afterwards** if root
> disappears (re‑patch boot with the Magisk app).

## 8. Verify the good stuff

Inside NetHunter/Kali:
```bash
# internal or external adapter into monitor mode
airmon-ng start wlan0
iw dev                       # should show a monN monitor interface
# injection test (needs a target you own)
aireplay-ng --test wlan0mon
```
For HID: NetHunter app → **DuckHunter HID** / **HID Attacks** should now execute.

## Recovery if it bootloops

```bash
adb reboot bootloader          # or hold Vol Up + Power to reach fastboot
fastboot flash boot stock-lineage-boot.img
fastboot reboot
```

➡️ Next: **[Privacy hardening](06-privacy-hardening.md)**

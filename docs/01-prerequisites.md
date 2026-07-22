# 01 · Prerequisites & Bootloader Unlock

> **Assumes:** a OnePlus 7T Pro (`hotdog`), a computer (Linux/macOS/Windows), and a
> good USB cable. **This process wipes the phone.**

## 1. On your computer

Install `adb` and `fastboot` (the Android platform tools).

**Linux (Debian/Ubuntu):**
```bash
sudo apt install android-tools-adb android-tools-fastboot
```

**Arch/Manjaro:**
```bash
sudo pacman -S android-tools
```

**macOS:**
```bash
brew install android-platform-tools
```

**Windows:** download the [SDK Platform Tools](https://developer.android.com/tools/releases/platform-tools)
and add the folder to your `PATH`. You'll also want the Qualcomm/OnePlus USB drivers.

Verify:
```bash
adb version
fastboot --version
```

## 2. On the phone — enable developer options

1. **Settings → About phone → tap "Build number" 7 times.**
2. **Settings → System → Developer options:**
   - Enable **OEM unlocking**
   - Enable **USB debugging**
3. Plug the phone into your computer. Run:
   ```bash
   adb devices
   ```
   Accept the RSA fingerprint prompt on the phone. You should see your device listed
   as `device` (not `unauthorized`).

## 3. Match the stock firmware version ⚠️

LineageOS for `hotdog` **requires a specific stock OxygenOS firmware version to be
installed before you flash**. Installing on the wrong firmware can cause boot
failures or permanent damage.

👉 Check the **exact required firmware** on the official install page and update
(or downgrade) OxygenOS accordingly **before** continuing:
https://wiki.lineageos.org/devices/hotdog/install/

Do not skip this. It is the single most common cause of a bad flash on this device.

## 4. Unlock the bootloader

Reboot to the bootloader:
```bash
adb reboot bootloader
```

Confirm fastboot sees the device:
```bash
fastboot devices
```

Unlock (this **factory‑resets** the phone):
```bash
fastboot flashing unlock
```

Use the volume keys to select **UNLOCK THE BOOTLOADER** and confirm with power.
The phone wipes and reboots. Re‑enable **USB debugging** afterward (setup wizard →
developer options again).

> Some older guides use `fastboot oem unlock`. On the 7T Pro use
> `fastboot flashing unlock`.

## ✅ Done when

- `adb devices` shows your phone as authorized.
- `fastboot flashing unlock` completed and the bootloader reports **unlocked**.
- You are on the firmware version required by the LineageOS wiki.

➡️ Next: **[Install LineageOS](02-lineageos.md)**

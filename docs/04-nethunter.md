# 04 · Install Kali NetHunter

> **Assumes:** LineageOS + Magisk root working (see [03](03-magisk-root.md)).

Kali NetHunter turns the phone into a mobile pentest platform: a Kali chroot, the
NetHunter app (attack front‑end), the NetHunter Store, and a Kali terminal.

> **Legal:** only use NetHunter against systems you own or are explicitly authorised
> to test. See the disclaimer in the [README](../README.md).

Official docs: https://www.kali.org/docs/nethunter/

## Rooted vs kernel‑patched

There are three NetHunter "levels":

| Level | Needs | Gets you |
|-------|-------|----------|
| **Rootless** | nothing special | Kali chroot, most tools, no HID/Wi‑Fi injection |
| **Rooted** (this guide) | Magisk root | Full app, chroot, `su` tools, HID over USB where supported |
| **Kernel** | custom NetHunter kernel | Wi‑Fi **monitor mode + packet injection**, BadUSB HID, etc. |

Injection/monitor mode and some HID attacks require the **custom kernel** in
[05](05-nethunter-kernel.md). You can install the app first and add the kernel later.

## 1. Get the NetHunter package

Download the **generic rooted** NetHunter build (installed as a Magisk‑flashable zip)
from the official Kali NetHunter images page:
https://www.kali.org/get-kali/#kali-mobile

Pick the image matching your device's Android/kernel version. For a generic install
the "generic arm64" rooted image works on most SM8150 devices.

## 2. Flash it

Two common paths:

**A) Via Magisk (recommended, no custom recovery needed):**
1. Copy the NetHunter zip to the phone.
2. Magisk → **Modules → Install from storage** → select the NetHunter zip.
3. Reboot.

**B) Via a custom recovery** (TWRP/OrangeFox) if you installed one — flash the zip
there. LineageOS Recovery cannot flash arbitrary zips, so most people use path A.

## 3. Install the NetHunter app & store

After reboot you'll have the **NetHunter** app. Then:
1. Install the **NetHunter Store** APK: https://store.nethunter.com/
2. From the store, install **NetHunter‑KeX** (GUI over VNC), **NetHunter Terminal**,
   and **Hacker's Keyboard** if you want them.
3. Open the NetHunter app → **Kali Chroot Manager → Install/Update chroot** (full or
   minimal). This downloads the Kali rootfs.

## 4. Grant root & verify

- On first launch the NetHunter app requests **root** — grant it in Magisk.
- Open **NetHunter Terminal → Kali** and run:
  ```bash
  uname -a
  apt update && apt -y full-upgrade
  ```
- `nmap`, `metasploit`, etc. should be available inside the chroot.

## What still needs the custom kernel

If `iwconfig`/`airmon-ng` can't put the internal Wi‑Fi into monitor mode, or HID
attacks don't fire, that's expected on the stock LineageOS kernel — continue to:

➡️ Next: **[Build a custom NetHunter kernel](05-nethunter-kernel.md)** *(optional but
recommended for the full experience)*

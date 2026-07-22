# 03 · Root with Magisk

> **Assumes:** LineageOS is booting normally (see [02](02-lineageos.md)).

Magisk provides **systemless root** — it patches the boot image rather than modifying
`/system`, so it plays well with LineageOS and OTA updates. The standard,
device‑agnostic method is "patch the boot image with the Magisk app, then flash it."

Official source & full docs: https://github.com/topjohnwu/Magisk
(Installation guide: https://topjohnwu.github.io/Magisk/install.html)

## 1. Get the matching `boot.img`

You need the **exact `boot.img` from the LineageOS build you installed**. Two ways:

- **Easiest:** the LineageOS zip you sideloaded contains a `payload.bin`. Extract
  `boot.img` from it with a payload dumper, e.g.
  [`payload-dumper-go`](https://github.com/ssut/payload-dumper-go):
  ```bash
  payload-dumper-go -partitions boot lineage-XX.X-...-hotdog-signed.zip
  # -> extracts boot.img
  ```
- Or grab the `boot.img` matching your build if the maintainer publishes it.

## 2. Patch it with the Magisk app

1. Install the latest **Magisk APK** from the official GitHub releases.
2. Copy `boot.img` to the phone.
3. Open Magisk → **Install → Select and Patch a File** → choose `boot.img`.
4. Magisk writes `magisk_patched-XXXXX.img` to `Download/`. Pull it back:
   ```bash
   adb pull /sdcard/Download/magisk_patched-XXXXX.img
   ```

## 3. Flash the patched boot image

```bash
adb reboot bootloader
fastboot flash boot magisk_patched-XXXXX.img
fastboot reboot
```

## 4. Verify root

- Open the **Magisk** app — it should show it's installed (a version number under
  "Installed").
- Enable **Zygisk** in Magisk settings if you plan to use modules that need it.
- Test with any app that requests root, or:
  ```bash
  adb shell
  su      # Magisk should prompt for permission on the phone
  id      # should show uid=0(root)
  ```

## Notes & gotchas

- **OTA updates:** after a LineageOS OTA, root is lost. Re‑patch the new `boot.img`
  and re‑flash, or use Magisk's "Install to Inactive Slot" flow for A/B devices.
- **SafetyNet / Play Integrity:** if you kept the phone de‑Googled you won't care, but
  banking apps etc. may need extra Magisk modules. Out of scope here.

## ✅ Done when

- Magisk reports installed, and `su` grants root.

➡️ Next: **[Install Kali NetHunter](04-nethunter.md)**

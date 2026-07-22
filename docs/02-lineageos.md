# 02 · Install LineageOS

> **Assumes:** bootloader unlocked, correct stock firmware installed, `adb`/`fastboot`
> working (see [01](01-prerequisites.md)).

The OnePlus 7T Pro is an **A/B device** with no separate recovery partition —
recovery lives in the boot ramdisk. You boot LineageOS Recovery once, then sideload
the ROM.

> Follow the **official, always‑current** instructions here — they are kept in sync
> with each LineageOS release and firmware requirement:
> **https://wiki.lineageos.org/devices/hotdog/install/**
>
> The steps below are the canonical flow; use the wiki for exact download links.

## 1. Download

From the LineageOS site for `hotdog`, grab:
- `lineage-XX.X-....-recovery-hotdog.img` (the recovery image)
- `lineage-XX.X-....-nightly-hotdog-signed.zip` (the ROM)

Verify checksums/signatures if provided.

## 2. Boot LineageOS Recovery

```bash
adb reboot bootloader
fastboot flash boot lineage-XX.X-...-recovery-hotdog.img
```

> On this device the recovery **is** the boot image at install time. Use
> `fastboot flash boot <recovery.img>` exactly as the wiki specifies for your build,
> then use the volume/power keys to reboot into recovery.

Reboot into recovery:
```bash
fastboot reboot
```
Hold the key combo (or select **Recovery**) so it boots into **LineageOS Recovery**,
not the OS.

## 3. Factory reset (required)

In LineageOS Recovery: **Factory reset → Format data / factory reset**. This clears
any leftover encryption from OxygenOS.

## 4. Sideload the ROM

In recovery: **Apply update → Apply from ADB**, then on your computer:
```bash
adb sideload lineage-XX.X-...-nightly-hotdog-signed.zip
```

Wait for it to finish (it may report `Total xfer` and stop around 47–94% — that's
normal for sideload).

## 5. (Optional) Keep it Google‑free or add GApps

- **De‑Googled (recommended for privacy):** just reboot — LineageOS ships without
  Google services. Use [F‑Droid](06-privacy-hardening.md) and [Aurora Store] for apps.
- **Want Google apps?** Flash a GApps package (e.g. MindTheGapps matching the Android
  version) **in the same recovery session, before first boot**, via a second
  `adb sideload`.

> If you plan to install Magisk/NetHunter and want the cleanest base, stay de‑Googled.

## 6. First boot

```bash
# from recovery: Reboot system now
```
First boot takes several minutes. Complete the setup wizard, then **re‑enable
Developer Options → USB debugging**.

## ✅ Done when

- Phone boots into LineageOS.
- `adb devices` shows it again after re‑enabling USB debugging.

➡️ Next: **[Root with Magisk](03-magisk-root.md)**

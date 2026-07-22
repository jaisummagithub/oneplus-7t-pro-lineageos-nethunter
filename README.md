# OnePlus 7T Pro → LineageOS + Magisk + Kali NetHunter

A complete, reproducible guide to turning a **OnePlus 7T Pro (`hotdog`)** into a
privacy‑hardened, rooted, penetration‑testing phone running:

- **LineageOS** (de‑Googled Android)
- **Magisk** (systemless root)
- **Kali NetHunter** (mobile pentesting platform)
- an optional **custom NetHunter kernel** (Wi‑Fi injection, HID, etc.)
- an optional **always‑on AI agent** running locally in Termux

This repo is written so **anyone with the same phone can replicate the whole thing**
from a factory‑reset device. Every step links back to the official upstream source
so it stays valid as versions change.

<p align="center">
  <img src="assets/oneplus-7t-pro-nethunter-homescreen.jpg" alt="OnePlus 7T Pro running LineageOS + Kali NetHunter: a de-Googled, privacy-focused home screen with the NetHunter Store, Aurora Store, Briar, NewPipe, Organic Maps, DuckDuckGo, a VPN widget, and a Termux widget of one-tap AI-agent startup scripts" width="330">
  <br>
  <em>The finished build — LineageOS (de‑Googled) + Kali NetHunter, privacy apps (Briar, NewPipe, Organic Maps, DuckDuckGo, always‑on VPN), an on‑device LLM (PocketPal), and a Termux widget that one‑tap launches the local AI agent.</em>
</p>

> **Device codename:** `hotdog`  ·  **SoC:** Qualcomm SM8150 (Snapdragon 855+)
> Do **not** confuse it with the OnePlus 7T (`hotdogb`). Flashing the wrong device's
> firmware/ROM can hard‑brick your phone.

---

## ⚠️ Read this before you start

- **You can brick your phone.** Follow every step carefully and read the official
  wiki for your exact firmware version. When in doubt, stop and research.
- **This wipes your device.** Unlocking the bootloader performs a full factory reset.
  Back everything up first.
- **Warranty:** Unlocking the bootloader / rooting typically voids your warranty.
- **NetHunter is a security tool.** Only test networks and devices you **own** or have
  **explicit written permission** to test. You are responsible for complying with all
  applicable laws. Nothing here is an invitation to do anything illegal.
- Nobody here is responsible for what happens to your device. **You do this at your own risk.**

---

## What you'll end up with

| Layer | Component | Purpose |
|-------|-----------|---------|
| OS | LineageOS (`hotdog`) | Clean, de‑Googled Android base |
| Root | Magisk | Systemless root + modules + zygisk |
| Pentest | Kali NetHunter | Kali chroot, NetHunter app, store |
| Kernel | Custom NetHunter kernel (optional) | Wi‑Fi monitor mode + packet injection, HID attacks, etc. |
| Privacy | F‑Droid, AFWall+, Orbot, VPN | Firewall, Tor, app control, no Play Services |
| Bonus | Local AI agent in Termux (optional) | Always‑on assistant, on‑device LLM fallback |

---

## The path (in order)

1. **[Prerequisites & bootloader unlock](docs/01-prerequisites.md)** — tools, drivers, `fastboot flashing unlock`
2. **[Install LineageOS](docs/02-lineageos.md)** — firmware match, recovery, sideload
3. **[Root with Magisk](docs/03-magisk-root.md)** — patch `boot.img`, flash, verify
4. **[Install Kali NetHunter](docs/04-nethunter.md)** — app, store, chroot
5. **[Build a custom NetHunter kernel](docs/05-nethunter-kernel.md)** — *optional*, unlocks injection/HID
6. **[Privacy hardening](docs/06-privacy-hardening.md)** — F‑Droid, AFWall+, Orbot, VPN, hardening
7. **[Optional: standalone AI agent in Termux](docs/07-standalone-ai-agent.md)** — always‑on assistant

Each doc is self‑contained and starts with what it assumes you've already done.

---

## Versions used at time of writing

These are the exact versions this build was tested with. **Always prefer the latest
official release** and treat these as a reference point, not gospel.

- LineageOS: `23.x` (`hotdog`, official build)
- Magisk: `v30.x`
- Kali NetHunter: `2026.1`
- NetHunter kernel: [`kimocoder/nethunter_kernel_oneplus7`](https://github.com/kimocoder/nethunter_kernel_oneplus7) — branch `nethunter-12.1`
- Toolchain: `aarch64-linux-gnu-gcc` (+ Clang for newer trees)

---

## Official sources (bookmark these)

- LineageOS install (hotdog): https://wiki.lineageos.org/devices/hotdog/install/
- LineageOS build (hotdog): https://wiki.lineageos.org/devices/hotdog/build/
- Magisk: https://github.com/topjohnwu/Magisk
- Kali NetHunter docs: https://www.kali.org/docs/nethunter/
- NetHunter kernel (OnePlus 7 series): https://github.com/kimocoder/nethunter_kernel_oneplus7
- AnyKernel3 (kernel packaging): https://github.com/osm0sis/AnyKernel3

---

## License

MIT — see [LICENSE](LICENSE). Do whatever you want, no warranty.

*Guide compiled from a real end‑to‑end build. PRs welcome if something drifts out of date.*

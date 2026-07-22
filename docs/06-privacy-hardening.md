# 06 · Privacy Hardening

> **Assumes:** LineageOS + Magisk (NetHunter optional). The goal: a phone that leaks
> as little as possible and gives you control over every app's network access.

## 1. App sources without Google

- **[F‑Droid](https://f-droid.org/)** — FOSS app store. Install the APK, then enable
  the *F‑Droid Privileged Extension* via Magisk if you want silent updates.
- **[Aurora Store](https://auroraoss.com/)** — anonymous front‑end to the Play Store
  for the occasional proprietary app, without a Google account.

## 2. Firewall — AFWall+

[AFWall+](https://github.com/ukanth/afwall) (root firewall) lets you allow/deny network
per app.

- Install from F‑Droid, grant root.
- Default policy: **deny all**, then allow only the apps that genuinely need it.
- Enable **"Apply on boot"** and consider the *fix startup data leak* option.

## 3. Tor — Orbot

[Orbot](https://orbot.app/) routes traffic over Tor.

- Install from F‑Droid / NetHunter Store.
- Use **VPN mode** and select which apps tunnel through Tor.
- Combine with AFWall+ so only Orbot‑approved apps reach the network.

## 4. VPN

Install your VPN provider's app (or a WireGuard/OpenVPN config in the
[WireGuard](https://www.wireguard.com/install/) app). Log in and enable
**always‑on VPN + block connections without VPN** in
**Settings → Network → VPN**.

> Order of trust: VPN for everyday privacy from your ISP; Orbot/Tor for anonymity;
> AFWall+ as the backstop that blocks anything you didn't explicitly allow.

## 5. LineageOS built‑in hardening

- **Settings → Privacy → Trust** — review the Trust panel (SELinux status, security
  patch level).
- **Privacy Guard / per‑app permissions** — revoke sensors, location, mic, camera
  from apps that don't need them.
- **Settings → Security → Encryption** — confirm the device is encrypted (default on).
- Set a strong PIN/passphrase; disable lockscreen notifications for sensitive apps.
- **Restricted networking / MAC randomization** — keep per‑network MAC randomization
  **on** for every Wi‑Fi network.

## 6. Optional extras

- **Bromite/Vanadium‑style hardened browser** or Mull (Firefox‑based, from F‑Droid).
- **RethinkDNS** for DNS‑level blocking + firewall if you prefer it over AFWall+.
- **microG** *only* if some app truly needs push/location and you accept the tradeoff.

## ✅ Result

A de‑Googled phone where **nothing talks to the network unless you allowed it**, with
Tor and VPN available on demand.

➡️ Optional next: **[Standalone AI agent in Termux](07-standalone-ai-agent.md)**

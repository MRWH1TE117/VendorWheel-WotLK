# VendorWheel (WotLK 3.3.5a)

Lightweight QoL addon for **World of Warcraft: Wrath of the Lich King 3.3.5a (12340)** that lets you flip **vendor pages with the mouse wheel**:

- **Scroll down** → next page
- **Scroll up** → previous page
- **Shift + scroll** → jump **5 pages**  
  Works **only** on the **Vendor** tab (MerchantFrame tab 1); Buyback is ignored for paging logic, but the wheel is attached so it doesn’t steal focus.

![Preview](docs/preview.png)

---

## Features

- **Mouse wheel paging** on merchant listings (no clicking tiny arrows).
- **Shift modifier** to quickly jump through multiple pages (×5).
- Safe attachment to merchant UI elements (skips non-frame objects like font strings).
- Adds wheel handling to relevant child frames (item slots/buttons) so scrolling works wherever your cursor is within the merchant window.

---

## Compatibility

- **Client:** WotLK 3.3.5a (build 12340)
- **UI:** Default Blizzard MerchantFrame (tab 1 — Vendor). Buyback tab is not paged.

---

## Installation

1. Code > Download ZIP, rename **`VendorWheel-WotLK`** to **`VendorWheel`**
2. Place the folder **`VendorWheel`** into: World of Warcraft\Interface\AddOns\
3. In-game, enable **Load out of date addons** if needed.
4. Enter the world — the addon works out of the box.

---

## Usage

- **Scroll Down**: Next vendor page
- **Scroll Up**: Previous vendor page
- **Hold Shift + Scroll**: Jump 5 pages at a time
  > Works when the **Vendor** tab is visible; paging won’t trigger on **Buyback** (tab 2).

---

## Notes for Developers

- The addon safely attaches `OnMouseWheel` to frames that actually support it (checks for `EnableMouseWheel` / `HookScript`).
- It boosts usability by attaching to multiple merchant child frames per page (`MerchantItem1..N`, their `ItemButton`s, and `MerchantBuyBackItem`) so the wheel works even when hovering over item areas.

---

## Screenshots

Put your image at **`docs/preview.png`** to display the preview above.  
You can add more images in `docs/` and reference them, e.g.:

```md
![Scrolling with Shift](docs/shift_jump.png)
```

## Changelog

```md
v1.0.0
Initial release: mouse wheel paging on Vendor tab, Shift to jump 5 pages, safe wheel attachment to merchant child frames.
```

## FAQ

```md
Q: The wheel does nothing.
A: Make sure the Vendor tab is selected and there is a next/previous page available. Also verify Load out of date addons is enabled for 3.3.5a clients.

Q: Can I change the “5 pages” jump amount?
A: Not via slash command in this minimal version. You can tweak it in code: the times variable inside Page(delta) when IsShiftKeyDown() is true.

Q: Does this affect Buyback?
A: The addon intentionally ignores Buyback when deciding to page, to prevent accidental flips. Wheel is attached so scrolling doesn’t get “stuck,” but no paging occurs there.
```

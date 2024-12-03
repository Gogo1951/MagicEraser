NOTE: This is a BETA. Reporting of "junk" items is very much appreciated.

# Magic Eraser

A simple add-on that discards the lowest-value item in your bags -- including completed quest items, gray items, and vendor-quality white items -- when you run the `/MagicEraser` slash-command.

Examples:

> Magic Eraser : Erasing \[Sapphire of Aku'Mai\]! This item was associated with a quest you have completed.

> Magic Eraser : Erasing 1x \[Cracked Egg Shells\] - worth 4c. (Gray Item)

> Magic Eraser : Erasing 4x \[Tel'Abim Banana\] - worth 24c. (Low-Level Consumable Item)

> Magic Eraser : Erasing 1x \[Ancestral Gloves\] - worth 48c. (White Vendor-Quality Item)

> Magic Eraser : Congratulations, your bags are full of good stuff! You'll have to manually erase something if you need to free up more space.

## How It Works

⚠️ **Magic Eraser** acts decisively -- there is no "Are you sure?" step. 

* Everything erased comes from a manually curated, multiple-human-reviewed, approved trash list.
* From there, Magic Eraser scans all items in your bags and identifies the lowest-value item to erase.
* It looks at the following:
  * Completed Quest Items and "Provided For" Items that linger in your bag indefinitely.
  * Generic consumable items with a use level at least 10 levels lower than your character.
  * Gray vendor items.
  * Vendor-quality white items.

➡️ In the future... A proper UI is in the works, but I wanted to release this while players are still leveling in the Anniversary Edition. Ideally some version of this will find its way into Questie. https://github.com/Questie/Questie/issues/6481

## Download

You can find this on Curseforge.

https://www.curseforge.com/wow/addons/magic-eraser

## Testing Notes

🟢 Classic Era

🟢 Classic Hardcore

🟡 Season of Discovery

🟢 Classic Anniversary

🔴 Cataclysm Classic

🔴 Retail

Please reach out if you would like to be involved with testing!

## Report Issues & Get Involved

You can find this project on GitHub.

https://github.com/Gogo1951/MagicEraser

Gogo1951 on Discord.

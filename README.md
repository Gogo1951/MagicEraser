# MagicEraser

A simple add-on that automatically discards the lowest-value item in your bags, including completed quest items, gray items, and vendor-quality white items.

## How It Works

⚠️ **Magic Eraser** acts decisively—it deletes first and asks questions later. Every time you use the `/MagicEraser` slash-command, something will get deleted -- there is no "Are you sure?" step. (A proper UI is in the works, but I wanted to release this while players are still leveling in the Anniversary Edition. Ideally this will find its way into Questie. https://github.com/Questie/Questie/issues/6481)

* Everything deleted comes from a manually curated, multiple-human-reviewed, approved trash list.
* From there, Magic Eraser scans all items in your bags and identifies the lowest-value item to delete.
* It prioritizes the following:
  * Completed Quest Items and "Provided For" items that linger in your bag indefinitely.
  * Vendor-quality white items with an item level at least 10 levels lower than your character.
  * Generic consumable items with a use level at least 10 levels lower than your character.
  * Gray vendor items.

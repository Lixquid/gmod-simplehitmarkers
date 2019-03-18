<h1 align="center">Simple Hitmarkers</h1>

Simple Hitmarkers adds a small hitmarker with accompanying sound when damage is dealt to any player or NPC.

Features:

-   Hitnumbers; Know exactly how much damage you're dealing.
-   Highly Customizable; disable sound, change hitmarker size, time, and critical display.
-   Efficient; network traffic is a single net message per hit, and just two hooks on client and server.
-   Lightweight; the entire addon included resources is just 15 KB, and two files to download.

## Installing

-   As an Addon:
    -   Copy the `hitmarkers` folder to `garrysmod/addons`.
-   Via the Workshop:
    -   [Subscribe to the
        addon](http://steamcommunity.com/sharedfiles/filedetails/?id=950493639)

## Configuration

Simple Hitmarkers can be configured from the Settings Panel in the spawnmenu,
under `Utilities > Lixquid > Hitmarkers`.

Console Commands:

-   `hitmarkers_enabled` (Default: `1`)
    -   Enables hitmarkers.
-   `hitmarkers_criticals` (Default: `0`)
    -   If above zero, sets the threshold at which hitmarkers will display as
        'critical'
-   `hitmarkers_size` (Default: `128`)
    -   The size of the hitmarker cross.
-   `hitmarkers_sound` (Default: `1`)
    -   If enabled, hitmarkers will play a sound.
-   `hitmarkers_time` (Default: `1`)
    -   Sets how long hitmarkers should be visible on screen.
-   `hitmarkers_numbers` (Default: `0`)
    -   If enabled, damage numbers will appear above the hit point.
-   `hitmarkers_numbers_time` (Default: `2`)
    -   Sets how long damage numbers will last in-game.
-   `hitmarkers_numbers_size` (Default: `1`)
    -   Sets how large hitnumbers will appear

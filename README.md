<h1 align="center">Simple Hitmarkers</h1>

Simple Hitmarkers adds a small hitmarker with accompanying sound when damage is dealt to any player or NPC.

Features:

- Highly Customizable; disable sound, change hitmarker size, time, and critical display.
- Efficient; network traffic is a single net message per hit, and a single hook on client and server.
- Lightweight; the entire addon included resources is just 10 KB, and two files to download.

## Installing

- As an Addon:
	- Copy the `hitmarkers` folder to `garrysmod/addons`.
- Via the Workshop:
	- [Subscribe to the
	  addon](http://steamcommunity.com/sharedfiles/filedetails/?id=950493639)

## Configuration

Simple Hitmarkers can be configured from the Settings Panel in the spawnmenu,
under `Utilities > Lixquid > Hitmarkers`.

Console Commands:

- `hitmarkers_enabled` (Default: `1`)
	- Enables hitmarkers.
- `hitmarkers_criticals` (Default: `0`)
	- If enabled, high damage attacks will have a different colour.
- `hitmarkers_size` (Default: `128`)
	- The size of the hitmarker cross.
- `hitmarkers_sound` (Default: `1`)
	- The colume of the hitmarkers sound, from 0 to 1.
- `hitmarkers_time` (Default: `1`)
	- Sets how long hitmarkers should be visible on screen.

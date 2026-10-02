# Pixel Adventure
 
![Godot](https://img.shields.io/badge/Godot-4.7-478CBF?logo=godotengine&logoColor=white)
![GDScript](https://img.shields.io/badge/GDScript-478CBF)
[![Play](https://img.shields.io/badge/Play-in%20your%20browser-brightgreen)](https://ayman-m-elsaid.github.io/<repo-name>/)
 
A 2D pixel-art platformer made with **Godot 4.7** and GDScript. Collect fruit, dodge traps, stomp enemies, get achievements, and unlock new characters along the way.
 
### [▶ Play it in your browser](https://ayman-m-elsaid.github.io/Pixel-Adventure/)
 
No install needed. It runs on desktop and phone browsers.
 
![Gameplay](https://github.com/user-attachments/assets/3d13ba0e-c49b-4d47-bfdd-a8ca4d393cfb)
 
## Screenshots
 
| Start screen | Level select |
|---|---|
| ![Start screen](https://github.com/user-attachments/assets/58872fe5-cd3a-4675-8804-989bcd372f88) | ![Level select](https://github.com/user-attachments/assets/976deb1a-4177-4d47-aabd-69b67e323a02) |
 
| Gameplay | Character select |
|---|---|
| ![Gameplay](https://github.com/user-attachments/assets/2aa26c78-c270-4c19-9037-aee2ff7846aa) | ![Character select](https://github.com/user-attachments/assets/2f11b78a-6c70-4743-a0e3-1672ca7b68d8) |
 
| Achievements | Statistics |
|---|---|
| ![Achievements](https://github.com/user-attachments/assets/e13edde2-e852-483e-8778-9bddc433ee1c) | ![Statistics](https://github.com/user-attachments/assets/e690a480-1dbd-416b-b567-75a50f65df7c) |
 
## Features
 
- **Levels:** 30 hand-designed levels plus a short tutorial. Collect every fruit to clear a level. Every five levels introduce something new, and levels 6, 12, 18, 24 and 30 are long, mirrored combo levels that use everything introduced so far.
- **Traps:** levels 1-15 are about hazards: spikes, saws, fire, spiked balls, spike heads, rock heads, fans, trampolines, and moving and falling platforms.
- **Enemies:** levels 16-30 are about 12 enemy types (pigs, bats, bees, birds, chameleons, chickens, mushrooms, plants, radishes, rhinos, rocks and trunks) that patrol, chase, charge or shoot. Stomp them to defeat them, though some split apart or take several stomps.
- **Movement:** double jump, wall slide and wall jump.
- **Progression:** 4 playable characters and 27 achievements, with in-game pop-ups, an achievements screen and a statistics screen. Progress saves automatically.
- **Menus and presentation:** start screen, level select, character select and an end screen, with diamond-wipe transitions between them. On-screen touch controls appear on phones.

## Controls
 
| Action | Keyboard |
| --- | --- |
| Move | `A` / `D` or `Left` / `Right` |
| Jump (press again in the air to double jump) | `Space`, `W` or `Up` |
| Restart the level | `R` |
| Back to the level select | `Esc` |
| Menus | Mouse, or `Enter` / `Space` to confirm |
 
On touch devices, on-screen buttons appear automatically. The game is played in landscape.
 
## Project layout
 
```
project.godot
scenes/
  Entities/       player, collectables, background, debris
    Enemies/      enemy scenes (one per type, plus base scenes)
    Hazards/      spikes, saws, fire, spike heads, spiked balls, bullets
    Traps/        fans, trampolines, moving / falling platforms, rock heads
  Levels/         level.tscn (base) and level_00 ... level_30
  States/         start, level select, character select, end, achievements, statistics screens
  UI/             transition, achievement pop-up and badge, tutorial overlay, proximity labels
scripts/
  Autoload/       SaveManager, AchievementManager, AchievementPopUp, Transition, PlayerManager
  Data/           character definitions
  Effects/        debris and fade effects
  Entities/       player, enemies, hazards, traps
  States/         screen and level logic
  UI/             UI scripts
resources/        character sprite frames, fruit data, achievement definitions
```
 
## Architecture notes
 
- **Autoloads** hold the things that must outlive any single scene:
  - `SaveManager` loads and saves progress as JSON (current level, selected and unlocked characters, fruit and enemy stats, deaths, achievements) and runs the achievement check on every save.
  - `AchievementManager` checks the save data against the unlock conditions and emits a signal when an achievement unlocks. `AchievementPopUp` listens for it and shows the in-level pop-up.
  - `Transition` plays the diamond wipe used for every scene change.
  - `PlayerManager` keeps state that has to survive a level reload, such as whether the player is respawning, so a restart does not replay the full wipe.
  - `Music` keeps the background music playing across scene changes.
- **Levels** are inherited scenes of `scenes/Levels/level.tscn`, which contains the `TileMapLayer`, collectables, hazards, enemies, player and a `LevelManager`. That node runs the level's flow (intro transition, fruit tally, finishing or restarting) and is deliberately per level rather than an autoload, because it only matters while a level is running.
- **Enemies** share a small class hierarchy: `Enemy` (base `CharacterBody2D`) -> `PatrolEnemy` (pig, radish, rock, `ShootingEnemy`) and `Enemy` -> `ChaseEnemy` (chameleon), plus `ChargeEnemy`. Variations are mostly done with `@export` variables and Inspector tuning rather than separate scripts.
- **Achievements** are split by concern: display data (title, description, icon) lives in `AchievementDef` resources, while the unlock conditions live in `AchievementManager`.
## Credits
 
- Art: [Pixel Adventure 1](https://pixelfrog-assets.itch.io/pixel-adventure-1) and [Pixel Adventure 2](https://pixelfrog-assets.itch.io/pixel-adventure-2) by Pixel Frog (CC0)
- Music and sound effects: [Pixabay](https://pixabay.com) and [ChipTone](https://sfbgames.itch.io/chiptone)
- Built with [Godot Engine](https://godotengine.org/)
Full details are in [CREDITS.md](CREDITS.md).
 
## License
 
The code is released under the [MIT License](LICENSE). Art and audio keep the terms listed in [CREDITS.md](CREDITS.md) and are not covered by the MIT license.
 
# Spooky fish game plan

## Game ideas
TRUST NO ONE
Navigate through an underwater maze to find your treasure(???).

Find "trustworthy friends" that can direct you toward the win condition and give you consumables, but will betray you in the end.

### Setting
Underwater mossy caves filled will NPCs.
Everything is dark except for what is immediately around the player - level, forground, background and NPC elements are obscured by darkness until the player illuminates them.


## Characters
"Trustworthy" and enemy NPCs.
Both have eyes that can be seen in the dark. The rest of the character is revealed by player light.
Trustworthy NPCs dash toward the level exit, leaving behind a consumable for the player.
Enemies dash in a random direction, dealing "damage" to the player as they go.

### Enemies
When interacted with, will steal torch battery and dash in a random direction. Warm coloured eyes. Proximity interaction trigger, then slowly follow the player character until they can attack, or the player runs away(??) or leaves the level.

### Friends
When interacted with, will dash toward the exit and drop a consumable to fill the torch battery. Interaction based on proximity - go and say hi.

### Player character
Submarine, 4 direction control, WASD/arrows. Mouse control for a torch - LMB to turn on/off.


## Level Plans
3 - 5 rooms/levels + tiny tutorial level -> introduce "friends" and enemies.

Fairly small levels, simple shapes for ease of navigation. Lots of fore/background objects to decorate things.

Lots of nooks to place NPCs, optional interactions.



## Project structure

```
assets/
- textures/
  - texture-group/ # put each texture group in a folder
- sounds/
  - sounds-group/ # put each sound group in a folder
scenes/
- objectName/ # put everything for each object in a folder
scripts/
  - script-name.gd # put game-wide scripts here
```




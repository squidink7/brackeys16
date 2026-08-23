# Spooky fish game plan

## Game ideas

### Setting

Underwater, 4 directional movement, maze-like environment

Trying to reach the exit.

### Enemies

Vision circle, when they enter your screen they random short delay before their vision activates

Can be distinguished from friends by movement speed, eye colour.

Can come in multiple sizes, big enemies eat you, small enemies eat your friends.

Futher ideas for if we have time:
- Slow draining of light, find friends to refill.
- Fish that drain your light?

### Friends

Helpful NPCs that guide you to the exit. Collect more of them to refill your light.
- Once they are encountered, they dash towards the exit.

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

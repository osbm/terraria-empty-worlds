# Terraria Empty Worlds Generator

This project automatically generates empty Terraria world files for all combinations of world sizes, difficulties, and corruption types.

This release contains pre-generated empty world files for all combinations of:
- **Sizes**: small, medium, large
- **Difficulties**: journey, classic, expert, master
- **Corruption types**: crimson, corruption

I also placed a couple of blocks in the center of the world to stand on.

You can download the generated worlds from the [releases page](https://github.com/osbm/terraria-empty-worlds/releases).

Or you can build the project yourself using Nix:

```bash
nix run github:osbm/terraria-empty-worlds
```

Or cargo:

```bash
git clone https://github.com/osbm/terraria-empty-worlds.git
cd terraria-empty-worlds
cargo run
```



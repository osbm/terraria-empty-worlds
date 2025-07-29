use terraria_world::World;

fn main() {
    let world_sizes = vec!["small", "medium", "large"];
    let world_difficulties = vec!["journey", "classic", "expert", "master"];
    let corruption_types = vec!["crimson", "corruption"];

    // 3 nested loops to generate all combinations
    for size in &world_sizes {
        for difficulty in &world_difficulties {
            for corruption_type in &corruption_types {
                let world_name = format!("{size}-{difficulty}-{corruption_type}-empty-world");
                let mut world = World::new(&world_name, size, difficulty, corruption_type);
                println!("Creating world: {}", world_name);
                // save the world to a file
                let middle_x = world.world_width / 2;
                let middle_y = world.world_height / 2;
                for i in 0..5 {
                    let x = middle_x - 2 + i;
                    world.tiles.tiles[x as usize][middle_y as usize].block_id = 1; // Set block ID to 1 (e.g., dirt)
                    world.tiles.tiles[x as usize][middle_y as usize].block_illuminant = true; // Set block as illuminant
                }

                world.save_as_wld(format!("{world_name}.wld").as_str()).expect("Failed to save world");
                println!("World {} saved successfully!", world_name);
            }
        }
    }
}


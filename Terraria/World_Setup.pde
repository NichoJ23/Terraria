void setupTiles() {  
  blocks = new Block[map.width][map.height];
  
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.width; y++) {
      color c = map.get(x, y);
      
      switch (c) {
        case brown:
          Block b = new Block(x * tileSize, y * tileSize, 50, 2, dirt);
          b.type = BlockTypes.DIRT;
          
          String edges = getEdges(map, x, y, c);
          b.attachImage(dirt.get(edges));
          
          blocks[x][y] = b;
          world.add(b);
          break;
        case gray:
          b = new Block(x * tileSize, y * tileSize, 100, 1, stone);
          b.type = BlockTypes.STONE;
          
          edges = getEdges(map, x, y, c);
          b.attachImage(stone.get(edges));
          
          blocks[x][y] = b;
          world.add(b);
          break;
        case transparent:
          blocks[x][y] = null;
          break;
        default:
          println("Colour " + c + " is not a registered colour");
      }
    }
  }
}

void setupWorld() {
  world = new FWorld(-10000, -10000, 10000, 10000);
  world.setGravity(0, 700);
  
  enemies = new ArrayList<Enemy>();
}

void setupPlayer() {
  player = new Player(width/2, height/2);
  world.add(player);
  
  Zombie z = new Zombie(300, 100);
  enemies.add(z);
  world.add(z);
}

void setupWeapons() {
  weapons = new HashMap<String, Tool>();
  weapons.put("Wooden Sword", new Sword(20, 20, 5, 4, woodenSword)); // first number was originally 7, increased for more damage
  weapons.put("Copper Pickaxe", new Pickaxe(4, 23, 2, 0.04, 15, 35, 1, copperPickaxe));
  weapons.put("Dirt Block", new Placeable(15, newDirtBlock()));
  weapons.put("Stone Block", new Placeable(15, newStoneBlock()));
  weapons.put("Wood Block", new Placeable(15, newWoodBlock()));
}

void setupData() {
  itemStacks = new HashMap<ItemTypes, Integer>();
  itemStacks.put(ItemTypes.COPPER_COIN, 99999);
  itemStacks.put(ItemTypes.SILVER_COIN, 99999);
  itemStacks.put(ItemTypes.GOLD_COIN, 99999);
  itemStacks.put(ItemTypes.PLATINUM_COIN, 99999);
  itemStacks.put(ItemTypes.WOODEN_SWORD, 1);
  itemStacks.put(ItemTypes.COPPER_PICKAXE, 1);
  itemStacks.put(ItemTypes.DIRT, 9999);
  itemStacks.put(ItemTypes.STONE, 9999);
  itemStacks.put(ItemTypes.WOOD, 9999);
  
  droppedItems = new ArrayList<Dropped>();
}

String getEdges(PImage map, int x, int y, color c) {
  String edges = "";
  
  edges = edges.concat((map.get(x, y-1) != transparent) ? "1": "0");
  edges = edges.concat((map.get(x+1, y) != transparent) ? "1": "0");
  edges = edges.concat((map.get(x, y+1) != transparent) ? "1": "0");
  edges = edges.concat((map.get(x-1, y) != transparent) ? "1": "0");
  
  return edges;
}

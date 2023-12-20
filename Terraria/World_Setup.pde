void setupTiles() {
  blocks = new Block[map.width][map.height];
  
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.width; y++) {
      color c = map.get(x, y);
      
      switch (c) {
        case brown:
          Block b = new Block(x * tileSize, y * tileSize);
          b.setName("ground");
          b.type = BlockTypes.DIRT;
          
          String edges = getEdges(map, x, y, c);
          if (edges.equals("1111")) {
            b.attachImage(dirt);
          } else {
            b.attachImage(grass.get(edges));
          }
          
          blocks[x][y] = b;
          world.add(b);
          break;
        case gray:
          b = new Block(x * tileSize, y * tileSize);
          b.setName("ground");
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
  weapons = new HashMap<String, Weapon>();
  weapons.put("Wooden Sword", new Weapon(7, 20, 5, 4, woodenSword));
}

String getEdges(PImage map, int x, int y, color c) {
  String edges = "";
  
  edges = edges.concat((map.get(x, y-1) != transparent) ? "1": "0");
  edges = edges.concat((map.get(x+1, y) != transparent) ? "1": "0");
  edges = edges.concat((map.get(x, y+1) != transparent) ? "1": "0");
  edges = edges.concat((map.get(x-1, y) != transparent) ? "1": "0");
  
  return edges;
}

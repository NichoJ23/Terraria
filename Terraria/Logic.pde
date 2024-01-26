FBox touchingBlock(FBody body, String type) {
  ArrayList<FContact> contacts = body.getContacts();
  
  for (FContact c: contacts) {
    
    if (c.getBody1() == body) {
      if (c.getBody2().getName() == type) {
        return (FBox)c.getBody2();
      }
    } else {
      if (c.getBody1().getName() == type) {
        return (FBox)c.getBody1();
      }
    }
  }
  
  return null;
}
  
FBox touchingBlock(FBody body, String[] types) {
  ArrayList<FContact> contacts = body.getContacts();
  
  for (FContact c: contacts) {
    List typesList = Arrays.asList(types);
    
    if (c.getBody1() == body) {
      if (typesList.contains(c.getBody2().getName())) {
        return (FBox)c.getBody2();
      }
    } else {
      if (typesList.contains(c.getBody1().getName())) {
        return (FBox)c.getBody1();
      }
    }
  }
  
  return null;
}

ArrayList<FBody> touchingBodies(FBody body, String type) {
  ArrayList<FContact> contacts = body.getContacts();
  ArrayList<FBody> bodies = new ArrayList<FBody>();
  
  for (FContact c: contacts) {
    
    if (c.getBody1() == body) {
      if (c.getBody2().getName() == type) {
        bodies.add(c.getBody2());
      }
    } else {
      if (c.getBody1().getName() == type) {
        bodies.add(c.getBody1());
      }
    }
  }
  
  return bodies;
}

PVector getWorldCoords(int x, int y) {
  return new PVector(x + player.getX() - 400, y + player.getY() - 400);
}

PVector getWorldIndex(PVector pos) {
  return new PVector(round(pos.x / tileSize), round(pos.y / tileSize));
}

FBox getBlockAt(PVector pos) {
  int arrayX = (int)round(pos.x / tileSize);
  int arrayY = (int)round(pos.y / tileSize);
  
  // Don't try to mine blocks outside of the world
  
  if (arrayX < 0 || arrayX > blocks[0].length - 1 || arrayY < 0 || arrayY > blocks.length - 1) return null;
  
  return blocks[arrayX][arrayY];
}

void dropCoins(int amount, int x, int y) {
  if (amount >= 1000) {
    int numCoins = amount / 1000; // integer division so automatically truncates
    Coin platCoin = new Coin(x, y, numCoins, CoinTypes.PLATINUM);
    
    world.add(platCoin);
    
    amount -= numCoins * 1000;
  }
  if (amount >= 100) {
    int numCoins = amount / 100; // integer division so automatically truncates
    Coin goldCoin = new Coin(x, y, numCoins, CoinTypes.GOLD);
    
    world.add(goldCoin);
    
    amount -= numCoins * 100;
  }
  if (amount >= 10) {
    int numCoins = amount / 10; // integer division so automatically truncates
    Coin silverCoin = new Coin(x, y, numCoins, CoinTypes.SILVER);
    
    world.add(silverCoin);
    
    amount -= numCoins * 10;
  }
  
  if (amount >= 1) {
    // add all the rest as copper coins
    int numCoins = amount;
    Coin copperCoin = new Coin(x, y, numCoins, CoinTypes.COPPER);
    
    world.add(copperCoin);
  }
}

Block newDirtBlock() {
  Block b = new Block(0, 0, 50, 2, dirt);
  b.setName("ground");
  b.type = BlockTypes.DIRT;
  
  return b;
}

Block newStoneBlock() {
  Block b = new Block(0, 0, 100, 2, stone);
  b.setName("ground");
  b.type = BlockTypes.STONE;
  
  return b;
}

Block newWoodBlock() {
  Block b = new Block(0, 0, 50, 2, wood);
  b.setName("ground");
  b.type = BlockTypes.WOOD;
  
  return b;
}

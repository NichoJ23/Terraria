enum BlockTypes {DIRT, STONE, WOOD};

class Block extends FBox {
  int x;
  int y;
  int arrayX;
  int arrayY;
  int hp;
  float damageMultiplier;
  BlockTypes type;
  
  HashMap<String, PImage> sprites;
  
  Block(int _x, int _y, int _hp, float _damageMultiplier, HashMap<String, PImage> _sprites) {
    super(tileSize, tileSize);
    setPosition(_x, _y);
    setGrabbable(false);
    setStatic(true);
    setName("ground");
    
    x = _x;
    y = _y;
    arrayX = x / tileSize;
    arrayY = y / tileSize;
    
    hp = _hp;
    damageMultiplier = _damageMultiplier;
    sprites = _sprites;
  }
  
  void takeDamage(int damage) {
    hp -= damage * damageMultiplier;
    
    if (hp < 0) {
      destroy();
    }
  }
  
  void destroy() {
    world.remove(this);
    blocks[arrayX][arrayY] = null;
    
    // Tell the surrounding blocks to re-evaluate their sprites as this one is no longer there
    if (arrayX > 0) {
      Block b = blocks[arrayX - 1][arrayY];
      if (b != null) {
        b.reEvaluateEdges();
      }
    }
    if (arrayX < blocks[0].length - 1) {
      Block b = blocks[arrayX + 1][arrayY];
      if (b != null) {
        b.reEvaluateEdges();
      }
    }
    if (arrayX > 0) {
      Block b = blocks[arrayX][arrayY + 1];
      if (b != null) {
        b.reEvaluateEdges();
      }
    }
    if (arrayX < blocks.length) {
      Block b = blocks[arrayX][arrayY - 1];
      if (b != null) {
        b.reEvaluateEdges();
      }
    }
  }
  
  void reEvaluateEdges() {
    String edges = getEdges(arrayX, arrayY);
    println(edges);
    attachImage(sprites.get(edges));
  }
  
  String getEdges(int indexX, int indexY) {
    String edges = "";
    
    // check to see what blocks are surrounding this one
    if (indexY > 1) {
      edges = edges + ((blocks[indexX][indexY - 1] != null) ? "1": "0");
    } else {
      edges = edges + "0";
    }
    if (indexX < blocks[0].length - 1) {
      edges = edges + ((blocks[indexX + 1][indexY] != null) ? "1": "0");
    } else {
      edges = edges + "0";
    }
    if (indexY < blocks.length - 1) {
      edges = edges + ((blocks[indexX][indexY + 1] != null) ? "1": "0");
    } else {
      edges = edges + "0";
    }
    if (indexX > 1) {
      edges = edges + ((blocks[indexX - 1][indexY] != null) ? "1": "0");
    } else {
      edges = edges + "0";
    }
  
    return edges;
  }
  
  Block newBlock() {
    return new Block(x, y, hp, damageMultiplier, sprites);
  }
}

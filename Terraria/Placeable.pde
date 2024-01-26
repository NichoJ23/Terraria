class Placeable extends Tool {
  Block block;
  
  Placeable(int useTime, Block _block) {
    super(useTime, 0, 0, 0, _block.sprites.get("0000"));
    
    block = _block;
  }
  
  void place(int x, int y) {
    Block b = block.newBlock();
    b.setPosition(x * tileSize, y * tileSize);
    b.arrayX = x;
    b.arrayY = y;
    
    world.add(b);
    blocks[x][y] = b;
    
    b.reEvaluateEdges();
    
    if (x > 0) {
      Block tempBlock = blocks[x - 1][y];
      if (tempBlock != null) {
        tempBlock.reEvaluateEdges();
      }
    }
    if (x < blocks[0].length - 1) {
      Block tempBlock = blocks[x + 1][y];
      if (tempBlock != null) {
        tempBlock.reEvaluateEdges();
      }
    }
    if (y > 0) {
      Block tempBlock = blocks[x][y - 1];
      if (tempBlock != null) {
        tempBlock.reEvaluateEdges();
      }
    }
    if (y < blocks.length - 1) {
      Block tempBlock = blocks[x][y + 1];
      if (tempBlock != null) {
        tempBlock.reEvaluateEdges();
      }
    }
  }
}

enum BlockTypes {DIRT, STONE};

class Block extends FBox{
  int hp;
  BlockTypes type;
  
  Block(int x, int y) {
    super(tileSize, tileSize);
    setPosition(x, y);
    setGrabbable(false);
    setStatic(true);
  }
}

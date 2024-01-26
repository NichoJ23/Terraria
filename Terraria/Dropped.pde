class Dropped extends FBox {
  int stacks;
  ItemTypes type;
  PImage image;
  
  Dropped(int w, int h, int x, int y, int _stacks, ItemTypes _type, PImage _image) {
    super(w, h);
    setPosition(x, y);
    setGrabbable(false);
    setName("dropped");
    attachImage(_image);
    
    stacks = _stacks;
    type = _type;
    image = _image;
  }
  
  void update() {
    float myX = getX();
    float myY = getY();
    float playerX = player.getX();
    float playerY = player.getY();
    
    // If withing the player's pickup range, start flying to them
    if (dist(myX, myY, playerX, playerY) < player.pickupRange * tileSize) {
      PVector attraction = PVector.sub(new PVector(playerX, playerY), new PVector(myX, myY));
      attraction.normalize();
      attraction.mult(40);
      
      setVelocity(attraction.x, attraction.y);
    }
    
    if (touchingBlock(this, "player") != null) {
      
    }
  }
}

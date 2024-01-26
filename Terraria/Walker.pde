class Walker extends Enemy {
  FBox groundCollider;
  FBox downLeftCollider;
  FBox middleLeftCollider;
  FBox downRightCollider;
  FBox middleRightCollider;
  
  boolean facingRight;
  int speed;
  boolean canJump;
  
  PImage[] walkLeft;
  PImage[] walkRight;
  long animStart;
  int currentFrame;
  int FPS;
  
  Walker(int x, int y, int w, int h, int maxHealth, int defense, int kbResist, int contactDamage, int coinsDropped, int _speed, boolean _canJump, PImage[] _walkRight, PImage[] _walkLeft) {
    super(x, y, w, h, maxHealth, defense, kbResist, contactDamage, coinsDropped);
    
    speed = _speed;
    canJump = _canJump;
    
    walkRight = _walkRight;
    walkLeft = _walkLeft;
    FPS = 12;
    animStart = System.currentTimeMillis();
    
    groundCollider = new FBox(getWidth() - 2, 2);
    groundCollider.setSensor(true);
    groundCollider.setNoFill();
    groundCollider.setNoStroke();
    groundCollider.setName("enemy bottom");
    
    downLeftCollider = new FBox(2, 2);
    downLeftCollider.setSensor(true);
    downLeftCollider.setNoFill();
    downLeftCollider.setNoStroke();
    downLeftCollider.setName("enemy down left");
    
    downRightCollider = new FBox(2, 2);
    downRightCollider.setSensor(true);
    downRightCollider.setNoFill();
    downRightCollider.setNoStroke();
    downRightCollider.setName("enemy down right");
    
    middleLeftCollider = new FBox(2, 2);
    middleLeftCollider.setSensor(true);
    middleLeftCollider.setNoFill();
    middleLeftCollider.setNoStroke();
    middleLeftCollider.setName("enemy middle left");
    
    middleRightCollider = new FBox(2, 2);
    middleRightCollider.setSensor(true);
    middleRightCollider.setNoFill();
    middleRightCollider.setNoStroke();
    middleRightCollider.setName("enemy middle right");
    
    world.add(groundCollider);
    world.add(downLeftCollider);
    world.add(middleLeftCollider);
    world.add(downRightCollider);
    world.add(middleRightCollider);
  }
  
  void walk() {
    // If we run into a 1 block high ledge, skip to the top of it
    checkForStairs();
    
    // Can't walk if stunned
    if (isStunned) return;
    
    // Position colliders
    groundCollider.setPosition(getX(), getY() + tileSize*3/2);
    downLeftCollider.setPosition(getX() - tileSize, getY() + tileSize);
    middleLeftCollider.setPosition(getX() - tileSize, getY());
    downRightCollider.setPosition(getX() + tileSize, getY() + tileSize);
    middleRightCollider.setPosition(getX() + tileSize, getY());
    
    facingRight = player.getX() > getX();
    
    float vy = getVelocityY();
    if (facingRight) {
      setVelocity(speed, vy);
    } else {
      setVelocity(-speed, vy);
    }
    
    
    
    checkForWall();
  }
  
  void show() {
    if (isStunned) return;
    
    PImage[] currentFrames;
    if (facingRight) {
      currentFrames = zombieWalkRight;
    } else {
      currentFrames = zombieWalkLeft;
    }
    
    float animLength = 1f / FPS * currentFrames.length;
    float timePassed = (System.currentTimeMillis() - animStart) / 1000f;
    float animPercent = (timePassed % animLength) / animLength;
  
    PImage currentFrame = currentFrames[(int)(animPercent * currentFrames.length)];
    
    attachImage(currentFrame);
  }
  
  void checkForStairs() {
    // Can't skip if not on ground (to avoid increasing jump height to and extra block)
    if (touchingBlock(groundCollider, "ground") == null) return;
    
    float vx = getVelocityX();
    if (vx < 0) {
      // If bottom left collider is touching a block but middle left isn't, we know it's a 1 block tall ledge and jump over it
      // Slight number tweaks just to make sure everything runs smoothly
      if (touchingBlock(downLeftCollider, "ground") != null && touchingBlock(middleLeftCollider, "ground") == null) {
        setPosition(getX() - 2, getY() - tileSize - 1);
      }
    } else if (vx > 0) {
      // If bottom right collider is touching a block but middle right isn't, we know it's a 1 block tall ledge and jump over it
      if (touchingBlock(downRightCollider, "ground") != null && touchingBlock(middleRightCollider, "ground") == null) {
        setPosition(getX() + 2, getY() - tileSize - 1);
      }
    }
  }
  
  void checkForWall() {
    // Can't jump if not touching ground
    if (touchingBlock(groundCollider, "ground") == null) return;
    
    float vx = getVelocityX();
    if (vx < 0) {
      // If bottom left collider is touching a block but middle left isn't, we know it's a 1 block tall ledge and jump over it
      // Slight number tweaks just to make sure everything runs smoothly
      if (touchingBlock(middleLeftCollider, "ground") != null) {
        setVelocity(vx, -330);
      }
    } else if (vx > 0) {
      // If bottom right collider is touching a block but middle right isn't, we know it's a 1 block tall ledge and jump over it
      if (touchingBlock(middleRightCollider, "ground") != null) {
        setVelocity(vx, -330);
      }
    }
  }
}

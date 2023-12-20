class Walker extends Enemy {
  boolean facingRight;
  int speed;
  
  boolean canJump;
  
  PImage[] walkLeft;
  PImage[] walkRight;
  long animStart;
  int currentFrame;
  int FPS;
  
  Walker(int x, int y, int w, int h, int maxHealth, int defense, int contactDamage, int coinsDropped, int _speed, boolean _canJump, PImage[] _walkRight, PImage[] _walkLeft) {
    super(x, y, w, h, maxHealth, defense, contactDamage, coinsDropped);
    
    speed = _speed;
    canJump = _canJump;
    
    walkRight = _walkRight;
    walkLeft = _walkLeft;
    FPS = 12;
    animStart = System.currentTimeMillis();
  }
  
  void walk() {
    facingRight = player.getX() > getX();
    
    float vy = getVelocityY();
    if (facingRight) {
      setVelocity(speed, vy);
    } else {
      setVelocity(-speed, vy);
    }
  }
  
  void show() {
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
}

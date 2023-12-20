enum PlayerStates {IDLE, WALK, JUMP};

class Player extends FBox {
  FBox groundCollider;
  FBox swordCollider;
  
  int currentHealth;
  int maxHealth;
  
  int speed;
  
  boolean facingRight;
  boolean isSwinging;
  
  long animStart;
  int currentFrame;
  int FPS;
  
  boolean swingReady;
  long swingStart;
  long swingEnd;
  Weapon currentTool;
  
  PlayerStates animState;
  
  Player(int x, int  y) {
    super(tileSize * 1.5, tileSize * 3);
    setName("player");
    setGrabbable(false);
    setPosition(x, y);
    
    setRotatable(false);
    setDensity(0.2);
    setRestitution(0);
    setFriction(0);
    
    groundCollider = new FBox(getWidth() - 2, 2);
    groundCollider.setSensor(true);
    groundCollider.setNoFill();
    groundCollider.setNoStroke();
    groundCollider.setName("player bottom");
    
    world.add(groundCollider);
    
    currentHealth = maxHealth = 100;
    
    speed = 75;
    
    FPS = 12;
    animStart = System.currentTimeMillis();
    
    currentTool = weapons.get("Wooden Sword");
    swingReady = true;
  }
  
  void update() {
    groundCollider.setPosition(getX(), getY() + tileSize*3/2);
    handleInput();
    
    if (isSwinging) {
      float animLength = currentTool.useTime / 60f;
      float swingTimePassed = (System.currentTimeMillis() - swingStart) / 1000f;
      
      if (swingTimePassed > animLength) {
        isSwinging = false;
        swingEnd = System.currentTimeMillis();
      }
    } else if (!swingReady) {
      if ((System.currentTimeMillis() - swingEnd) / 1000f > currentTool.useTime / 60f) {
        swingReady = true;
      }
    }
    
    animate();
  }
  
  void handleInput() {
    float vY = getVelocityY();
    float setVX = 0;
    
    if (leftKey || aKey) setVX -= speed;
    if (rightKey || dKey) setVX += speed;
    
    setVelocity(setVX, vY);
    
    if ((upKey || wKey) && touchingBlock(groundCollider, "ground") != null) {
      setVelocity(getVelocityX(), -330);
    }
  }
  
  void animate() {
    float vx = getVelocityX();
    if (vx != 0) {
      facingRight = vx > 0;
    }
        
    if (touchingBlock(groundCollider, "ground") == null) {
      if (animState != PlayerStates.JUMP) {
        animState = PlayerStates.JUMP;
        animStart = System.currentTimeMillis();
      }
    } else if (vx != 0) {
      if (animState != PlayerStates.WALK) {
        animState = PlayerStates.WALK;
        animStart = System.currentTimeMillis();
        
        facingRight = vx > 0;
      }
    } else {
      animState = PlayerStates.IDLE;
    }
    
    boolean torsoAnimating = true;
    boolean legsAnimating = true;
    PImage[] torsoFrames = new PImage[0];
    PImage[] legsFrames = new PImage[0];
    
    PGraphics playerImg = createGraphics(100, 100);
    switch (animState) {
      case IDLE:
        legsAnimating = false;
        
        playerImg.beginDraw();
        playerImg.imageMode(CENTER);
        playerImg.pushMatrix();
        playerImg.translate(playerImg.width/2, playerImg.height/2);
        
        if (facingRight) {
          if (isSwinging) {
            torsoFrames = torsoSwingRight;
          } else {
            playerImg.image(torsoRight, 0, 0);
            torsoAnimating = false;
          }
          
          playerImg.image(legsRight, 0, 0);
        } else {
          if (isSwinging) {
            torsoFrames = torsoSwingLeft;
          } else {
            playerImg.image(torsoLeft, 0, 0);
            torsoAnimating = false;
          }
          
          playerImg.image(legsLeft, 0, 0);
        }
        
        playerImg.popMatrix();
        playerImg.endDraw();
        break;
      case WALK:
        if (facingRight) {
          if (isSwinging) {
            torsoFrames = torsoSwingRight;
          } else {
            torsoFrames = torsoWalkRight;
          }
          
          legsFrames = legsWalkRight;
        } else {
          if (isSwinging) {
            torsoFrames = torsoSwingLeft;
          } else {
            torsoFrames = torsoWalkLeft;
          }
          
          legsFrames = legsWalkLeft;
        }
        break;
      case JUMP:
        legsAnimating = false;
        
        playerImg.beginDraw();
        playerImg.imageMode(CENTER);
        playerImg.pushMatrix();
        playerImg.translate(playerImg.width/2, playerImg.height/2);
        
        if (facingRight) {
          if (isSwinging) {
            torsoFrames = torsoSwingRight;
          } else {
            playerImg.image(torsoJumpRight, 0, 0);
            torsoAnimating = false;
          }
          
          playerImg.image(legsJumpRight, 0, 0);
        } else {
          if (isSwinging) {
            torsoFrames = torsoSwingLeft;
          } else {
            playerImg.image(torsoJumpLeft, 0, 0);
            torsoAnimating = false;
          }
          
          playerImg.image(legsJumpLeft, 0, 0);
        }
        
        playerImg.popMatrix();
        playerImg.endDraw();
        break;
      default:
        println("State " + animState + " is not a valid player animation state");
        break;
    }
    
    playerImg.beginDraw();
    playerImg.imageMode(CENTER);
    playerImg.pushMatrix();
    playerImg.translate(playerImg.width/2, playerImg.height/2);
    
    if (facingRight) {
      playerImg.image(headRight, 0, 0);
    } else {
      playerImg.image(headLeft, 0, 0);
    }
    
    float timePassed = (System.currentTimeMillis() - animStart) / 1000f;
    
    if (torsoAnimating) {
      if (isSwinging) {
        float animLength = currentTool.useTime / 60f;
        float swingTimePassed = (System.currentTimeMillis() - swingStart) / 1000f;
        float animPercent = (swingTimePassed % animLength) / animLength;
        
        PImage currentFrame = torsoFrames[(int)(animPercent * torsoFrames.length)];
        
        float toolAngle = -QUARTER_PI;
        if (facingRight) {
          toolAngle -= PI/6;
          
          toolAngle += animPercent * 5/6 * PI;
        } else {
          toolAngle += PI/6;
          
          toolAngle -= animPercent * 5/6 * PI;
        }
        
        playerImg.pushMatrix();
        playerImg.rotate(toolAngle);
        playerImg.translate(currentTool.image.width / 2, -currentTool.image.height / 2);
        
        playerImg.image(currentTool.image, 0, 0);
        fill(255, 0, 0);
        playerImg.rect(0, 100, 20, 0);
        
        playerImg.popMatrix();
        
        playerImg.image(currentFrame, 0, 0);
      } else {
        float animLength = 1f / FPS * torsoFrames.length;
        float animPercent = (timePassed % animLength) / animLength;
      
        PImage currentFrame = torsoFrames[(int)(animPercent * torsoFrames.length)];
        
        playerImg.image(currentFrame, 0, 0);
      }
    }
    
    if (legsAnimating) {
      float animLength = 1f / FPS * legsFrames.length;
      float animPercent = (timePassed % animLength) / animLength;
    
      PImage currentFrame = legsFrames[(int)(animPercent * legsFrames.length)];
      
      playerImg.image(currentFrame, 0, 0);
    }
    
    playerImg.popMatrix();
    playerImg.endDraw();
    imageMode(CORNER);
    
    attachImage(playerImg);
  }
  
  void takeDamage(int damage, PVector origin) {
    currentHealth -= damage;
    
    PVector knockBack = PVector.sub(new PVector(getX(), getY()), origin);
    knockBack.normalize();
    knockBack.mult(50);
    
    float vx = getVelocityX();
    float vy = getVelocityY();
    setVelocity(vx + knockBack.x, vy + knockBack.y);
  }
  
  void reset() {
    setPosition(65, 215);
    setVelocity(0, 0);
    setRotation(0);
    setAngularVelocity(0);
  }
}

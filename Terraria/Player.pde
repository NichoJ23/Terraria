enum PlayerStates {IDLE, WALK, JUMP};

class Player extends FBox {
  FBox groundCollider;
  FBox downLeftCollider;
  FBox middleLeftCollider;
  FBox downRightCollider;
  FBox middleRightCollider;
  FBox topCollider;
  FBox swordCollider;
  
  Inventory inventory;
  
  int currentHealth;
  int maxHealth;
  
  int coins;
  
  int speed;
  int damageMult;
  
  float pickupRange; // Pickup range in terms of blocks
  
  float stunDuration;
  float invincibleDuration;
  
  boolean facingRight;
  boolean swingRight;
  boolean isSwinging;
  boolean isMining;
  boolean isStunned;
  boolean isInvincible;
  
  long stunEnd;
  long invincibleEnd;
  
  long animStart;
  int currentFrame;
  int FPS;
  
  boolean swingReady;
  boolean mineReady;
  long swingStart;
  long swingEnd;
  long nextMine;
  
  Tool currentTool;
  
  ArrayList<Enemy> alreadyHit;
  
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
    
    downLeftCollider = new FBox(2, 2);
    downLeftCollider.setSensor(true);
    downLeftCollider.setNoFill();
    downLeftCollider.setNoStroke();
    downLeftCollider.setName("player down left");
    
    downRightCollider = new FBox(2, 2);
    downRightCollider.setSensor(true);
    downRightCollider.setNoFill();
    downRightCollider.setNoStroke();
    downRightCollider.setName("player down right");
    
    middleLeftCollider = new FBox(2, 2);
    middleLeftCollider.setSensor(true);
    middleLeftCollider.setNoFill();
    middleLeftCollider.setNoStroke();
    middleLeftCollider.setName("player middle left");
    
    middleRightCollider = new FBox(2, 2);
    middleRightCollider.setSensor(true);
    middleRightCollider.setNoFill();
    middleRightCollider.setNoStroke();
    middleRightCollider.setName("player middle right");
    
    topCollider = new FBox(2, 2);
    topCollider.setSensor(true);
    topCollider.setNoFill();
    topCollider.setNoStroke();
    topCollider.setName("player top");
    
    world.add(groundCollider);
    world.add(downLeftCollider);
    world.add(middleLeftCollider);
    world.add(downRightCollider);
    world.add(middleRightCollider);
    
    inventory = new Inventory(40);
    
    currentHealth = maxHealth = 100;
    
    speed = 75;
    damageMult = 1;
    
    stunDuration = 0.25;
    invincibleDuration = 0.5;
    
    FPS = 12;
    animStart = System.currentTimeMillis();
    
    currentTool = weapons.get("Wood Block");
    swingReady = true;
  }
  
  void update() {
    // Check to see if effects have expired
    long time = System.currentTimeMillis();
    if (isStunned && time > stunEnd) {
      isStunned = false;
    }
    if (isInvincible && time > invincibleEnd) {
      isInvincible = false;
    }
    if (mineReady == false && time > nextMine) {
      mineReady = true;
    }
    
    // Position colliders
    groundCollider.setPosition(getX(), getY() + tileSize*3/2);
    downLeftCollider.setPosition(getX() - tileSize, getY() + tileSize);
    middleLeftCollider.setPosition(getX() - tileSize, getY());
    downRightCollider.setPosition(getX() + tileSize, getY() + tileSize);
    middleRightCollider.setPosition(getX() + tileSize, getY());
    
    handleInput();
    
    // When coming into contact with a 1 block tall ledge, jump to top of it so player can keep running
    checkForStairs();
    
    if (isSwinging) {
      float swingLength = currentTool.useTime / 60f;
      float swingTimePassed = (System.currentTimeMillis() - swingStart) / 1000f;
      float swingPercent = swingTimePassed / swingLength;
      float swordLength = 0;
      
      if (swordCollider != null) {
        swordLength = swordCollider.getHeight();
      }
      
      if (currentTool instanceof Pickaxe && mineReady && mousePressed) {
        attemptMine(mouseX, mouseY);
        // Next time we can mine is determined by mine cooldown (multiply by 10 to convert from centiseconds to milliseconds)
        nextMine = System.currentTimeMillis() + (int)(((Pickaxe)currentTool).mineSpeed/60f * 1000);
        mineReady = false;
      }
      
      // If the timer for the swing is up, stop swing
      if (swingTimePassed > swingLength) {
        isSwinging = false;
        swingEnd = System.currentTimeMillis();
        
        if (swordCollider != null) {
          // Remove sword collider from world so it won't interact with anything
          world.remove(swordCollider);
          swordCollider = null;
        }
      }
      
      if (swordCollider != null) {
        // Calculate angle the tool is at
        float toolAngle = 0;
        if (swingRight) {
          toolAngle -= PI/6;
          
          toolAngle += swingPercent * 5/6 * PI;
        } else {
          toolAngle += PI/6;
          
          toolAngle -= swingPercent * 5/6 * PI;
        }
        
        swordCollider.setRotation(toolAngle);
      
        // Sword needs to be relocated every frame to player's position (i don't know how parents/children work in fisica)
        // Rotation happens around centre of rect, so need to offset position so it pivots around hilt
        PVector positionOffset = new PVector(cos(HALF_PI - toolAngle) * swordLength, -sin(HALF_PI - toolAngle) * swordLength);
        swordCollider.setPosition(player.getX() + positionOffset.x, player.getY() + positionOffset.y);
        
        //Check if sword hits an enemy. If so, call their takeDamage function
        ArrayList<FBody> enemies = touchingBodies(swordCollider, "enemy");
        for (FBody f: enemies) {
          Enemy e = (Enemy)f;
          
          // Check if we have hit this enemy before
          if (!alreadyHit.contains(e)) {
            e.takeDamage(calculateDamage(), currentTool.knockBack, new PVector(getX(), getY()));
            alreadyHit.add(e);
          }
        }
      } else if (currentTool instanceof Placeable) {
        // Reusing mineReady for block placement
        if (mineReady && mousePressed) {
          attemptPlace(mouseX, mouseY);
          
          nextMine = System.currentTimeMillis() + (int)(((Placeable)currentTool).useTime/60f * 1000);
          mineReady = true;
        }
      }
    } else if (!swingReady) {
      // Player can again swing once the weapon's cooldown has passed
      if (currentTool instanceof Pickaxe) {
        swingReady = true;
      } else {
        if ((System.currentTimeMillis() - swingEnd) / 1000f > currentTool.useTime / 60f) {
          swingReady = true;
        }
      }
    }
    
    animate();
  }
  
  void handleInput() {
    if (!isStunned) {
      float vY = getVelocityY();
      float setVX = 0;
      
      if (leftKey || aKey) setVX -= speed;
      if (rightKey || dKey) setVX += speed;
      
      setVelocity(setVX, vY);
      
      if ((upKey || wKey) && touchingBlock(groundCollider, "ground") != null) {
        setVelocity(getVelocityX(), -330);
      }
    }
    
    if (mousePressed && swingReady && currentTool != null) {
      startSwing();
    }
  }
  
  void animate() {
    
    float vx = getVelocityX();
    if (vx != 0) {
      facingRight = vx > 0;
    }
    
    // Don't animate if stunned. Will be staying in airborne frame
    if (!isStunned) {
      if (touchingBlock(groundCollider, "ground") == null) {
        if (animState != PlayerStates.JUMP) {
          animState = PlayerStates.JUMP;
          animStart = System.currentTimeMillis();
        }
      } else if (vx != 0) {
        if (animState != PlayerStates.WALK) {
          animState = PlayerStates.WALK;
          animStart = System.currentTimeMillis();
          
        }
      } else {
        animState = PlayerStates.IDLE;
      }
    } else {
      // When stunned, will be moving one way while facing the other
      facingRight = !facingRight;
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
        
        if (isSwinging) {
          if (swingRight) {
            torsoFrames = torsoSwingRight;
            playerImg.image(legsRight, 0, 0);
          } else {
            torsoFrames = torsoSwingLeft;
            playerImg.image(legsLeft, 0, 0);
          }
          
        } else {
          if (facingRight) {
            
            playerImg.image(torsoRight, 0, 0);
            torsoAnimating = false;
            
            playerImg.image(legsRight, 0, 0);
          } else {
            
            playerImg.image(torsoLeft, 0, 0);
            torsoAnimating = false;
            
            playerImg.image(legsLeft, 0, 0);
          }
        }
        
        playerImg.popMatrix();
        playerImg.endDraw();
        break;
      case WALK:
        if (isSwinging) {
          if (swingRight) {
            torsoFrames = torsoSwingRight;
            legsFrames = legsWalkRight;
          } else {
            torsoFrames = torsoSwingLeft;
            legsFrames = legsWalkLeft;
          }
        } else {
          if (facingRight) {
            torsoFrames = torsoWalkRight;
            legsFrames = legsWalkRight;
          } else {
            torsoFrames = torsoWalkLeft;
            legsFrames = legsWalkLeft;
          }
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
    
    // Player bobs as they walk. Will need to use chest animation to figure out if player is on an UP frame
    int headOffset = 0;
    
    
    float timePassed = (System.currentTimeMillis() - animStart) / 1000f;
    
    if (torsoAnimating) {
      if (isSwinging) {
        float animLength = currentTool.useTime / 60f;
        float swingTimePassed = (System.currentTimeMillis() - swingStart) / 1000f;
        float animPercent = (swingTimePassed % animLength) / animLength;
        
        PImage currentFrame = torsoFrames[(int)(animPercent * torsoFrames.length)];
        
        float toolAngle = -QUARTER_PI;
        if (swingRight) {
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
        // Calculate how far we are into the animation and choose which frame we are on
        float animLength = 1f / FPS * torsoFrames.length;
        float animPercent = (timePassed % animLength) / animLength;

        int frameIndex = (int)(animPercent * torsoFrames.length);
        PImage currentFrame = torsoFrames[frameIndex];
        
        playerImg.image(currentFrame, 0, 0);
        
        // DOWN frames are on frame 1 & 3. All others are up
        if (frameIndex % 3 != 0) {
          headOffset = -1;
        }
      }
    }
    
    if (legsAnimating) {
      float animLength = 1f / FPS * legsFrames.length;
      float animPercent = (timePassed % animLength) / animLength;
    
      PImage currentFrame;
      if (!isSwinging || swingRight == facingRight) {
        currentFrame = legsFrames[(int)(animPercent * legsFrames.length)];
      } else {
        currentFrame = legsFrames[legsFrames.length - 1 - (int)(animPercent * legsFrames.length)];
      }
      
      
      playerImg.image(currentFrame, 0, 0);
    }
    
    if (isSwinging) {
      if (swingRight) {
        playerImg.image(headRight, 0, headOffset);
      } else {
        playerImg.image(headLeft, 0, headOffset);
      }
    } else {
      if (facingRight) {
        playerImg.image(headRight, 0, headOffset);
      } else {
        playerImg.image(headLeft, 0, headOffset);
      }
    }
    
    playerImg.popMatrix();
    playerImg.endDraw();
    imageMode(CORNER);
    
    attachImage(playerImg);
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
  
  void startSwing() {
    isSwinging = true;
    swingStart = System.currentTimeMillis();
    swingReady = false;
    // Weapon swings in same direction even if player turns around during swing
    if (mouseX > width/2) {
      swingRight = true;
      facingRight = true;
    } else {
      swingRight = false;
      facingRight = false;
    }
    
    if (currentTool instanceof Sword) {
      // Use pythagorean to get length of sword
      float swordLength = sqrt(currentTool.image.width*currentTool.image.width + currentTool.image.height*currentTool.image.height);
      swordLength *= 0.67;
      
      swordCollider = new FBox(10, swordLength);
      
      swordCollider.setSensor(true);
      swordCollider.setNoFill();
      swordCollider.setNoStroke();
      swordCollider.setName("sword collider");
      
      world.add(swordCollider);
      
      alreadyHit = new ArrayList<Enemy>();
    } else if (currentTool instanceof Pickaxe) {
      // Use pythagorean to get length of sword
      float pickaxeLength = sqrt(currentTool.image.width*currentTool.image.width + currentTool.image.height*currentTool.image.height);
      pickaxeLength *= 0.6;
      
      swordCollider = new FBox(25, pickaxeLength);
      
      swordCollider.setSensor(true);
      swordCollider.setNoFill();
      swordCollider.setNoStroke();
      swordCollider.setName("sword collider");
      
      world.add(swordCollider);
      
      alreadyHit = new ArrayList<Enemy>();
    }
  }
  
  void takeDamage(int damage, PVector origin) {
    if (isInvincible) return; // Can't be hit again during I-frames (short period of time after being hit)
    
    currentHealth -= damage;
    
    PVector knockBack;
    // Knock player back at 45 degree angle
    // Check which direction enemy is in
    if (origin.x - getX() > 0) {
      knockBack = new PVector(-1, -1);
    } else {
      knockBack = new PVector(1, -1);
    }
    // Set the magnitude of the knockback
    knockBack.mult(100);
    
    // Set player's velocity to knockback
    setVelocity(knockBack.x, knockBack.y);
    
    // Flag the player as stunned so they can't move and invincible so they can't get hit on repeat
    isStunned = true;
    isInvincible = true;
    
    // Set the duration of both the stun and i-frames;
    long time = System.currentTimeMillis();
    stunEnd = time + (long)round(stunDuration * 1000);
    invincibleEnd = time + (long)round(invincibleDuration * 1000);
    
    // Set the animation state to jumping so will be in airborne animation while stunned
    animState = PlayerStates.JUMP;
  }
  
  void attemptMine(int x, int y) {
    // Can only mine if we have a pickaxe
    if (currentTool instanceof Pickaxe) {
      // Get the block at the mouse's position
      Block block = (Block)getBlockAt(getWorldCoords(x, y));
      // Check to see if the block exists
      if (block == null) return;
      
      // Check to see if block is too far away
      if (dist(getX(), getY(), block.getX(), block.getY()) > 65) return;
      
      // Damage the block
      block.takeDamage(((Pickaxe)currentTool).power);
    }
  }
  
  void attemptPlace(int x, int y) {
    // Can only mine if we have a pickaxe
    if (currentTool instanceof Placeable) {
      Placeable tool = (Placeable)currentTool;
      PVector worldCoords = getWorldCoords(x, y);
      PVector worldIndex = getWorldIndex(worldCoords);
      PVector blockCoords = new PVector(worldIndex.x * tileSize, worldIndex.y * tileSize);
      int playerX = (int)getX();
      int playerY = (int)getY();
      int playerWidth = (int)getWidth();
      int playerHeight = (int)getHeight();
      
      // Get the block at the mouse's position
      Block block = (Block)getBlockAt(getWorldCoords(x, y));
      // Check to see if there is already a block there
      if (block != null) return;
      
      // Check to see if block is too far away
      if (dist(playerX, playerY, worldCoords.x, worldCoords.y) > 65) return;
      
      Block testBlock = newDirtBlock();
      String edges = testBlock.getEdges((int)worldIndex.x, (int)worldIndex.y);
      
      // check if adjacent to another block. Can only build off other blocks, can't place mid-air
      if (!edges.contains("1")) return;
      
      if (playerX + playerWidth/2f > blockCoords.x - tileSize/2f && playerX - playerWidth/2f < blockCoords.x + tileSize/2f && playerY + playerHeight/2f > blockCoords.y - tileSize/2f && playerY - playerHeight/2f < blockCoords.y + tileSize/2f) {
        return;
      }
      
      // Place the block
      tool.place((int)worldIndex.x, (int)worldIndex.y);
    }
  }
  
  int calculateDamage() {
    if (currentTool instanceof Tool) {
      return currentTool.damage * damageMult;
    }
    
    // Do no damage if we what we're holding isn't a weapon
    return 0;
  }
  
  void reset() {
    setPosition(65, 215);
    setVelocity(0, 0);
    setRotation(0);
    setAngularVelocity(0);
  }
}

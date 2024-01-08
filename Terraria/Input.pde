void mousePressed() {
  println(mouseX, mouseY);
  
  if (player.swingReady && player.currentTool != null) {
    player.isSwinging = true;
    player.swingStart = System.currentTimeMillis();
    player.swingReady = false;
    // Weapon swings in same direction even if player turns around during swing
    if (mouseX > player.getX()) {
      player.swingRight = true;
      player.facingRight = true;
    } else {
      player.swingRight = false;
      player.facingRight = false;
    }
  }
}

void keyPressed() {
  switch (keyCode) {
    case UP:
      upKey = true;
      break;
    case LEFT:
      leftKey = true;
      break;
    case RIGHT:
      rightKey = true;
      break;
  }
  
  switch (key) {
    case 'w':
      wKey = true;
      break;
    case 'a':
      aKey = true;
      break;
    case 'd':
      dKey = true;
      break;
  }
}

void keyReleased() {
  switch (keyCode) {
    case UP:
      upKey = false;
      break;
    case LEFT:
      leftKey = false;
      break;
    case RIGHT:
      rightKey = false;
      break;
  }
  
  switch (key) {
    case 'w':
      wKey = false;
      break;
    case 'a':
      aKey = false;
      break;
    case 'd':
      dKey = false;
      break;
  }
}

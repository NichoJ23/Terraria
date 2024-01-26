void mousePressed() {
  println(mouseX, mouseY);
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
    case '1':
      player.currentTool = weapons.get("Wooden Sword");
      break;
    case '2':
      player.currentTool = weapons.get("Copper Pickaxe");
      break;
    case '3':
      player.currentTool = weapons.get("Dirt Block");
      break;
    case '4':
      player.currentTool = weapons.get("Stone Block");
      break;
    case '5':
      player.currentTool = weapons.get("Wood Block");
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

// For Photopea, set blend mode on brush to Dissolve, and set mode on eraser to Pencil Tool

void setupImages() {
  long t = System.currentTimeMillis();
  map = loadImage("Terraria Demo Map.png");
  dirt = loadImage("Dirt_5_1.png");
  dirt.resize(tileSize, tileSize);
  woodenSword = loadImage("Swingables/Wooden_Sword.png");
  //woodenSword.resize(tileSize * 3/2, tileSize * 3/2);
  headRight = loadImage("Player/Hair1_02.png");
  headRight.resize(25, 30);
  headLeft = reverseImage(headRight);
  torsoRight = loadImage("Player/Shirt_02.png");
  torsoRight.resize(25, 30);
  torsoLeft = reverseImage(torsoRight);
  torsoJumpRight = loadImage("Player/Shirt_12.png");
  torsoJumpRight.resize(25, 30);
  torsoJumpLeft = reverseImage(torsoJumpRight);
  legsRight = loadImage("Player/Pants_02.png");
  legsRight.resize(25, 30);
  legsLeft = reverseImage(legsRight);
  legsJumpRight = loadImage("Player/Pants_12.png");
  legsJumpRight.resize(25, 30);
  legsJumpLeft = reverseImage(legsJumpRight);
  
  torsoWalkRight = new PImage[5];
  torsoWalkRight[0] = loadImage("Player/Shirt_14.png");
  torsoWalkRight[0].resize(25, 30);
  torsoWalkRight[1] = loadImage("Player/Shirt_16.png");
  torsoWalkRight[1].resize(25, 30);
  torsoWalkRight[2] = loadImage("Player/Shirt_20.png");
  torsoWalkRight[2].resize(25, 30);
  torsoWalkRight[3] = loadImage("Player/Shirt_22.png");
  torsoWalkRight[3].resize(25, 30);
  torsoWalkRight[4] = loadImage("Player/Shirt_24.png");
  torsoWalkRight[4].resize(25, 30);
  
  torsoWalkLeft = new PImage[5];
  for (int i = 0; i < torsoWalkLeft.length; i++) {
    torsoWalkLeft[i] = reverseImage(torsoWalkRight[i]);
  }
  
  torsoSwingRight = new PImage[4];
  torsoSwingRight[0] = loadImage("Player/Shirt_04.png");
  torsoSwingRight[0].resize(25, 30);
  torsoSwingRight[1] = loadImage("Player/Shirt_06.png");
  torsoSwingRight[1].resize(25, 30);
  torsoSwingRight[2] = loadImage("Player/Shirt_08.png");
  torsoSwingRight[2].resize(25, 30);
  torsoSwingRight[3] = loadImage("Player/Shirt_10.png");
  torsoSwingRight[3].resize(25, 30);
  
  torsoSwingLeft = new PImage[4];
  for (int i = 0; i < torsoSwingLeft.length; i++) {
    torsoSwingLeft[i] = reverseImage(torsoSwingRight[i]);
  }
  
  legsWalkRight = new PImage[6];
  legsWalkRight[0] = loadImage("Player/Pants_14.png");
  legsWalkRight[0].resize(25, 30);
  legsWalkRight[1] = loadImage("Player/Pants_16.png");
  legsWalkRight[1].resize(25, 30);
  legsWalkRight[2] = loadImage("Player/Pants_18.png");
  legsWalkRight[2].resize(25, 30);
  legsWalkRight[3] = loadImage("Player/Pants_20.png");
  legsWalkRight[3].resize(25, 30);
  legsWalkRight[4] = loadImage("Player/Pants_22.png");
  legsWalkRight[4].resize(25, 30);
  legsWalkRight[5] = loadImage("Player/Pants_24.png");
  legsWalkRight[5].resize(25, 30);
  
  legsWalkLeft = new PImage[6];
  for (int i = 0; i < legsWalkLeft.length; i++) {
    legsWalkLeft[i] = reverseImage(legsWalkRight[i]);
  }
  
  zombieWalkRight = new PImage[4];
  zombieWalkRight[0] = loadImage("Enemies/Zombie1.png");
  zombieWalkRight[0].resize(25, 30);
  zombieWalkRight[1] = loadImage("Enemies/Zombie2.png");
  zombieWalkRight[1].resize(25, 30);
  zombieWalkRight[2] = loadImage("Enemies/Zombie3.png");
  zombieWalkRight[2].resize(25, 30);
  zombieWalkRight[3] = loadImage("Enemies/Zombie4.png");
  zombieWalkRight[3].resize(25, 30);
  
  zombieWalkLeft = new PImage[4];
  for (int i = 0; i < zombieWalkRight.length; i++) {
    zombieWalkLeft[i] = reverseImage(zombieWalkRight[i]);
  }
  
  grass = new HashMap<String, PImage>();
  PImage temp = loadImage("Grass/Grass_0000.png");
  temp.resize(tileSize, tileSize);
  grass.put("0000", temp);
  temp = loadImage("Grass/Grass_000x.png");
  temp.resize(tileSize, tileSize);
  grass.put("1000", temp);
  temp = loadImage("Grass/Grass_00x0.png");
  temp.resize(tileSize, tileSize);
  grass.put("0100", temp);
  temp = loadImage("Grass/Grass_00xx.png");
  temp.resize(tileSize, tileSize);
  grass.put("1100", temp);
  temp = loadImage("Grass/Grass_0x00.png");
  temp.resize(tileSize, tileSize);
  grass.put("0001", temp);
  temp = loadImage("Grass/Grass_0x0x.png");
  temp.resize(tileSize, tileSize);
  grass.put("1001", temp);
  temp = loadImage("Grass/Grass_0xx0.png");
  temp.resize(tileSize, tileSize);
  grass.put("0101", temp);
  temp = loadImage("Grass/Grass_0xxx.png");
  temp.resize(tileSize, tileSize);
  grass.put("1101", temp);
  temp = loadImage("Grass/grass_2.png");
  temp.resize(tileSize, tileSize);
  grass.put("0010", temp);
  temp = loadImage("Grass/Grass_2_1.png");
  temp.resize(tileSize, tileSize);
  grass.put("0111", temp);
  temp = loadImage("Grass/Grass_x00x.png");
  temp.resize(tileSize, tileSize);
  grass.put("1010", temp);
  temp = loadImage("Grass/Grass_x0x0.png");
  temp.resize(tileSize, tileSize);
  grass.put("0110", temp);
  temp = loadImage("Grass/Grass_x0xx.png");
  temp.resize(tileSize, tileSize);
  grass.put("1110", temp);
  temp = loadImage("Grass/Grass_xx00.png");
  temp.resize(tileSize, tileSize);
  grass.put("0011", temp);
  temp = loadImage("Grass/Grass_xx0x.png");
  temp.resize(tileSize, tileSize);
  grass.put("1011", temp);
  
  stone = new HashMap<String, PImage>();
  temp = loadImage("Stone/Stone_0.png");
  temp.resize(tileSize, tileSize);
  stone.put("0000", temp);
  temp = loadImage("Stone/Stone_000x.png");
  temp.resize(tileSize, tileSize);
  stone.put("1000", temp);
  temp = loadImage("Stone/Stone_00x0.png");
  temp.resize(tileSize, tileSize);
  stone.put("0100", temp);
  temp = loadImage("Stone/Stone_00xx.png");
  temp.resize(tileSize, tileSize);
  stone.put("1100", temp);
  temp = loadImage("Stone/Stone_0x00.png");
  temp.resize(tileSize, tileSize);
  stone.put("0001", temp);
  temp = loadImage("Stone/Stone_0x0x.png");
  temp.resize(tileSize, tileSize);
  stone.put("1001", temp);
  temp = loadImage("Stone/Stone_0xx0.png");
  temp.resize(tileSize, tileSize);
  stone.put("0101", temp);
  temp = loadImage("Stone/Stone_0xxx.png");
  temp.resize(tileSize, tileSize);
  stone.put("1101", temp);
  temp = loadImage("Stone/Stone_x000.png");
  temp.resize(tileSize, tileSize);
  stone.put("0010", temp);
  temp = loadImage("Stone/Stone_xxx0a.png");
  temp.resize(tileSize, tileSize);
  stone.put("0111", temp);
  temp = loadImage("Stone/stone_x00x.png");
  temp.resize(tileSize, tileSize);
  stone.put("1010", temp);
  temp = loadImage("Stone/Stone_x0x0.png");
  temp.resize(tileSize, tileSize);
  stone.put("0110", temp);
  temp = loadImage("Stone/Stone_x0xx.png");
  temp.resize(tileSize, tileSize);
  stone.put("1110", temp);
  temp = loadImage("Stone/Stone_xx00.png");
  temp.resize(tileSize, tileSize);
  stone.put("0011", temp);
  temp = loadImage("Stone/Stone_xx0x.png");
  temp.resize(tileSize, tileSize);
  stone.put("1011", temp);
  temp = loadImage("Stone/stone_255a.png");
  temp.resize(tileSize, tileSize);
  stone.put("1111", temp);
  
  println((System.currentTimeMillis() - t) / 1000f);
}

PImage reverseImage( PImage image ) {
  PImage reverse;
  reverse = createImage(image.width, image.height, ARGB );

  for ( int i=0; i < image.width; i++ ) {
    for (int j=0; j < image.height; j++) {
      int xPixel, yPixel;
      xPixel = image.width - 1 - i;
      yPixel = j;
      reverse.pixels[yPixel*image.width+xPixel]=image.pixels[j*image.width+i] ;
    }
  }
  return reverse;
}

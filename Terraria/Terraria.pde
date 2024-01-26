import fisica.*;
import java.util.*;
import java.lang.System;

final static color transparent = #00000000;
final static color brown = #643f21;
final static color gray = #676767;

boolean upKey, leftKey, rightKey, wKey, aKey, dKey, oneKey, twoKey, threeKey;

PImage map;
PImage woodenSword;
PImage copperPickaxe;
PImage copperCoin;
PImage silverCoin;
PImage goldCoin;
PImage platinumCoin;

PImage headRight;
PImage headLeft;
PImage torsoRight;
PImage torsoLeft;
PImage torsoJumpRight;
PImage torsoJumpLeft;
PImage legsRight;
PImage legsLeft;
PImage legsJumpRight;
PImage legsJumpLeft;
PImage[] torsoWalkRight;
PImage[] torsoWalkLeft;
PImage[] torsoSwingRight;
PImage[] torsoSwingLeft;
PImage[] legsWalkRight;
PImage[] legsWalkLeft;
PImage[] zombieWalkRight;
PImage[] zombieWalkLeft;

HashMap<String, Tool> weapons;
HashMap<ItemTypes, Integer> itemStacks;

HashMap<String, PImage> dirt;
HashMap<String, PImage> stone;
HashMap<String, PImage> wood;
Block[][] blocks;

FWorld world;

Player player;

ArrayList<Enemy> enemies;

int tileSize;

void setup() {
  size(800, 800);
  Fisica.init(this);
  
  tileSize = 10;
  
  setupImages();
  setupWeapons();
  setupWorld();
  setupTiles();
  setupData();
  setupPlayer();
}

void draw() {
  updateWorld();
  drawWorld();
}

void drawWorld() {
  background(#97E5E5);
  pushMatrix();
  float scale = 1;
  scale(scale);
  translate(-player.getX() + width/2/scale, -player.getY() + height/2/scale);
  
  
  world.step();
  world.draw();
  
  popMatrix();
}

void updateWorld() {
  player.update();
  
  for (int i = 0; i < enemies.size(); i++) {
    Enemy e = enemies.get(i);
    e.checkEffects();
    e.update();
  }
}

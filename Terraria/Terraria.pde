import  fisica.*;
import java.util.*;
import java.lang.System;

final static color transparent = #00000000;
final static color brown = #643f21;
final static color gray = #676767;

boolean upKey, leftKey, rightKey, wKey, aKey, dKey;

PImage map;
PImage dirt;
PImage woodenSword;

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

HashMap<String, Weapon> weapons;

HashMap<String, PImage> grass;
HashMap<String, PImage> stone;
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
  setupPlayer();
}

void draw() {
  updateWorld();
  drawWorld();
}

void drawWorld() {
  background(#97E5E5);
  pushMatrix();
  scale(1);
  translate(-player.getX() + 400, -player.getY() + 400);
  
  world.step();
  world.draw();
  
  popMatrix();
}

void updateWorld() {
  player.update();
  
  for (int i = 0; i < enemies.size(); i++) {
    enemies.get(i).update();
  }
}

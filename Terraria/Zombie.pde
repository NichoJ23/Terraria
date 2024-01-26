class Zombie extends Walker {
  Zombie(int x, int y) {
    super(x, y, tileSize*2, (int)(tileSize*2.8), 45, 6, 0, 14, 60, 25, true, zombieWalkRight, zombieWalkLeft);
  }
  
  void update() {
    walk();
    
    contactDamage();
    
    show();
  }
}

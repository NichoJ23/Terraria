class Zombie extends Walker {
  Zombie(int x, int y) {
    super(x, y, 25, 30, 45, 6, 14, 60, 25, true, zombieWalkRight, zombieWalkLeft);
  }
  
  void update() {
    walk();
    
    contactDamage();
    
    show();
  }
}

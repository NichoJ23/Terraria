class Weapon {
  int useTime;
  int damage;
  int knockBack;
  int critChance;
  PImage image;
  
  Weapon(int _damage, int _useTime, int kb, int crit, PImage _image) {
    useTime = _useTime;
    damage = _damage;
    knockBack = kb;
    critChance = crit;
    image = _image;
  }
}

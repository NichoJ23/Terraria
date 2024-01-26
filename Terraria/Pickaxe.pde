class Pickaxe extends Tool {
  int power;
  int strengthLevel;
  int mineSpeed;
  
  Pickaxe(int damage, int useTime, int knockBack, float critChance, int _mineTime, int _power, int _strengthLevel, PImage image) {
    super(useTime, damage, knockBack, critChance, image);
    power = _power;
    strengthLevel = _strengthLevel;
    mineSpeed = _mineTime;
  }
}

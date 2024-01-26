class Tool {
  int useTime;
  int damage;
  int knockBack;
  float critChance;
  
  PImage image;
  
  Tool(int _useTime, int _damage, int _knockBack, float _critChance, PImage _image) {
    useTime = _useTime;
    damage = _damage;
    image = _image;
    knockBack = _knockBack;
    critChance = _critChance;
  }
}

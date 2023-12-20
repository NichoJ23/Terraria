class Enemy extends FBox {
  int currentHealth;
  int maxHealth;
  int defense;
  int contactDamage;
  int coinsDropped;
  
  Enemy(int x, int y, int w, int h, int _maxHealth, int _defense, int _contactDamage, int _coinsDropped) {
    super(w, h);
    setPosition(x, y);
    setRotatable(false);
    setGrabbable(false);
    setName("enemy");
    
    setDensity(0.2);
    setRestitution(0);
    setFriction(0);
    
    maxHealth = _maxHealth;
    currentHealth = maxHealth;
    defense = _defense;
    contactDamage = _contactDamage;
    coinsDropped = _coinsDropped;
  }
  
  void contactDamage() {
    if (touchingBlock(this, "player") != null) {
      player.takeDamage(contactDamage, new PVector(getX(), getY()));
    }
  }
  
  void update() {
    
  }
  
  void takeDamage(int damage) {
    currentHealth -= damage;
  }
}

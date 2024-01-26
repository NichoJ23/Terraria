class Enemy extends FBox {
  int currentHealth;
  int maxHealth;
  int defense;
  float knockBackResist;
  int contactDamage;
  int coinsDropped;
  
  boolean isStunned;
  long stunEnd;
  
  Enemy(int x, int y, int w, int h, int _maxHealth, int _defense, float _kbResist, int _contactDamage, int _coinsDropped) {
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
    knockBackResist = _kbResist;
  }
  
  void update() {
    
  }
  
  void contactDamage() {
    if (touchingBlock(this, "player") != null) {
      player.takeDamage(contactDamage, new PVector(getX(), getY()));
    }
  }
  
  void checkEffects() {
    // Check to see if effects are over yet
    if (System.currentTimeMillis() > stunEnd) {
      isStunned = false;
    }
  }
  
  void takeDamage(int damage, int knockBack, PVector origin) {
    currentHealth -= damage - (int)(round(defense/2f));
    
    if (currentHealth <= 0) {
      die();
    }
    
    // Multiply by an arbitraty number to scale knockback to world's size
    int kb = knockBack * 60;
    // Flip direction if damage came from the right
    if (origin.x > getX()) {
      kb *= -1;
    }
    
    // Affect knockback taken by enemy's knockback resist, on a scale from 0-1
    kb *= 1 - knockBackResist;
    
    // Knockback overwrites current velocity
    setVelocity(kb, -50);
    
    // Flag enemy as stunned so it will not move when hit
    // Stun time is 0.25s
    isStunned = true;
    stunEnd = System.currentTimeMillis() + 50;
  }
  
  void die() {
    world.remove(this);
    
    dropCoins(coinsDropped, (int)getX(), (int)getY());
  }
}

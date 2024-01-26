enum ItemTypes {COPPER_COIN, SILVER_COIN, GOLD_COIN, PLATINUM_COIN, WOODEN_SWORD, COPPER_PICKAXE, DIRT, STONE, WOOD};

class InventoryItem {
  int maxStacks;
  int currentStacks;
  ItemTypes type;
  
  InventoryItem(ItemTypes _type, int _maxStacks) {
    maxStacks = _maxStacks;
    currentStacks = 1;
    type = _type;
  }
  
  void addStacks(int amount) {
    currentStacks += amount;
  }
  
  void removeStacks(int amount) {
    currentStacks -= amount;
  }
  
  boolean isFilled() {
    return currentStacks >= maxStacks;
  }
}

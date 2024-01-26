class Inventory {
  InventoryItem[] items;
  int maxItems;
  boolean isFull;
  
  Inventory(int _maxItems) {
    maxItems = _maxItems;
    items = new InventoryItem[maxItems];
    isFull = false;
  }
  
  void addItem(ItemTypes type, int amount) {
    boolean added = false;
    for (InventoryItem item: items) {
      // See if we already have some of this item and it has space for more
      if (item.type == type && !item.isFilled()) {
        if (item.currentStacks + amount > item.maxStacks) {
          // If we have more of the item than there is space, fill up the current slot and add the rest to a new one
          int toAdd = item.maxStacks - item.currentStacks;
          item.addStacks(toAdd);
          
          addItem(type, amount - toAdd);
        } else {
          item.addStacks(amount);
        }
        
        added = true;
      }
    }
    
    if (added) return;
    // If we didn't find a pre-existing stack with space in it, create a new one
    
    InventoryItem newItem = new InventoryItem(type, itemStacks.get(type));
    
    if (amount > newItem.maxStacks) {
      // If we have more stacks then the item slot can fit, max this one out and add another
      newItem.currentStacks = newItem.maxStacks;
      addItem(type, amount - newItem.maxStacks);
    } else {
      newItem.currentStacks = amount;
    }
    
    // Get the first empty slot in the inventory
    int newIndex = getFirstEmptySlot();
    if (newIndex >= 0) {
      items[newIndex] = newItem;
    }
  }
  
  int getFirstEmptySlot() {
    for (int i = 0; i < items.length; i++) {
      if (items[i] == null) {
        return i;
      }
    }
    
    return -1;
  }
}

enum CoinTypes {COPPER, SILVER, GOLD, PLATINUM};

class Coin extends Dropped {
  int value;
  CoinTypes type;
  
  Coin(int x, int y, int amount, CoinTypes _type) {
    super(3, 3, x, y, amount, (_type == CoinTypes.COPPER) ? ItemTypes.COPPER_COIN: (_type == CoinTypes.SILVER) ? ItemTypes.SILVER_COIN: (_type == CoinTypes.GOLD) ? ItemTypes.GOLD_COIN: ItemTypes.PLATINUM_COIN, (_type == CoinTypes.COPPER) ? copperCoin: (_type == CoinTypes.SILVER) ? goldCoin: (_type == CoinTypes.GOLD) ? goldCoin: platinumCoin);
    
    
    type = _type;
    
    switch (type) {
      case COPPER:
        value = 1;
        break;
      case SILVER:
        value = 100;
      case GOLD:
        value = 10000;
        break;
      case PLATINUM:
        value = 1000000;
        break;
    }
  }
}

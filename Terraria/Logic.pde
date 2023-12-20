FBox touchingBlock(FBody body, String type) {
  ArrayList<FContact> contacts = body.getContacts();
  
  for (FContact c: contacts) {
    if (c.getBody1() == body) {
      if (c.getBody2().getName() == type) {
        return (FBox)c.getBody1();
      }
    } else {
      if (c.getBody1().getName() == type) {
        return (FBox)c.getBody1();
      }
    }
  }
  
  return null;
}
  
FBox touchingBlock(FBody body, String[] types) {
  ArrayList<FContact> contacts = body.getContacts();
  
  for (FContact c: contacts) {
    List typesList = Arrays.asList(types);
    
    if (c.getBody1() == body) {
      if (typesList.contains(c.getBody2().getName())) {
        return (FBox)c.getBody1();
      }
    } else {
      if (typesList.contains(c.getBody1().getName())) {
        return (FBox)c.getBody1();
      }
    }
  }
  
  return null;
}

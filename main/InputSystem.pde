class IS{//should only be once used, maybe static class
  
  private HashMap<Integer, Boolean> keys;//integer for the keyvalue
  private HashMap<Integer, Boolean> pressed;//for once pressed
  private HashMap<String, ArrayList<Integer>> Actions;//the
  
  IS(){
    keys = new HashMap<Integer, Boolean>();
    pressed = new HashMap<Integer, Boolean>();
    Actions = new HashMap<String, ArrayList<Integer>>();
  }
  
  public void addAction(String action, ArrayList<Character> ks){
    //add the Action
    //ArrayList<Integer> new ArrayList<Integer>() = new ArrayList<Integer>();
    Actions.put(action, new ArrayList<Integer>());
    //convert every char in the list to a int
    for (char c : ks){
      Actions.get(action).add(int(c));
    }
  }
  public void addActionI(String action, ArrayList<Integer> ks){
    //add the Action
    //ArrayList<Integer> new ArrayList<Integer>() = new ArrayList<Integer>();
    Actions.put(action, new ArrayList<Integer>(ks));
  }
  public void addAction(String action, Integer k){
    //add the Action
    if (!Actions.containsKey(action))//if the action does not exist create it
      Actions.put(action, new ArrayList<Integer>());
    Actions.get(action).add(k);// add the key to the list
  }
  
  public void UpdateKey(char k, boolean b){
    if (!keys.containsKey(int(k)))//if the key has not been added to the map add it
      keys.put(int(k), b);
    keys.replace(int(k), b);//update the key
    //copy for {pressed}
    if (!pressed.containsKey(int(k)))//if the key has not been added to the map add it
      pressed.put(int(k), b);
    pressed.replace(int(k), b);//update the key
    
  }
  public void UpdateKey(Integer k, boolean b){
    if (!keys.containsKey(k))//if the key has not been added to the map add it
      keys.put(k, b);
    keys.replace(k, b);//update the key
    //copy for {pressed}
    if (!pressed.containsKey(int(k)))//if the key has not been added to the map add it
      pressed.put(int(k), b);
    pressed.replace(int(k), b);//update the key
  }
  
  public boolean ispressed(String action){
    if (!Actions.containsKey(action))
      return false;//if the action does not exist in the map return false
    
    //if any of the keys of the action is being released return true
    for (int i : Actions.get(action))
      if (keys.containsKey(Integer.valueOf(i)))//first of all; does this key even exist
        if ( keys.get(Integer.valueOf(i)) )//if yes 
          return true;
    
    return false;//apparantly nothing has been released
  }
  public boolean pressed(String action){
    if (!Actions.containsKey(action))
      return false;//if the action does not exist in the map return false
    boolean returnValue = false;
    for (Integer i : Actions.get(action)){
      //check if it exist
      if (!pressed.containsKey(i))
        continue;
      //if this is true set the {returnValue} to true
      if (pressed.get(i))
        returnValue = true;
      //set it to false
      pressed.replace(i, false);
    }
    return returnValue;
  }
}

class Scene{
  
  private ArrayList<sprite> sprites = new ArrayList<sprite>();
  
  public void add(sprite nw){
    sprites.add(nw);
  }
 
  Scene(){}
  
  public void run(){
    for (sprite sp : sprites){
      sp.update();
    }
  }
  public void onChange(){}
}

class SceneHandler{
  private HashMap<String,Scene> scenes = new HashMap<String,Scene>();
  Scene currentScene = null;
  String currentSceneName = new String();
  
  public void addScene(Scene nw,String name){
    this.scenes.put(name, nw);
    if (this.currentScene == null){
      this.currentScene = scenes.get(name);
      this.currentScene.onChange();
    }
  }
  public void removeScene(String name){
    this.scenes.remove(name);
  }
  
  public void changeScene(String name){
    this.currentSceneName = name;
    this.currentScene = scenes.get(name);
    this.currentScene.onChange();
  }
  
  public void run(){
    this.currentScene.run();
  }
}

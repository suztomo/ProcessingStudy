public class VoiceGenerator{
  ArrayList storedTweets;
  TweetFactory factory;
  int i;
  String filepath;
  public VoiceGenerator(String filename) {
    filepath = "keywords/" + filename + ".txt";
    i = 0;
    update();
  }
  public void update() {
    storedTweets = new ArrayList();
    BufferedReader reader;
    try{
      println("Loading new voices from File");
      reader = createReader(filepath);
      String line = reader.readLine();
      
      while(line != null) {
        println("loading : " + line);
        storedTweets.add(line);
        line = reader.readLine();
      }
    } catch (Exception e) {
      println("Error " + filepath);
      System.out.print(e.getMessage());
      return;
    }
    println("Successfully loaded new statuses from " + filepath);
  }

  
  public String getVoice() {
    return (String)storedTweets.get(i++ % storedTweets.size());
  }
}

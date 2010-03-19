public class TweetArray{
  public ArrayList tweets;
  
  TweetArray(){
    tweets = new ArrayList();
  }
  
  boolean add(Tweet tw){
    tweets.add(tw);
    return true;
  }
  
  void add(int index, Tweet tw){
    tweets.add(index, tw);
  }
  
  Tweet remove(int index){
    return (Tweet)tweets.remove(index);
  }
  
  Tweet get(int index){
    return (Tweet)tweets.get(index);
  }
}

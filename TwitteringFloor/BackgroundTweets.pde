
/*
  Manages background tweets.
 */
public class BackgroundTweets{
    TweetFactory factory;
    ArrayList tweets;
    public BackgroundTweets(PApplet canvas) {
        factory = new TweetFactory(canvas);
        tweets = factory.tweets();
    }

    /*
      Moves the tweets
     */
    public void update() {
        for (int i=0; i<tweets.size(); ++i) {
            Tweet tw = (Tweet)tweets.get(i);
            tw.move();
            tw.display();
        }
    }
}
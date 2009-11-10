
/*
  Manages background tweets.
 */
public class BackgroundTweets{
    TweetFactory factory;
    ArrayList tweets;
    PApplet canvas;
    public BackgroundTweets(PApplet _canvas) {
        factory = new TweetFactory(_canvas);
        tweets = factory.tweets();
        canvas = _canvas;
    }

    /*
      Moves the tweets
     */
    public void update() {
        for (int i=0; i<tweets.size(); ++i) {
            Tweet tw = (Tweet)tweets.get(i);
            tw.update();
            tw.display();
        }
        if (canvas.frameCount % (DisplayWindowFrameRate * 6) == 0) {
            factory.update();
            tweets = factory.tweets();
        }
    }
}
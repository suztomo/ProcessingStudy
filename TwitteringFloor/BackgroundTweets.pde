
/*
  Manages background tweets.
 */
public class BackgroundTweets{
    TweetFactory factory;
    TweetFactory ffactory;
    ArrayList tweets;
    PApplet canvas;
    public BackgroundTweets(PApplet _canvas) {
        //factory = new TweetFactoryFromWWW(_canvas);
        factory = new TweetFactoryFromFile(_canvas, "東大");
        tweets = factory.tweets();
//        tweets.addAll(ffactory.tweets());
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
        if (canvas.frameCount % (DisplayWindowFrameRate * 10) == 0) {
  //          ffactory.update();
            factory.update();
              tweets = factory.tweets();
  //         tweets.addAll(factory.tweets());
        }
    }
}

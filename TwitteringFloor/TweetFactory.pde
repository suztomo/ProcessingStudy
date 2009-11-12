import twitter4j.org.json.*;
import twitter4j.*;
import twitter4j.http.*;
import twitter4j.examples.*;


/*
  Generates array of Tweet, used in BackgroundTweets.
 */
public class TweetFactory{
    String url;
    ArrayList tweets; // Array of Tweet
    ArrayList storedTweets;
    Twitter twitter;
    PApplet canvas;
    int position = 0;
    int numperupdate = 10;
    public TweetFactory(PApplet _canvas) {
        //ユーザ名とパスワード
        twitter = new Twitter("Univ_of_Tokyo","testpass");
        canvas = _canvas;
    }

    private void loadTweetsFromWWW() {
        java.util.List statuses = null;
        storedTweets = new ArrayList();
        try{
            println("Loading new tweets from WWW...");
            //メッセージ
            statuses = twitter.getFriendsStatuses();
        } catch (Exception e) {
            println("Error");
            System.out.print(e.getMessage());
            return;
        }
        for (int i=0; i<statuses.size(); ++i) {
            User user = (User)statuses.get(i);
            String message = user.getStatusText();
            storedTweets.add(message);
        }
        println("Successfully loaded new statuses");
    }

    public void update() {
        ArrayList new_tweets = new ArrayList();
        if (storedTweets == null ||
            (storedTweets != null && position >= storedTweets.size())) {
            loadTweetsFromWWW();
            position = 0;
        }

        println("Indexes: " + str(position) + " - " + str(position + numperupdate));
        for (int i=position;
             i < storedTweets.size() && i < position + numperupdate;
             ++i) {
            int x = int(random(0, 400));
            int y = int(random(0, DisplayWindowHeight));
            String message = (String)storedTweets.get(i);
            PFont font = selectFont(message);
            int realColor = color(int(random(0xFF)),
                                  int(random(0xFF)),
                                  int(random(0xFF)));
            Tweet tw = new Tweet(x, y, message, font, realColor, canvas);
            new_tweets.add(tw);
        }
        position += new_tweets.size();
        tweets = new_tweets;
    }

    public ArrayList tweets() {
        if (tweets == null) {
            update();
        }
        return tweets;
    }
}

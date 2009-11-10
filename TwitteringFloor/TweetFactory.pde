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
    Twitter twitter;
    PApplet canvas;
    public TweetFactory(PApplet _canvas) {
        //ユーザ名とパスワード
        twitter = new Twitter("Univ_of_Tokyo","testpass");
        canvas = _canvas;
    }

    public void update() {
        java.util.List statuses = null;
        ArrayList new_tweets = new ArrayList();
        try{
            //メッセージ
            statuses = twitter.getFriendsStatuses();
        } catch (Exception e) {
            println("Error");
            System.out.print(e.getMessage());
        }

        for (int i=0; i< statuses.size(); ++i) {
            User user = (User)statuses.get(i);
            println(str(i) + ": " + user.getScreenName() + " < " + user.getStatusText());
            int x = 100;
            int y = 100 + i * 30;
            String message = user.getStatusText();
            PFont font = selectFont(message);
            Tweet tw = new Tweet(x, y, message, font, 0, canvas);
            new_tweets.add(tw);
        }
        tweets = new_tweets;
    }

    public ArrayList tweets() {
        if (tweets == null) {
            update();
        }
        return tweets;
    }
}

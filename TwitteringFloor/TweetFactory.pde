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
    java.util.List statuses = null;
    int position = 0;
    int numperupdate = 20;
    public TweetFactory(PApplet _canvas) {
        //ユーザ名とパスワード
        twitter = new Twitter("Univ_of_Tokyo","testpass");
        canvas = _canvas;
    }

    public void update() {
        ArrayList new_tweets = new ArrayList();
        if (statuses == null ||
            (statuses != null && position >= statuses.size())) {
            try{
                println("Loading new tweets from WWW");
                //メッセージ
                statuses = twitter.getFriendsStatuses();
            } catch (Exception e) {
                println("Error");
                System.out.print(e.getMessage());
                return;
            }
            position = 0;
        }

        println("Indexes: " + str(position) + " - " + str(position + numperupdate));
        for (int i=position;
             i < statuses.size() && i < position + numperupdate;
             ++i) {
            User user = (User)statuses.get(i);
            int x = int(random(0, 400));
            int y = int(random(0, DisplayWindowHeight));
            String message = user.getStatusText();
            PFont font = selectFont(message);
            Tweet tw = new Tweet(x, y, message, font, 0, canvas);
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

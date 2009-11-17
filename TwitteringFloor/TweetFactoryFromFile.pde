import twitter4j.org.json.*;
import twitter4j.*;
import twitter4j.http.*;
import twitter4j.examples.*;


/*
  Generates array of Tweet, used in BackgroundTweets.
 */
public class TweetFactoryFromFile extends TweetFactory {
    String url;
    ArrayList tweets; // Array of Tweet
    ArrayList storedTweets;
    String filepath;
    PApplet canvas;
    int position = 0;
    int numperupdate = 10;
    public TweetFactoryFromFile(PApplet _canvas, String filename) {
        super();
        filepath = "keywords/" + filename;
        canvas = _canvas;
    }

    private void loadTweetsFromFile() {
        storedTweets = new ArrayList();
        BufferedReader reader;
        try{
            println("Loading new tweets from WWW...");
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

    public void update() {
        ArrayList new_tweets = new ArrayList();
        if (storedTweets == null ||
            (storedTweets != null && position >= storedTweets.size())) {
            loadTweetsFromFile();
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

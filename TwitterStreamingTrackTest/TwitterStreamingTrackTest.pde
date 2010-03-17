TwitterStreamingTrack tsr;
TwitterPollingTrack tpr;

PFont font;

int appletFrameRate = 10;

void setup() {
    font = createFont("FFScala", 32);
    textFont(font);
    println(this);
    String keywordStreamingFileName = "stream.txt";
    String keywords = join(loadStrings(keywordStreamingFileName), ",");
    tsr = new TwitterStreamingTrack(this, keywords);

    String keywordPollingFileName = "poll.txt";
    keywords = join(loadStrings(keywordPollingFileName), "__PLUS__OR__PLUS__");
    tpr = new TwitterPollingTrack(this, keywords);
    frameRate(appletFrameRate);
}


void draw() {
    //    tsr.update();
    if (frameCount % (appletFrameRate * 15) == 0) {
        Tweet[] tweets = tpr.getNewTweets();
        for (int i=0; i<tweets.length; ++i) {
            Tweet t = tweets[i];
            if (t == null) continue;
            println(t.scname + "(" + t.username +"): " + t.msg);
        }
    }
    Tweet t = tsr.getNewTweet();
    if (t != null) {
        println(t.scname + "(" + t.username +"): " + t.msg);
    }
}

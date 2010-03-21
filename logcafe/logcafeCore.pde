public class LogcafeCore{
    TwitterStreamingTrack tst;
    TwitterPollingTrack tpt;
    public LogcafeCore(PApplet parent) {
        String[] f = loadStrings(twitterStreamingKeywordFile);
        if (f == null) {
            println("cannot read " + twitterStreamingKeywordFile);
            exit();
            return;
        }
        String keywords = join(f, ",");
        tst = new TwitterStreamingTrack(parent, keywords);

        f = loadStrings(twitterPollingKeywordFile);
        if (f == null) {
            println("cannot read " + twitterPollingKeywordFile);
            exit();
            return;
        }
        keywords = join(f, "__PLUS__OR__PLUS__");
        tpt = new TwitterPollingTrack(parent, keywords);
    }

    void draw(){
        int i;
        int tws = tweets.size();
        for(i=0; i<min(ballonLimit, tweets.size()); ++i){
            FuwaTweet tw = (FuwaTweet)tweets.get(i);
            tw.draw();
        }
    }
  
    void update(){
        FuwaTweet ft;
        Tweet t = null;
        // Polling.getNewTweets should be calld in 30 seconds.
        if (frameCount % (framerate * twitterSearchInterval) == 0) {
            Tweet[] newTweets = tpt.getNewTweets();
            for (int i=0; i<newTweets.length; ++i) {
                t = newTweets[i];
                if (t == null) continue;
                ft = new FuwaTweet(t);
                tweets.add(ft);
                break;
            }
        } else {
            // Streaming.getNewTweet should be calld in each frame.
            t = tst.getNewTweet();
            if (t != null) {
                ft = new FuwaTweet(t);
                tweets.add(ft);
            }
        }
        int tws = tweets.size();
        for(int i=min(ballonLimit, tws)-2; i>=0; --i){
            FuwaTweet tw = (FuwaTweet)tweets.get(i);      
            if(tw.ttl < 0 && tws > ballonLimit){
                if(tw.outUpdate()){
                    tweets.remove(i);
                }
            }
            /*
              else if(tw.state == 0){
              tw.inUpdate();
              }
            */
            else{
                tw.update();
            }
        }
    }
}



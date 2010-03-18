TwitterStreamingTrack tsr;
TwitterPollingTrack tpr;

PFont font1, font2;
int WindowWidth = 1200;
int WindowHeight = 600;
int appletFrameRate = 10;
int fillColor = 0x0;
int drawCount = 1;
void setup() {
    size(WindowWidth, WindowHeight);
    font1 = createFont("Helvetica-Bold", 30);
    font2 = createFont("Helvetica-Bold", 20);

    String keywords = join(loadStrings("stream.txt"), ",");
    tsr = new TwitterStreamingTrack(this, keywords);

    keywords = join(loadStrings("poll.txt"), "__PLUS__OR__PLUS__");
    tpr = new TwitterPollingTrack(this, keywords);
    frameRate(appletFrameRate);
    background(0xFF);
    fill(0x0);
    drawGradientSquare(-20, 0, 40, WindowHeight,
                       -3, 0, 20);
    drawGradientSquare(WindowWidth-20, 0, 40, WindowHeight,
                       3, 0, 20);
    drawGradientSquare(0, -20, WindowWidth, 40,
                       0, -3, 20);
    drawGradientSquare(0, WindowHeight-20, WindowWidth, 40,
                       0, +3, 20);

}


void drawGradientSquare(int x, int y, int width, int height,
                        int gradDiffX, int gradDiffY, int step) {
    rectMode(CORNER);
    noStroke();
    float perGrad = 255.0 / step;
    for (float alpha=perGrad; alpha <= 0xFF; alpha += perGrad) {
        fill(0x0, alpha);
        rect(x, y, width, height);
        x += gradDiffX;
        y += gradDiffY;
    }
}



void draw() {
    // Polling.getNewTweets should be calld in 30 seconds.
    if (frameCount % (appletFrameRate * 5) == 0) {
        Tweet[] tweets = tpr.getNewTweets();
        for (int i=0; i<tweets.length; ++i) {
            Tweet t = tweets[i];
            if (t == null) continue;
            showTweet(t);
            break;
        }
    }

    // Streaming.getNewTweet should be calld in each frame.
    Tweet t = tsr.getNewTweet();
    if (t != null) {
        showTweet(t);
    }
    if (drawCount > 100) {
        fillColor = (fillColor == 0x0) ? 0xFF : 0x0;
        fill(fillColor);
        drawCount = 0;
    }
}

void showTweet(Tweet t) {
    int x = int(random(0, WindowWidth/3));
    int y = int(random(40, WindowHeight-300));
    println(t.scname + "(" + t.username +"): " + t.msg);
    textFont(font1);
    text(t.msg, x, y);
    textFont(font2);
    text("@" + t.scname + " (" + t.username + ")", 200+x, 60 + y);
    drawCount += 1;
 }

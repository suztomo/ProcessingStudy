public class DisplayFrame extends Frame{
    public DisplayFrame(){
        setBounds(0,0, DisplayWindowWidth, DisplayWindowHeight);
        ap = new DisplayApplet();
        add(ap);
        ap.init();
        show();
    }
}

int xmove = 0;
int dxmove = 1;
int ymove = 0;
int dymove = 1;
int DisplayWindowFrameRate = 20;
public class DisplayApplet extends PApplet{
    public void setup(){
        println("DisplayApplet initializing");
        size(DisplayWindowWidth, DisplayWindowHeight);
        PFont font = createFont("Osaka", 30);
        textFont(font);
        //        noLoop();
        bgtweets = new BackgroundTweets(this);
        bgtweets.update();
    }

    public void updateBackground() {
        bgtweets.update();
    }

    public void updateVoices() {
        if (shadows == null) {
            return;
        }
        for (int i=0; i<shadows.size(); ++i) {
            Shadow s = (Shadow)shadows.get(i);
            s.displayVoice();
        }
    }

    public void draw(){
        PFont font;
        try {
            font = (PFont)(FontsBySize[3].get(2));
        } catch(Exception e) {
            font = createFont("Osaka", 30);
        }
        textFont(font);
        PApplet ap = this;
        ap.fill(255,255,255);
        ap.rect(0, 0, DisplayWindowWidth, DisplayWindowHeight);

        updateBackground();

        updateVoices();

        ap.fill(0, 0, 0);
        xmove += dxmove;
        ymove += dymove;
        frameRate(DisplayWindowFrameRate);
    }
}

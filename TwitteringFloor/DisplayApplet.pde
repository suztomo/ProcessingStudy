public class DisplayFrame extends Frame{
    public DisplayFrame(){
        setBounds(0,0, DisplayWindowWidth, DisplayWindowHeight*2);
        ap = new DisplayApplet();
        add(ap);
        ap.init();
        show();
    }
}

public class DisplayApplet extends PApplet{
    public void setup(){
        size(DisplayWindowWidth*2, DisplayWindowHeight*2);
        PFont font = createFont("Osaka", 20);
        textFont(font);
    }
    public void draw(){
        /*
        fill(255,255,255);
        rect(0, 0, DisplayWindowWidth, DisplayWindowHeight);
        */
        fill(0, 0, 0);
        text("日本語のテストutf-8", 0, 300);
    }
}

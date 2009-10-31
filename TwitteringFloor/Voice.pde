float VoiceMoveDelay = 1.0/10;


public class Voice{
    private int x, y;
    private int to_x, to_y;
    private PFont font;
    private String message;
    private int col;
    private int offsetX, offsetY;
    PApplet canvas;

    public Voice(int _x, int _y, String _text, PFont _font, PApplet _canvas,
                 int _offsetX, int _offsetY) {
        x = _x;
        y = _y;
        font = _font;
        message = _text;
        canvas = _canvas;
        col = color(60);
        offsetX = _offsetX;
        offsetY = _offsetY;
    }

    public void update(int _to_x, int _to_y) {
        to_x = _to_x;
        to_y = _to_y;
        move();
    }

    public void move() {
        int dx = int((to_x - x) * VoiceMoveDelay);
        int dy = int((to_y - y) * VoiceMoveDelay);
        x += dx;
        y += dy;
    }

    public void display() {
        displayText();
    }

    public void displayText() {
        fill(col);
        println("displaying");
        textFont(font);
        text(message, x + offsetX, y + offsetY);
    }

}

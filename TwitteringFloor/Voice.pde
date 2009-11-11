float VoiceMoveDelay = 1.0/10;
public class Voice extends SmoothDisplayObject{
    private int x, y;
    private int to_x, to_y;
    private PFont font;
    private String message;
    private int debugOffsetX, debugOffsetY;
    PApplet canvas;

    public Voice(int _x, int _y, String _text, PFont _font, PApplet _canvas,
                 int _offsetX, int _offsetY) {
        super(color(60), random(0.6, 0.9), DisplayWindowFrameRate * 7,
              DisplayWindowFrameRate, _canvas);
        x = _x;
        y = _y;
        font = _font;
        message = _text;
        canvas = _canvas;
        debugOffsetX = _offsetX;
        debugOffsetY = _offsetY;
    }

    public void update(int _to_x, int _to_y) {
        to_x = _to_x;
        to_y = _to_y;
        move();
        super.update();
    }

    private void move() {
        int dx = int((to_x - x) * VoiceMoveDelay);
        int dy = int((to_y - y) * VoiceMoveDelay);
        x += dx;
        y += dy;
    }

    public void display() {
        super.beforeDraw();
        displayDebug();
        displayText(canvas, 0, 0);
    }

    private void displayDebug() {
        displayText(managerWindow, ManagerWindowFrameWidth,
                    ManagerWindowFrameHeight * 2);
    }

    private void displayText(PApplet c, int offsetX, int offsetY) {
        c.textFont(font);
        c.text(message, x + offsetX, y + offsetY);
    }

}

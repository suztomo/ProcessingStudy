float VoiceMoveDelay = 1.0/10;
public class Voice extends SmoothDisplayObject{
    private int x, y;
    private int to_x, to_y;
    private int vx, vy;
    private PFont font;
    private String message;
    private int debugOffsetX, debugOffsetY;
    private float k = 0.05; // spring
    private float m = 1;
    PApplet canvas;
    private Point drawDiff;

    public Voice(int _x, int _y, String _text, PFont _font, PApplet _canvas,
                 int _offsetX, int _offsetY) {
        super(color(0x0), random(0.6, 0.9), 0,
              DisplayWindowFrameRate, _canvas);
        x = _x;
        y = _y;
        font = _font;
        message = _text;
        canvas = _canvas;
        debugOffsetX = _offsetX;
        debugOffsetY = _offsetY;
        vx = vy = 0;

        /* Adjusts the points to the center of the text field */
        drawDiff = textPointDiff(message, font);
    }

    public void updatePoint(int _to_x, int _to_y) {
        to_x = _to_x;
        to_y = _to_y;
    }

    /*
      udpate should be called in each frame
    */
    public void update() {
        super.update();
        /* "0.1 * vx" means friction */
        float ddx = (k * (to_x - x) - 0.1 * vx) / m;
        float ddy = (k * (to_y - y) - 0.1 * vy) / m;
        vx += int(ddx);
        vy += int(ddy);
        move();
    }

    private void move() {
        x += vx;
        y += vy;
    }

    public void display() {
        super.beforeDraw();
        displayDebug();
        displayText(canvas, 0, 0,
                    (float)DisplayWindowWidth/ManagerWindowFrameWidth,
                    (float)DisplayWindowHeight/ManagerWindowFrameHeight);
    }

    private void displayDebug() {
        displayText(managerWindow, ManagerWindowFrameWidth,
                    ManagerWindowFrameHeight * 2, 1.0, 1.0);
    }

    private void displayText(PApplet c, int offsetX, int offsetY,
                             float scaleX, float scaleY) {
        c.textFont(font);
        c.text(message,
               int(scaleX * x + drawDiff.x + offsetX),
               int(scaleY * y + drawDiff.y + offsetY));
    }
}

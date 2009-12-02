
public class Tweet extends SmoothDisplayObject{
    private int x, y;
    private float vx = 0.0, vy = 0.0;
    private float ax = 0.0, ay = 0.0;
    private float m;
    private String message;
    
    PApplet canvas;
    PFont font;
    private int offsetX, offsetY;
    

    public Tweet(int _x, int _y, String _text, PFont _font, int _color,
                 PApplet _canvas)
    {
        super(_color, random(0.1, 0.5),
              DisplayWindowFrameRate * (13 + int(random(0, 5))),
              DisplayWindowFrameRate, _canvas);
        x = _x;
        y = _y;
        while (vx == 0 && vy == 0) {
            vx = int(random(-2, 3));
            vy = int(random(-2, 3));
        }
        float d = sqrt(vx * vx + vy * vy) * random(0.2, 0.6);
        vx = int(vx / d);
        vy = int(vy / d);
        if (vx == 0 && vy == 0) {
         //   vx = - int(random(1, 3));
        }

        if (_text == null) {
            println("wrong message");
            _text = "<error>";
        }
        m = 20.0;// + _text.length() / 10;
        message = foldMessage(_text, DisplayWindowWidth / 3, _font);
        canvas = _canvas;
        font = _font;
        offsetX = offsetY = 0;
    }

    public void setOffset(int _offsetX, int _offsetY)
    {
        offsetX = _offsetX;
        offsetY = _offsetY;
    }

    public void update() {
        ax = bgforces.getForceX(x, y) / m;
        ay = bgforces.getForceY(x, y) / m;
        vx += ax;
        vy += ay;
        move();
        super.update();
    }

    public void cease() {
        super.cease();
    }

    public void move() {
        x += vx;
        y += vy;
    }

    public void display() {
        if (super.opacity <= 0) {
            return;
        }
        super.beforeDraw();
        displayText();
    }

    private void displayText() {
        canvas.textFont(font);
        canvas.text(message, x + offsetX, y + offsetY);
        
    }
}

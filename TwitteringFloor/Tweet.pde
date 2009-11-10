public class Tweet{
    private int x, y;
    private int vx = 0, vy = 0;
    private String message;
    private int fontColor;
    private int realColor;
    private float opacity;
    PApplet canvas;
    PFont font;
    private int offsetX, offsetY;
    private int ceasing = 0;

    public Tweet(int _x, int _y, String _text, PFont _font, int _color,
                 PApplet _canvas)
    {
        x = _x;
        y = _y;
        while (vx == 0 && vy == 0) {
            vx = int(random(-3, 4));
            vy = int(random(-3, 4));
        }

        message = _text;
        realColor = color(0x90, 0xee, 0x90);
        realColor = color(int(random(0xFF)),
                          int(random(0xFF)),
                          int(random(0xFF)));
        opacity = random(0.1, 0.5);
        setColor();
        canvas = _canvas;
        font = _font;
        offsetX = offsetY = 0;
    }

    public void setOffset(int _offsetX, int _offsetY)
    {
        offsetX = _offsetX;
        offsetY = _offsetY;
    }

    public void update(int _to_x, int _to_y) {
        setColor();
        move();
        if (x >= 100)
            cease();
    }

    public void cease() {
        ceasing = 1;
    }

    public void move() {
        x += vx;
        y += vy;
        if (ceasing > 0) {
            opacity -= 0.05;
        }
    }

    public void setColor() {
        int[] c = new int[3];
        if (opacity <= 0) {
            return;
        }
        for (int i=0; i<3; ++i) {
            int k = (realColor >> (8 * i)) & 0xFF;
            c[i] = 0xFF - int((0xFF - k) * opacity);
        }
        fontColor = color(c[2], c[1], c[0]);
    }

    public void display() {
        if (opacity <= 0) {
            return;
        }
        displayText();
    }

    public void displayText() {
        if (message == null || opacity <= 0) {
            return;
        }
        canvas.fill(fontColor);
        canvas.textFont(font);
        canvas.text(message, x + offsetX, y + offsetY);
    }
}

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
    
    // ballon info
    private int count = 1; // the number of '\n'
    private int ballonWidth;
    private int ballonHeight;
    private float ballonMargin = 20.0; // you have to set the margin
    private float ballonArc = 10.0; // you have to set the arc radius
    private float ballonSpace = 15.0; // 吹き出しの尖った部分の大きさの半分
    private float ballonDynamicSpace;
    private float fontHeight;
    private float ballonRatio;
    private float ballonTmpX, ballonTmpY;

    public Voice(int _x, int _y, String _text, PFont _font, PApplet _canvas,
                 int _offsetX, int _offsetY) {
        super(color(0x0), random(0.6, 0.9), 0,
              NODEBUG ? int(frameRate) : DisplayWindowFrameRate, _canvas);
        x = _x;
        y = _y;
        font = _font;
        message = foldMessage(_text, DisplayWindowWidth / 4, _font);
        println("Voice : " + _text);
//        message = _text;
        canvas = _canvas;
        debugOffsetX = _offsetX;
        debugOffsetY = _offsetY;
        vx = vy = 0;

        /* Adjusts the points to the center of the text field */
        drawDiff = textPointDiff(message, font);
        
        // decide the ballon info
        textFont(font);
        for(int i=0; i<message.length(); ++i){ if(message.charAt(i) == '\n') count++; }
        fontHeight = textAscent() + textDescent();
        ballonWidth = (int)(textWidth(message) + 2 * ballonMargin);
        ballonHeight = (int)(count * (fontHeight + 5.0) - 5.0 + 2 * ballonMargin);
        ballonRatio = random(0.2,0.8);
        ballonDynamicSpace = ballonSpace*(0.5+abs(0.5-ballonRatio));
        ballonTmpX = -0.4 * (drawDiff.x - ballonMargin + ballonWidth * ballonRatio);
        ballonTmpY = -0.4 * (drawDiff.y - ballonMargin + ballonHeight); 
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
        float ddx, ddy;
        if (false && vx < 2 && vy < 2) {
          ddx = k * (to_x - x) / m;
          ddy = k * (to_y - y) / m;
        } else {
          ddx = (k * (to_x - x) - 0.2 * vx) / m;
          ddy = (k * (to_y - y) - 0.2 * vy) / m;
        }
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
        if (!NODEBUG)
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
        
        // ----- creating Ballon begins ------        
        textLeading(fontHeight+5.0);
        int ballonX = (int)(scaleX * x + drawDiff.x + offsetX - ballonMargin);
        int ballonY = (int)(scaleY * y + drawDiff.y + offsetY - textAscent() - ballonMargin);
        // 枠
        line(ballonX+ballonArc, ballonY, ballonX+ballonWidth-ballonArc, ballonY);
        line(ballonX+ballonWidth, ballonY+ballonArc, ballonX+ballonWidth, ballonY+ballonHeight-ballonArc);
        line(ballonX+ballonWidth-ballonArc, ballonY+ballonHeight, ballonX+ballonWidth*ballonRatio+ballonDynamicSpace, ballonY+ballonHeight);
        // とがった部分
        line(ballonX+ballonWidth*ballonRatio+ballonDynamicSpace, ballonY+ballonHeight, ballonX+ballonWidth*ballonRatio+ballonTmpX, ballonY+ballonHeight+ballonTmpY);
        line(ballonX+ballonWidth*ballonRatio+ballonTmpX, ballonY+ballonHeight+ballonTmpY, ballonX+ballonWidth*ballonRatio-ballonDynamicSpace, ballonY+ballonHeight);
        // 枠
        line(ballonX+ballonWidth*ballonRatio-ballonDynamicSpace, ballonY+ballonHeight, ballonX+ballonArc, ballonY+ballonHeight);
        line(ballonX, ballonY+ballonHeight-ballonArc, ballonX, ballonY+ballonArc);
        // 角
        noFill();
        arc(ballonX+ballonArc, ballonY+ballonArc, 2*ballonArc, 2*ballonArc, PI, TWO_PI-HALF_PI);
        arc(ballonX+ballonWidth-ballonArc, ballonY+ballonArc, 2*ballonArc, 2*ballonArc, TWO_PI-HALF_PI, TWO_PI);
        arc(ballonX+ballonWidth-ballonArc, ballonY+ballonHeight-ballonArc, 2*ballonArc, 2*ballonArc, 0, HALF_PI);
        arc(ballonX+ballonArc, ballonY+ballonHeight-ballonArc, 2*ballonArc, 2*ballonArc, HALF_PI, PI);
        // ----- creating Ballon ends -----
        
        c.text(message,
               int(scaleX * x + drawDiff.x + offsetX),
               int(scaleY * y + drawDiff.y + offsetY));
        
        //c.line((int)(scaleX * x + drawDiff.x + offsetX), (int)(scaleY * y + drawDiff.y + offsetY - textAscent()), (int)(scaleX * x + drawDiff.x + offsetX + textWidth(message)), (int)(scaleY * y + drawDiff.y + offsetY - textAscent()));
        //c.line((int)(scaleX * x + drawDiff.x + offsetX), (int)(scaleY * y + drawDiff.y + offsetY - textAscent() + count * (fontHeight + 5) - 5), (int)(scaleX * x + drawDiff.x + offsetX + textWidth(message)), (int)(scaleY * y + drawDiff.y + offsetY - textAscent() + count * (fontHeight + 5) - 5));
    }
}

int ManagerWindowFrameWidth = 360; 
int ManagerWindowFrameHeight = 240; 

int ManagerWindowWidth = ManagerWindowFrameWidth * 2;
int ManagerWindowHeight = ManagerWindowFrameHeight * 3;

int DisplayWindowWidth = 1024;
int DisplayWindowHeight = 768;
int DisplayWindowFrameRate = 20;

void setup() {
    size(DisplayWindowWidth, DisplayWindowHeight);
    PFont font = createFont("Osaka", 20, true);
    tw = new PulledTweet(DisplayWindowWidth/2, DisplayWindowHeight/2,
                         "Hello, World", font, color(0x0), this);
}
PulledTweet tw;
void draw() {
    fill(255,255,255);
    rect(0, 0, DisplayWindowWidth, DisplayWindowHeight);

    frameRate(20);
    tw.update();
    tw.display();
}

public class PulledTweet extends SmoothDisplayObject{
    private int x, y;
    private int vx = 0, vy = 0;
    private String message;
    PApplet canvas;
    PFont font;
    float theta, omega;
    private int offsetX, offsetY;
    private int to_x, to_y;
    private int w, h;
    private float m = 1.0;

    public PulledTweet(int _x, int _y, String _text, PFont _font, int _color,
                 PApplet _canvas)
    {
        super(_color, random(0.1, 0.5),
              DisplayWindowFrameRate * (10 + int(random(0, 3))),
              DisplayWindowFrameRate, _canvas);
        x = _x;
        y = _y;
        vy = vx = 0;

        if (_text == null) {
            println("wrong message");
            _text = "<error>";
        }
        message = foldMessage(_text, 700, _font);
        w = (int)textWidth(message);
        h = 10;
        canvas = _canvas;
        font = _font;
        offsetX = offsetY = 0;
        theta = 0;
        omega = 0.1;
        to_x = 0;
        to_y = -1;
    }

    public void setOffset(int _offsetX, int _offsetY)
    {
        offsetX = _offsetX;
        offsetY = _offsetY;
    }

    public void updateForce(int _to_x, int _to_y) {
        to_x = _to_x;
        to_y = _to_y;
    }

    public void update() {
        float ddx = to_x / m;
        float ddy = to_y / m;
        vx += int(ddx);
        vy += int(ddy);
        omega = (w / 2.0 * vy - h / 2.0 * vx) / (vx * vx + vy * vy) / 100.0;
        move();
        super.update();

    }

    public void cease() {
        super.cease();
    }

    public void move() {
        x += vx;
        println(vx);
        y += vy;
        theta += omega;
        
    }

    public void display() {
        if (super.opacity <= 0) {
            return;
        }
        super.beforeDraw();
        translate(x + w/2, y + h/2);
        rotate(theta);

        displayText();
    }

    private void displayText() {
        canvas.textFont(font);
        canvas.text(message, offsetX - w/2, offsetY - h/2);
    }
}


/*
  Objects that appears and disappears gradually.

  The update() must called in each frame
  To display the object inherit SmoothDisplayObject,
  it call super.setColor() bofore drawing itself

  If lifespan < 0, then the object does not cease automatically
 */
public class SmoothDisplayObject {
    private float opacity = 0;
    private int frameCount = 0;
    private PApplet canvas;
    private int ceasing = 0;
    private int realColor;
    private int drawColor;
    private int lifespan = 10000;
    private int lastUpdate;
    private int appearDuration;

    public SmoothDisplayObject(int col, float _opacity,
                               int _lifespan, int _appearDuration,
                               PApplet c) {
        realColor = col;
        opacity = _opacity;
        lifespan = _lifespan;
        canvas = c;
        appearDuration = _appearDuration;
    }

    public void update() {
        setColor();
        frameCount++;
        lastUpdate = canvas.frameCount;
        if (lifespan > 0 && ceasing == 0 && frameCount >= lifespan)
            cease();
    }


    private void setColor() {
        int[] c = new int[3];
        if (opacity <= 0)
            return;
        float op = opacity;
        if (opacity <= 0) {
            return;
        }

        if (frameCount < appearDuration) {
            op *= (float)frameCount / appearDuration;
        } else if (ceasing > 0) {
            opacity -= 0.02;
        }

        for (int i=0; i<3; ++i) {
            int k = (realColor >> (8 * i)) & 0xFF;
            c[i] = 0xFF - int((0xFF - k) * op);
        }
        drawColor = color(c[2], c[1], c[0]);
    }

    /*
      cease() will be called automatically in update()
      or in Shadow.startDisappear() / updateShadowByBlobtops().
     */
    public void cease() {
        ceasing = 1;
    }

    public Boolean isDisappeared() {
        return opacity <= 0;
    }

    public void beforeDraw() {
        if (opacity <= 0)
            return;
        if (canvas.frameCount != lastUpdate) {
            update();
        }
        canvas.fill(drawColor);
    }
}

// strとwidthは予約語かも、ローカルなので問題はないと思う
String foldMessage(String str, int width, PFont font){
  return foldMessage(str, width, font, false);
}

String foldMessage(String str, int width, PFont font, boolean printDebug){
  String _str = new String();
  textFont(font);
  int pointer = 0;
  for(int i=0; i<str.length(); ++i){
    // pointer ~ i文字目でwidthを超えるかどうかをチェックする
    if( textWidth(str.substring(pointer, i+1)) > width ){
      // 最後の文字なら無視
      //if(i+1==str.length()){ break; }
      // 改行した場合の行頭の文字を見る
      char c = str.charAt(i);
      switch(c){
        // 行頭がスペース/タブ/改行の場合、その文字を無視するためpointerを1つ進める
        case ' ':
        case '　':
        case '\t':
        case '\n':
          if(printDebug){ print("スペース/タブ/改行の場合、"); }
          _str += str.substring(pointer, i) + "\n";
          pointer = i+1;
          break;
        // 行頭が句読点の場合、句読点を行末に移動させる
        case '、':
        case '。':
        case '!':
        case '！':
        case '?':
        case '？':
          if(printDebug){ print("句読点の場合、"); }
          _str += str.substring(pointer, i+1) + "\n";
          pointer = i+1;
          break;
        default:
          // 英数字の場合
          if(33<=c && c<=126){
            if(printDebug){ print("英数字だよ、"); }
            for(int j=i-1; j>=max(i-4, 0); --j){
              if(33<=str.charAt(j) && str.charAt(j)<=126){
                if(j==max(i-4,0)){
                  _str += str.substring(pointer, i) + "\n";
                  pointer = i;
                }
              }
              else{
                _str += str.substring(pointer, j+1) + "\n";
               pointer = j+1;
               break;
              }
            }
          }
          // 通常の改行
          else{
            _str += str.substring(pointer, i) + "\n";
            pointer = i;
          }
          break;
      }
    }
  }
  _str += str.substring(pointer, str.length());
  if(printDebug){ println(); }
  
  /*
  String _str = new String();
  int pointer = 0;
  for(int i=1; i<=str.length(); ++i){
    if( textWidth(str.substring(pointer, i)) > width ){
      _str += str.substring(pointer, i-1) + "\n";
      pointer = i-1;
    }
  }
  _str += str.substring(pointer, str.length());
  */
  return _str;
}

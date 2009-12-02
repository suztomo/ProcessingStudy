int ShadowNearbyThreathold = ManagerWindowFrameWidth / 6;
int ShadowGetLostThrethold = 10;

VoiceGenerator vfactory = null;


public class Shadow{
    public int x, y;
    public int bx, by;
    private Voice voice;
    public Boolean updated;
    private int lastUpdate;
    private PApplet canvas;
    private int updatePointCount = 0;
    private int changeForceInterval;
    
    public Shadow(int _x, int _y, PApplet _canvas) {
        x = bx = _x;
        y = by = _y;
        String message = "あしもとをみて\niii Exhibition 11";
        if (vfactory != null) {
          message = vfactory.getVoice();
        }
        canvas = _canvas;
        PFont font = getFontSizeof(FontsBySize.length);
        voice = new Voice(_x, _y, message, font, _canvas,
                          ManagerWindowFrameWidth, ManagerWindowFrameHeight*2);
        updated = false;
        lastUpdate = canvas.frameCount;
        changeForceInterval = int(canvas.frameRate / 5);
    }


    /*
      should be called in each frame
     */
    public void update() {
        voice.update();
    }

    public void updatePoint(Point p) {
        x = p.x;
        y = p.y;
        lastUpdate = canvas.frameCount;
        updateVoice(x, y);
        updatePointCount++;
        
        // update background force
        if (updatePointCount % changeForceInterval == 0) {
          bgforces.changeForce(x, y, float(x - bx) * 1.0, float(y - by) * 1.0);
          by = y;
          bx = x;
        }
    }

    private void updateVoice(int to_x, int to_y) {
        voice.updatePoint(to_x, to_y);
    }
    /*
    public Boolean isNearBy(int _x, int _y) {
        return (_x - x) * (_x - x) + (_y - y) * (_y - y)
            < ShadowNearbyThreathold * ShadowNearbyThreathold;
    }*/

    public Boolean isGetLost() {
        return canvas.frameCount - lastUpdate > ShadowGetLostThrethold;
    }

    public void startDisappear() {
        voice.cease();
    }

    public Boolean isDisappeared() {
        return voice.isDisappeared();
    }


    public Boolean isNearBy(Point p) {
        return (p.x - x) * (p.x - x) + (p.y - y) * (p.y - y)
            < ShadowNearbyThreathold * ShadowNearbyThreathold;
    }

    /*
      Do not display until 5 counts
     */
    public void displayVoice() {
        if (updatePointCount > 5)
            voice.display();
    }
}

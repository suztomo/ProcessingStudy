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
        if (opacity < 0)
            return;
        float op = opacity;
        if (opacity < 0) {
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
        if (opacity < 0) {
            canvas.fill(color(0xFF, 0));
            return;
        }
        if (canvas.frameCount != lastUpdate) {
            update();
        }
        canvas.fill(drawColor);
        canvas.stroke(drawColor);
    }
}

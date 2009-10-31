int ShadowNearbyThreathold = 100;

public class Shadow{
    private int x, y;
    private int to_x, to_y;
    private Voice voice;
    public Shadow(int _x, int _y, PApplet canvas) {
        x = _x;
        y = _y;
        String message = "Hello, World";
        PFont font = selectFont(message);
        voice = new Voice(_x, _y, message, font, canvas,
                          0, ManagerWindowFrameHeight*2);
    }

    public void update(int _x, int _y) {
        x = _x;
        y = _y;
        updateVoice(_x, _y);
    }

    public void updateVoice(int _to_x, int _to_y) {
        voice.update(_to_x, _to_y);
    }

    public Boolean isNearBy(int _x, int _y) {
        return (_x - x) * (_x - x) + (_y - y) * (_y - y)
            < ShadowNearbyThreathold * ShadowNearbyThreathold;
    }

    public void displayVoice() {
        voice.display();
    }
}

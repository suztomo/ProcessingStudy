int ShadowNearbyThreathold = ManagerWindowFrameWidth / 6;

public class Shadow{
    public int x, y;
    private Voice voice;
    public Boolean updated;
    public Shadow(int _x, int _y, PApplet canvas) {
        x = _x;
        y = _y;
        String message = "Hello\n World";
        
        PFont font = selectFont(message);
        voice = new Voice(_x, _y, message, font, canvas,
                          ManagerWindowFrameWidth, ManagerWindowFrameHeight*2);
        updated = false;

    }

    public void updatePoint(Point p) {
        x = p.x;
        y = p.y;
        updateVoice(x, y);
    }

    private void updateVoice(int to_x, int to_y) {
        voice.update(to_x, to_y);
    }
    /*
    public Boolean isNearBy(int _x, int _y) {
        return (_x - x) * (_x - x) + (_y - y) * (_y - y)
            < ShadowNearbyThreathold * ShadowNearbyThreathold;
    }*/

    public Boolean isNearBy(Point p) {
        return (p.x - x) * (p.x - x) + (p.y - y) * (p.y - y)
            < ShadowNearbyThreathold * ShadowNearbyThreathold;
    }

    public void displayVoice() {
        voice.display();
    }
}

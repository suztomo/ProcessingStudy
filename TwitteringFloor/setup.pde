void setup() {
    size( ManagerWindowWidth, ManagerWindowHeight );
    opencv = new OpenCV( this );
    opencv.capture( ManagerWindowFrameWidth, ManagerWindowFrameHeight );

    opencv.read();     // grab frame from camera
    opencv.remember();  // store the actual image in memory
    corners = new Point[3];
    fr = new DebugFrame();
    PFont font = createFont("Osaka", 20);
    textFont(font);

    readPointFile();
}

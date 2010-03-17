import processing.net.*;

Client myClient;
int dataIn;
byte[] byteBuffer = new byte[1024];
PFont font;

void setup() {
    size(200, 200);
    myClient = new Client(this, "127.0.0.1", 8080);
    font = createFont("FFScala", 32);
    textFont(font);
}

void draw() {
    //    println("日本語は表示できないかな");


// ClientEvent message is generated when the server 
// sends data to an existing client.

    if (myClient.available() > 0) {
        int byteCount = myClient.readBytes(byteBuffer);
        if (byteCount > 0 ) {
            // Convert the byte array to a String
            String myString;
            try {
                myString = new String(byteBuffer, "UTF-8");
            } catch (UnsupportedEncodingException e) {
                myString = "error";
                e.printStackTrace();
            }
            // Show it text area
            println(myString);
            text(myString, 30, 30);
        }
    }
}

import java.net.URLEncoder;
import java.net.Authenticator;
void setup() {
  size(100, 100);
  String todai_j = "東大";
  String todai = java.net.URLEncoder.encode(todai_j);
  println(todai);
//  String todai = "%E6%9D%B1%E5%A4%A7";
  String hoge = "http://search.twitter.com/search.atom?q=";
  println(hoge + todai);
  XMLElement xml = new XMLElement(this, "http://search.twitter.com/search.atom?q=" + todai);
  int numSites = xml.getChildCount();
  println(numSites);
  
  PrintWriter output = createWriter(todai + ".txt");
  for (int i = 0; i < numSites; i++) {
    XMLElement entry = xml.getChild(i);
    if (entry.getName().equals("entry")) {
      XMLElement title = entry.getChild(3);
      String message = title.getContent();
      println(message);
      output.println(message);
    }
  }
  output.flush();
  output.close();
  
  noLoop();
  
}

void draw() {

}


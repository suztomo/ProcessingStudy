
import java.net.URLEncoder;
import java.net.Authenticator;

void setup() {
  size(100, 100);
  String todai_j = "東大";
  println(todai_j);
  String todai ;
  try {
    todai = java.net.URLEncoder.encode(todai_j, "UTF-8");
  } catch (UnsupportedEncodingException e) {
    todai = null;
  }

  Pattern atptn = Pattern.compile("@[a-zA-Z_]*");

  if (todai.equals("%E6%9D%B1%E5%A4%A7")) {
    println("OK!");
  } else {
    println("NG...");
  }
  println(todai);

  String head = "http://search.twitter.com/search.atom?q=";
  println(head + todai);
  XMLElement xml = new XMLElement(this, head + todai);
  int numSites = xml.getChildCount();
  println(numSites);
  
  PrintWriter output = createWriter(todai_j + ".txt");
  for (int i = 0; i < numSites; i++) {
    XMLElement entry = xml.getChild(i);
    if (entry.getName().equals("entry")) {
      XMLElement title = entry.getChild(3);
      Matcher m = atptn.matcher(title.getContent());
      String message = m.replaceAll("");
      println(message);
      output.println(message);
    }
  }
  output.flush();
  output.close();
  noLoop();
  exit();
}

void draw() {

}


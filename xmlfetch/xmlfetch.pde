import java.net.URLEncoder;
import java.net.Authenticator;



/*
  Updates some {keyworkd}.txt in the keyword directory
  of TwitteringFloor

*/

int windowWidth = 242;
int windowHeight = 100;

/*
  0 on success
  1 otherwise.
*/
int writeKeyword(String keyword) {
  String encoded_keyword;
  try {
    encoded_keyword = java.net.URLEncoder.encode(keyword, "UTF-8");
  } catch (UnsupportedEncodingException e) {
    encoded_keyword = null;
  }

  Pattern atptn = Pattern.compile("@[a-zA-Z_]*");
/*
  if (todai.equals("%E6%9D%B1%E5%A4%A7")) {
    println("OK!");
  } else {
    println("NG...");
  }
  println(todai);
*/
  String head = "http://search.twitter.com/search.atom?q=+";
feed://search.twitter.com/search.atom?q=+早稲田+OR+東大
  /* Any Exception? */
  XMLElement xml;
  xml = new XMLElement(this, head + encoded_keyword);
  int numSites = xml.getChildCount();
  
  PrintWriter output = createWriter(keyword + ".txt");
  log("Loaded " + numSites + " entries for " + keyword);
  for (int i = 0; i < numSites; i++) {
    XMLElement entry = xml.getChild(i);
    if (entry.getName().equals("entry")) {
      XMLElement title = entry.getChild(3);
      Matcher m = atptn.matcher(title.getContent());
      String message = m.replaceAll("");
      output.println(message);
    }
  }
  output.flush();
  output.close();
  return 0;
}

int loadPeriod = 60 * 2;

void setup() {
  background(color(0xFF));
  size(windowWidth, windowHeight);
  PFont font = createFont("AgencyFB-Bold", 16);
  fill(0);
  textFont(font);
  
  text("Loads tweets every " + loadPeriod + " sec.", 10, 26);
  frameRate(1);
}

void draw() {
  delay(loadPeriod * 1000);
  fill(0xFF);
  rect(0, 30, windowWidth, windowHeight);
  try {
    writeKeyword("東大");
    
    msg("Updated.");
  } catch (Exception e) {
    msg("Error when loading"); 
  }
}

void msg(String str) {
  fill(0x33);
  text(hour() + ":" + minute() + ":" + second() + " " + str, 10, 70);  
}

void log(String str) {
  print(hour() + ":" + minute() + ":" + second() + " ");
  println(str);
}


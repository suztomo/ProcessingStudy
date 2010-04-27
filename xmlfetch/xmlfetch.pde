String [] ary;

void setup() {
  size(800, 600);
  background(255,255,255);
  frameRate(1);
  PFont metaBold = loadFont("Menlo-Bold-48.vlw");
  textFont(metaBold, 44);
  ary = new String[10];
  XMLElement xml = new XMLElement(this, "http://search.twitter.com/search.atom?q=");
  int numSites = xml.getChildCount();
  for (int i = 0; i < numSites; i++) {
    XMLElement kid = xml.getChild(i);
    if (kid.getName().equals("entry")) {
      XMLElement title = kid.getChild(3);
      String titleStr = title.getContent();
      println(i + " : " + titleStr);
      ary[i%10] = titleStr;
    }
  }
}

int count = 0;
void draw() {
  background(0xFF);
  fill(0);
  text(ary[count%10], 100, 100, 500, 300);
  count++;
}





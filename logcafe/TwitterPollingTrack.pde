import org.json.*;
import processing.net.*;

public class TwitterPollingTrack {
    private PApplet parent;
    private final String twitterPollingURLPrefix = "http://search.twitter.com/search.atom?q=";
    private final String encoding = "UTF-8";
    private String twitterPollingURL;
    private String keywords;
    private Pattern HTTPBodyPattern = Pattern.compile("\r\n\r\n[^{]+\r\n(.*)", Pattern.DOTALL);
    private Pattern atptn = Pattern.compile("@[a-zA-Z_]*");
    private Pattern namePattern = Pattern.compile("([^\\s]+)\\s\\((.*)\\)");
    private Pattern idPattern = Pattern.compile(".+:.+:(.+)");
    private String lastUpdatedID = "0";

    /*
      parent: usually this
      keyword: keyword list, comma separated
    */
    public TwitterPollingTrack(PApplet parent, String keywords) {
        this.parent = parent;
        this.keywords = keywords;
        String encoded_keywords = "logcafe";
        try {
            encoded_keywords= java.net.URLEncoder.encode(keywords, encoding);
            encoded_keywords = encoded_keywords.replaceAll("__PLUS__", "+");
        } catch (UnsupportedEncodingException e) {
            println(e.toString());
        }
        twitterPollingURL = twitterPollingURLPrefix + encoded_keywords;
    }

    private XMLElement fetchXML() {
        XMLElement xml;
        String xmlString;
        try {
            String lines[] = loadStrings(twitterPollingURL);
            if (lines == null) {
                println("accessing twitter failed");
                return null;
            }
            xmlString = join(lines, "");
            xml = new XMLElement(xmlString);
        } catch(Exception e) {
            println(e.toString());
            return null;
        }

        //        xml = new XMLElement(parent, twitterPollingURL);
        return xml;
    }

    // "Wed Mar 17 04:23:41 +0000 2010" => "20100317042341"
    private SimpleDateFormat incomingFormat =
        new SimpleDateFormat("yyyy-MM-dd hh:mm:ss", Locale.US);
    private SimpleDateFormat outgoingFormat =
        new SimpleDateFormat("yyyyMMddHHmmss");
    private TimeZone outgoingTZ = TimeZone.getTimeZone("Asia/Tokyo");
    private TimeZone incomingTZ = TimeZone.getTimeZone("Europe/London");

    private Tweet[] processXML(XMLElement xml) {
        if (xml == null) {
            return new Tweet[0];
        }
        int numElements = xml.getChildCount();
        Tweet[] store = new Tweet[numElements];
        int count = 0;
        Matcher m;
        for (int i=numElements-1; i>=0; --i) {
            XMLElement entry = xml.getChild(i);
            if (entry.getName().equals("entry")) {
                XMLElement idTag = entry.getChild(0);
                String idContent = idTag.getContent();
                m  = idPattern.matcher(idContent);
                if (!m.find()) {
                    continue;
                }
                String idNum = m.group(1);
                if (lastUpdatedID.compareTo(idNum) >= 0) {
                    continue;
                }
                lastUpdatedID = idNum;
                XMLElement title = entry.getChild(3);
                String message = title.getContent();

                XMLElement publishedTag = entry.getChild(1);
                // 2010-03-19T07:36:41Z
                // 2010-03-19T07:43:09Z
                String published = publishedTag.getContent().replaceAll("[A-Z]"," ");
                String created = "20100317042341";
                try {
                    Date d;
                    incomingFormat.setTimeZone(incomingTZ);
                    d = incomingFormat.parse(published);
                    created = outgoingFormat.format(d);
                } catch (ParseException e) {
                    println(e.toString());
                }


                XMLElement author = entry.getChild(10);
                XMLElement authorName = author.getChild(0);
                String name = authorName.getContent();
                Matcher matcher = namePattern.matcher(name);
                if (!matcher.find()) {
                    println("invalid format for username");
                    return new Tweet[0];
                }
                String screenName = matcher.group(1);
                String realName = matcher.group(2);
                Tweet t = new Tweet(message, screenName, realName, created);
                store[count] = t;
                count++;
            }
        }
        Tweet[] ret = new Tweet[count];
        for (int i=0; i<count; ++i) {
            ret[i] = store[i];
        }
        return ret;
    }

    public Tweet[] getNewTweets() {
        return processXML(fetchXML());
    }
}


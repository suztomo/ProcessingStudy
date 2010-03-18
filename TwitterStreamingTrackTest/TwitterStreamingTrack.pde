import org.json.*;
import biz.source_code.*;
import processing.net.*;

public class TwitterStreamingTrack {
    private PApplet parent;
    private Client client;
    private int byteBuffersNum = 10;
    private byte[][] byteBuffers = new byte[byteBuffersNum][4096];
    private byte[] currentByteBuffer;
    private int byteBuffersIndex = 0;
    private int byteBuffersStart = 0;
    private int[] byteBuffersSizes = new int[byteBuffersNum];
    private String encoding = "UTF-8";
    private final String twitterStreamingServer="stream.twitter.com";
    //private final String twitterStreamingServer="localhost";
    private final String twitterStreamingMethod="POST";
    private final int twitterStreamingPort=80;
    private final String twitterStreamingPath="/1/statuses/filter.json";
    private final String twitterStreamingAuthUser="Univ_of_Tokyo";
    private final String twitterStreamingAuthPass="hogefuga";
    private String authKey;
    private Tweet recentTweet = null;

    private Pattern HTTPResponsePattern = Pattern.compile("(HTTP/1.1 (\\d+).+)");
    private Pattern HTTPBodyPattern1 = Pattern.compile("\r\n\r\n[^{]+\r\n(.*)", Pattern.DOTALL);
    private Pattern HTTPBodyPattern2 = Pattern.compile("[0-9A-Z]\r\n(.*)", Pattern.DOTALL);


    /*
      parent: usually this
      keyword: keyword list, comma separated
      container: Twit Array.
    */
    public TwitterStreamingTrack(PApplet parent, String keywords) {
        this.parent = parent;
        initClient();
        prepareAuthKey();
        
        String encoded_keywords = "logcafe";
        try {
            encoded_keywords= java.net.URLEncoder.encode(keywords, encoding);
        } catch (UnsupportedEncodingException e) {
            println(e.toString());
        }
        sendHTTPRequest(encoded_keywords);
        currentByteBuffer = byteBuffers[byteBuffersIndex];
    }

    /*
      This method should be called each frame.
    */
    public Tweet getNewTweet() {
        recentTweet = null;
        checkBytes();
        return recentTweet;
    }

    private void initClient() {
        client = new Client(parent, twitterStreamingServer,
                            twitterStreamingPort);
    }

    private void prepareAuthKey() {
        /*
          http://www.source-code.biz/base64coder/java/
        */
        authKey = Base64Coder.encodeString(twitterStreamingAuthUser + ":" +
                                           twitterStreamingAuthPass);

    }

    private void sendHTTPRequest(String keywords) {
        sendPostRequest("track="+keywords);
    }
    /*
      requestBody is assumed to be already url-encoded (?).
    */
    private void sendPostRequest(String requestBody) {
        String requestLine = twitterStreamingMethod + " "
            + twitterStreamingPath + " HTTP/1.1";
        String hostParam = "Host: " + twitterStreamingServer + ":" +
            twitterStreamingPort;
        String userAgentParam = "User-Agent: curl/7.19.4 (universal-apple-darwin10.0) libcurl/7.19.4 OpenSSL/0.9.8l zlib/1.2.3";
        String authParam = "Authorization: Basic " + authKey;
        String acceptParam = "Accept: " + "*"+ "/"+"*";
        String contentLengthParam = "Content-Length: " + requestBody.length();
        String contentTypeParam = "Content-Type: application/x-www-form-urlencoded";
        sendln(requestLine);
        sendln(authParam);
        sendln(userAgentParam);
        sendln(hostParam);
        sendln(acceptParam);
        sendln(contentLengthParam);
        sendln(contentTypeParam);
        sendln("");// empty line before request body
        sendln(requestBody);
        sendln("");
        sendln(""); // end of request, that is two new line
    }

    private void sendln(String line) {
        client.write(line + "\r\n");
    }

    private void clearByteBuffer(byte[] buf) {
        for (int i = 0; i<buf.length; ++i) {
            buf[i] = 0;
        }
    }


    private void checkBytes() {
        if (client.available() > 0) {
            int byteCount = client.readBytes(currentByteBuffer);
            if (byteCount > 0 ) {
                String response;
                byteBuffersSizes[byteBuffersIndex] = byteCount;
                //                println("received: " + byteCount + " to buffer#" + byteBuffersIndex);

                int r =  processByteBuffers();
                if (r == 0) {
                    byteBuffersStart = (byteBuffersIndex+1)%byteBuffersNum;
                }
                byteBuffersIndex = (byteBuffersIndex+1)%byteBuffersNum;
                currentByteBuffer = byteBuffers[byteBuffersIndex];
                clearByteBuffer(currentByteBuffer);
            }
        }
    }

    private int processByteBuffers() {
        int ssize = 1<<13;
        byte[] s = new byte[ssize];
        int i;
        int k = byteBuffersStart;
        String response;
        /*
          append butters to the first.
          buteBuffersStart = 7, byteBuffersIndex = 0.
          - byteBuffers[7] = {a, b, c}  (s)
          - byteBuffers[8] = {k, l}
          - byteBuffers[9] = {j}
          - byteBuffers[0] = {r, t, i}
          - byteBuffers[1] = {a, o}

          => s = {a, b, c, k, l, j, r, t, i, a, o}

        */
        for (i=0; i<ssize; ++i) {
            s[i] = 0;
        }
        for (i=0; i<byteBuffersSizes[byteBuffersStart]; ++i) {
            s[i] = byteBuffers[k][i];
        }
        k = (k+1) % byteBuffersNum;
        i = byteBuffersSizes[byteBuffersStart];
        //        println("startBuffer's size: " + i);
        if (byteBuffersIndex != byteBuffersStart) {
            while(true){
                byte[] b = byteBuffers[k];
                int bs = byteBuffersSizes[k];
                for (int j=0; j<bs; ++j) {
                    s[i] = b[j];
                    ++i;
                    if (i>=ssize) {
                        // reset the buffer, but doesn't update recentTweet
                        return 0;
                    }
                }
                //                println("appended size:" + bs);
                if (k == byteBuffersIndex) break;
                k = (k+1)%byteBuffersNum;
            }
        }
        try {
            response = new String(s, encoding);
        } catch (UnsupportedEncodingException e) {
            response = "encoding error";
        }
        return processHTTPResponse(response);
    }

    private int processHTTPResponse(String response) {
        Boolean ret;
        String responseBody;
        String statusLine, statusCode;
        Matcher matcher;
        matcher = HTTPResponsePattern.matcher(response);
        // matches the first occurance.
        if (matcher.find()) {
            statusLine = matcher.group(1);
            statusCode = matcher.group(2);
            println("status: " + statusCode);
            if (!statusCode.equals("200")) {
                println("Error: status line is " + statusLine);
                return -1;
            }
        }
        matcher = HTTPBodyPattern1.matcher(response);
        if (!matcher.find()) {
            matcher = HTTPBodyPattern2.matcher(response);
            if (!matcher.find()) {
                return -1;
            }
        }
        responseBody = matcher.group(1);
        return processHTTPResponseBody(responseBody);
    }

    private int processHTTPResponseBody(String responseBody) {
        String twitScreenName, twitRealName;
        JSONObject j, user;
        String twitPostedTime;
        String twitText;

        try {
            //            println(responseBody);
            j = new JSONObject(responseBody);
            // if an exception occurs, go to checkBytes.

            twitText = j.getString("text");
            user = j.getJSONObject("user");
            twitScreenName = user.getString("screen_name");
            twitRealName = user.getString("name");
            twitPostedTime = j.getString("created_at");
            recentTweet = new Tweet(twitText, twitScreenName,
                                    twitRealName, twitPostedTime);
        } catch(JSONException e) {
            return -2;
        }
        // yatta-
        return 0;
    }
}


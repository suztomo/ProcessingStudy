import twitter4j.org.json.*;
import twitter4j.*;
import twitter4j.http.*;
import twitter4j.examples.*;


void setup(){
  size(600, 800); 
  PFont f= createFont("Osaka", 20);
  textFont(f);
  text("nihongo日本語", 10, 10); 
  try{
    //ユーザ名とパスワード
    Twitter twitter = new Twitter("suztomo","testpass");
    //メッセージ
    java.util.List statuses = twitter.getFriendsStatuses();
    println(statuses.size());
//    Status status = (Status)statuses.get(0);
    for (int i=0; i < statuses.size(); ++i) {
      User user = (User)statuses.get(i);
      println(str(i) + ":" + user.getScreenName() + " < " + user.getStatusText());
      text(str(i) + ":" + user.getScreenName() + " < " + user.getStatusText(), 0, i * 20);
    }
  }catch(Exception e){
    println("Error");
    System.out.print(e.getMessage());
  }
}

void draw(){
}


public class Tweet{
  String msg;
  String scname;
  String username;
  String time;
  int lines;
 
  Tweet(){
    msg = "";
    scname = "";
    username = "";
    time = "";
  }
 
  Tweet(String _msg, String _scname, String _username, String _time){
    msg = _msg;
    scname = _scname;
    username = _username;
    time = _time;
  }
}
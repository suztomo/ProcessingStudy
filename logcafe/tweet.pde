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
  
  public void insertReturn(float _width){
    lines = 1;
    textFont(defaultFont);
    int pointer = 0;
    String _msg = "";
    for(int i=0; i<
    msg.length(); ++i){
      if( textWidth( msg.substring(pointer, i+1) ) > _width-1){
        _msg += msg.substring(pointer, i) + "\n";
        pointer = i;
        lines++;
      }
    }
    msg = _msg + msg.substring(pointer);
  }
}

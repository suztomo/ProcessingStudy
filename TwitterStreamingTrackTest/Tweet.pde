public class Tweet{
    public String msg;
    public String scname;
    public String username;
    public String time;

    public Tweet(){
        msg = "";
        scname = "";
        username = "";
        time = "";
    }

    public Tweet(String _msg, String _scname, String _username, String _time) {
        msg = _msg;
        scname = _scname;
        username = _username;
        time = _time;
    }
}
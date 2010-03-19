public class FuwaTweet{
  private Tweet tweet;
  color cl;
  float posX;
  float posY;
  float dirX;
  float dirY;
  float speed;
  float tmp_speed;
  int ttl;
  int sub_ttl;
  int state;

  int ballonWidth;
  int ballonHeight;
  int ballonArc;
  
  FuwaTweet(){
    this.init();
  }
  
  FuwaTweet(Tweet _tweet){
    tweet = _tweet;
    this.init();
  }
  
  FuwaTweet(String _msg, String _scname, String _username, String _time){
    tweet = new Tweet(_msg, _scname, _username, _time);
    this.init();
  }
  
  private void init(){
    tweet.insertReturn(defaultBallonWidth);
    cl = colors[(int)random(6)];
    posX = random(miniFrameSize, windowWidth-miniFrameSize-defaultBallonWidth);
    //posX = -(defaultBallonWidth+defaultBallonArc);
    posY = random(miniFrameSize, windowHeight-miniFrameSize-defaultBallonHeightLine*tweet.lines);
    float angle = random(0, 360) / 180.0 * PI;
    dirX = cos(angle);
    dirY = sin(angle);
    speed = 1.0;
    tmp_speed = 0;
    ttl = TTL * framerate;
    sub_ttl = subTTL * framerate;
    state = 0;
    
    ballonWidth = defaultBallonWidth;
    ballonHeight = defaultBallonHeightLine * (tweet.lines + 2);
    ballonArc = defaultBallonArc;
  }
  
  private String timeToString(){
    return
      tweet.time.substring(0,4)+"年"+
      tweet.time.substring(4,6)+"月"+
      tweet.time.substring(6,8)+"日"+
      tweet.time.substring(8,10)+":"+
      tweet.time.substring(10,12)+":"+
      tweet.time.substring(12,14);
  }
  
  public void update(){
    posX += dirX * speed;
    posY += dirY * speed;
    
    // reflection
    if(dirX<0 && posX<ballonArc){
      dirX = -dirX; // reflect
    }
    else if(dirX>0 && windowWidth<posX+ballonWidth+ballonArc){
      dirX = -dirX; // reflect
    }
    if(dirY<0 && posY<ballonArc){
      dirY = -dirY;
    }
    else if(dirY>0 && windowHeight<posY+ballonHeight+ballonArc){
      dirY = -dirY; // reflect
    }
    
    // speed
    if(frame == 10){
      if(tmp_speed > 6){
        speed = int(tmp_speed);
      }
      else if(tmp_speed > 3){
        speed= 5.0;
      }
      else{
        speed = 1.0;
      }
      //println(tmp_speed);
      tmp_speed = 0;
    }
    else{
      tmp_speed += abs(in.left.get(0)) + abs(in.right.get(0));
    }
    
    ttl--;
    if(ttl < -100 * framerate){ ttl = -1; }
  }
  
  public boolean inUpdate(){
    posX += speed;
    
    if(posX >= ballonArc+5){ state = 1; return true; }
    return false;
  }
  
  public boolean outUpdate(){
    posX += dirX * speed * 5;
    posY += dirY * speed * 5;
    
    if(posX<-(ballonWidth+ballonArc) || posX>windowWidth+ballonArc || posY<-(ballonHeight+ballonArc) || posY>windowHeight+ballonArc){
      return true;
    }

    return false;
  }
  
  public void draw(){
    /*
    // no fill ballon
    noFill();
    stroke(cl);
    arc(posX, posY, 2*ballonArc, 2*ballonArc, PI, PI+HALF_PI);
    arc(posX+ballonWidth, posY, 2*ballonArc, 2*ballonArc, PI+HALF_PI, TWO_PI);
    arc(posX+ballonWidth, posY+ballonHeight, 2*ballonArc, 2*ballonArc, 0, HALF_PI);
    arc(posX, posY+ballonHeight, 2*ballonArc, 2*ballonArc, HALF_PI, PI);
    line(posX, posY-ballonArc, posX+ballonWidth, posY-ballonArc);
    line(posX+ballonWidth+ballonArc, posY, posX+ballonWidth+ballonArc, posY+ballonHeight);
    line(posX-ballonArc, posY, posX-ballonArc, posY+ballonHeight);
    line(posX, posY+ballonHeight+ballonArc, posX+ballonWidth, posY+ballonHeight+ballonArc);
    //rect(posX, posY, ballonWidth, ballonHeight);
    
    fill(255);
    text(tweet.msg, posX, posY, ballonWidth, ballonHeight);
    textAlign(RIGHT);
    text("@"+tweet.scname+"\n"+timeToString(), posX, posY+ballonHeight-2*defaultBallonHeightLine, ballonWidth, 2*defaultBallonHeightLine);
    textAlign(LEFT);
    */
    
    // fill ballon
    // draw white ballon
    fill(255);
    stroke(255);
    arc(posX, posY, 2*ballonArc, 2*ballonArc, PI, PI+HALF_PI);
    arc(posX+ballonWidth, posY, 2*ballonArc, 2*ballonArc, PI+HALF_PI, TWO_PI);
    arc(posX+ballonWidth, posY+ballonHeight, 2*ballonArc, 2*ballonArc, 0, HALF_PI);
    arc(posX, posY+ballonHeight, 2*ballonArc, 2*ballonArc, HALF_PI, PI);
    rect(posX-ballonArc, posY, ballonWidth+2*ballonArc, ballonHeight);
    rect(posX, posY-ballonArc, ballonWidth, ballonHeight+2*ballonArc);

    // draw ballon frame
    noFill();
    stroke(cl);
    arc(posX, posY, 2*ballonArc, 2*ballonArc, PI, PI+HALF_PI);
    arc(posX+ballonWidth, posY, 2*ballonArc, 2*ballonArc, PI+HALF_PI, TWO_PI);
    arc(posX+ballonWidth, posY+ballonHeight, 2*ballonArc, 2*ballonArc, 0, HALF_PI);
    arc(posX, posY+ballonHeight, 2*ballonArc, 2*ballonArc, HALF_PI, PI);
    line(posX, posY-ballonArc, posX+ballonWidth, posY-ballonArc);
    line(posX+ballonWidth+ballonArc, posY, posX+ballonWidth+ballonArc, posY+ballonHeight);
    line(posX-ballonArc, posY, posX-ballonArc, posY+ballonHeight);
    line(posX, posY+ballonHeight+ballonArc, posX+ballonWidth, posY+ballonHeight+ballonArc);

    // draw text
    fill(0);
    text(tweet.msg, posX, posY, ballonWidth, ballonHeight);
    textAlign(RIGHT);
    text("@"+tweet.scname+"\n"+timeToString(), posX, posY+ballonHeight-2*defaultBallonHeightLine, ballonWidth, 2*defaultBallonHeightLine);
    textAlign(LEFT);
  }
  
  public void drawMainBallon(){
    int alp = min(sub_ttl*8, 255);
    
    // draw white ballon
    fill(255);
    stroke(255);
    arc(ballonArc+5, ballonArc+5, 2*ballonArc, 2*ballonArc, PI, PI+HALF_PI);
    arc(ballonArc+5+ballonWidth, ballonArc+5, 2*ballonArc, 2*ballonArc, PI+HALF_PI, TWO_PI);
    arc(ballonArc+5+ballonWidth, ballonArc+5+ballonHeight, 2*ballonArc, 2*ballonArc, 0, HALF_PI);
    arc(ballonArc+5, ballonArc+5+ballonHeight, 2*ballonArc, 2*ballonArc, HALF_PI, PI);
    rect(ballonArc+5-ballonArc, ballonArc+5, ballonWidth+2*ballonArc, ballonHeight);
    rect(ballonArc+5, ballonArc+5-ballonArc, ballonWidth, ballonHeight+2*ballonArc);

    // draw ballon frame
    noFill();
    stroke(cl);
    arc(ballonArc+5, ballonArc+5, 2*ballonArc, 2*ballonArc, PI, PI+HALF_PI);
    arc(ballonArc+5+ballonWidth, ballonArc+5, 2*ballonArc, 2*ballonArc, PI+HALF_PI, TWO_PI);
    arc(ballonArc+5+ballonWidth, ballonArc+5+ballonHeight, 2*ballonArc, 2*ballonArc, 0, HALF_PI);
    arc(ballonArc+5, ballonArc+5+ballonHeight, 2*ballonArc, 2*ballonArc, HALF_PI, PI);
    line(ballonArc+5, ballonArc+5-ballonArc, ballonArc+5+ballonWidth, ballonArc+5-ballonArc);
    line(ballonArc+5+ballonWidth+ballonArc, ballonArc+5, ballonArc+5+ballonWidth+ballonArc, ballonArc+5+ballonHeight);
    line(ballonArc+5-ballonArc, ballonArc+5, ballonArc+5-ballonArc, ballonArc+5+ballonHeight);
    line(ballonArc+5, ballonArc+5+ballonHeight+ballonArc, ballonArc+5+ballonWidth, ballonArc+5+ballonHeight+ballonArc);

    // draw text
    fill(0);
    text(tweet.msg, ballonArc+5, ballonArc+5, ballonWidth, ballonHeight);
    textAlign(RIGHT);
    text("@"+tweet.scname+"\n"+timeToString(), ballonArc+5, ballonArc+5+ballonHeight-2*defaultBallonHeightLine, ballonWidth, 2*defaultBallonHeightLine);
    textAlign(LEFT);
    
    /*
    fill(0, 255-alp);
    noStroke();
    rect(5, 5, ballonWidth+2*ballonArc+1, ballonHeight+2*ballonArc+1);
    */
    
    sub_ttl--;
    if(sub_ttl < -100 * framerate){ sub_ttl = -1; }
  }
  
  public void drawBoard(int lineNum){
    fill(255);
    stroke(255);
    rect(0,0,windowWidth, windowHeight);
    
    fill(0);
    text(tweet.msg, miniFrameSize, 0);
        
  }
}

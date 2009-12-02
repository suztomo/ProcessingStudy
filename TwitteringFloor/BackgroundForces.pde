

public class BackgroundForces{
  TweetFactory factory;
  TweetFactory ffactory;
  ArrayList tweets;
  PApplet canvas;
  float[][] forceX;
  float[][] forceY;
  int cellSize = 20;
  int margin = 100 / cellSize;
  int maxX, maxY;
  float forceNormal = 3.0;
  float forceDelay = 5.0;
  public BackgroundForces() {
    maxX = DisplayWindowWidth / cellSize;
    maxY = DisplayWindowHeight / cellSize;
    forceX = new float[maxY][maxX];
    forceY = new float[maxY][maxX];
    println("gridForces: maxX: " + maxX + ", maxY: " + maxY);
    for(int Y = 0; Y < maxY; ++Y) {
      for (int X=0; X < maxX; ++X) {
        forceX[Y][X] = random(-3, 3);
        forceY[Y][X] = random(-3, 3);
      }
    }
  }
  
  public void changeForce(int x, int y, float fx, float fy) { // float ?
    int dx = x / cellSize * DisplayWindowWidth / ManagerWindowFrameWidth;
    int dy = (y + 40) / cellSize * DisplayWindowHeight / ManagerWindowFrameHeight;
    for (int Y = dy - margin; Y < dy + margin; ++Y) {
      for (int X = dx - margin; X < dx + margin; ++X) {
        if (X >= 0 && X < maxX && Y >= 0 && Y < maxY) {
          float d2 = sqrt(sqrt(float((X - dx) * (X - dx) + (Y - dy) * (Y - dy))));
          if (d2 < 1.0) {
            forceX[Y][X] += fx;
            forceY[Y][X] += fy;
          } else {
            forceX[Y][X] += fx / d2;
            forceY[Y][X] += fy / d2;
          }
        }
      }
    }
  }
  
  public float getForceX(int x, int y) {
    if (x < 0 || x / cellSize >= maxX || y < 0 || y / cellSize >= maxY) {
      return 0.0;
    }
    return forceX[y / cellSize][x / cellSize];
  }
  
  
  public float getForceY(int x, int y) {
    if (x < 0 || x / cellSize >= maxX || y < 0 || y / cellSize >= maxY) {
      return 0.0;
    }
    return forceY[y / cellSize][x / cellSize];
  }
  
  /*
    Update force grid once in several seconds. 数秒間に1回更新
  */
  public void update() {
    for(int Y = 0; Y < maxY; ++Y) {
      for (int X = 0; X < maxX; ++X) {
        float fx = forceX[Y][X];
        float fy = forceY[Y][X];
        float s = sqrt(fx * fx + fy * fy);
        float idealX = forceX[Y][X] * forceNormal / s;
        float idealY = forceY[Y][X] * forceNormal / s;
        forceX[Y][X] += (idealX - forceX[Y][X]) / forceDelay;
        forceY[Y][X] += (idealY - forceY[Y][X]) / forceDelay;
      }
    }
  }
  
  
  public void draw() {
    stroke(0xCC);
    for(int Y = 0; Y < maxY; ++Y) {
      for (int X = 0; X < maxX; ++X) {
        float s = sqrt(forceX[Y][X] * forceX[Y][X] +  forceY[Y][X] * forceY[Y][X]);
        int c = 0xFF - int(s - forceNormal) * 30;
        if (c < 0xDD) {
          if (c < 0) {
            c = 0;
          }
          stroke(c);
          line(X * cellSize, Y * cellSize, X * cellSize + forceX[Y][X] * cellSize / 10.0, Y * cellSize + forceY[Y][X] * cellSize / 10.0);
          fill(204, 102, 0);
          ellipse(X * cellSize, Y * cellSize, 3, 3);  
        }
      }
    }
  }
}

class Square {
  float x, y;   // current position
  float vxx; //velocity multiplier (increases over time)
  float vx, vy;  // velocity
  float w;   //witdh
  color c; //color
  float timer;   // time left before square disappears
  float timerBonus;  //time left before "BONUS!" message disappears
  float dt;  // extinguishing speed
  float a; //rotation angle
  float da; //rotation rate 
  float dtBonus;  //text extinguishing speed
  float spring = 0.05; //ball springiness (for collisions)
  boolean on = false;

  Square() {
  }

  // Initialize squares offscreen (right of canvas)
  void initialize()
  {
    on = true;
    x = random(width+400, width+800); 
    y = random(0, height);
    vx = random(-10, -4); 
    vy = random(-2, 2);
    w = random(10, 15);
    c = color(0, random(100, 200), random(100));
    timer = 255;
    timerBonus = 0.5;
    dt = random(0.1, 5);
    a = 0;
    da = random(-0.5,-0.1);    
  }

  void draw()
  {
    if (!on) return;
    fill(c, timer);
    pushMatrix();
    translate(x,y);
    rotate(a);
    noStroke();
    rectMode(CENTER);
    rect(0, 0, w, w);
    popMatrix();
  }

  void update()
  {
    // initialize if necessary
    if (!on) { 
      if (random(0, 1) < 0.5) initialize(); 
      return;
    }

  //move squares
  x += vx;
  y += vy;
  
  //rotate squares
  a += da;


  //decay transparency
  timer -= dt;
  timerBonus -= dtBonus;


  //reverse square vy when it hits floor/ceiling
  if (y > height-w || y < w)
  {
    vy = -vy;
  }

  // When square exits screen, re-initialize
  if (x < 0 || x > width+601 || timer < 0) {
    on = false;
  }
}

//check for square collisions
void bounce() {
  for (int i = 0; i < squares.length; i ++) {
    // if this is myself, continue
    if (this == squares[i]) continue;
    // distance between two squares
    float d = dist(x, y, squares[i].x, squares[i].y);
    // minimum distance between two squares
    float md = w+squares[i].w;
    // if I collide with one of them
    if (d < md) {
      // push back in the opposite direction
      float dx = (x - squares[i].x)/d;
      float dy = (y - squares[i].y)/d;
      // check if perfectly overlapping
      if (dx == 0 && dy == 0) { 
        dx = random(-1, 1); 
        dy = random(-1, 1);
      }
      // compute the speed to add
      float s = min(10, spring*(md-d));
      vx += dx*s;
      vy += dy*s;
    }
  }
}
}

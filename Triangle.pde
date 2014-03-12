class Triangle {
  float x, y;   // current position
  float vx, vy;  // velocity
  float r;   //radius
  float timer;   // time left before square disappears
  float timerBonus;  //time left before "BONUS!" message disappears
  float dt;  // extinguishing speed
  float a; //rotation angle
  float da; //rotation rate 
  float dtBonus;  //text extinguishing speed
  float spring = 0.05; //ball springiness (for collisions)
  float red = 200;
  float green = 100;
  float blue = 0;
  float aGreen; //
  float daGreen; //rate of color change
  boolean on = false;

  Triangle() {
  }

  // Initialize triangles offscreen (right of canvas)
  void initialize()
  {
    on = true;
    x = random(width+400, width+800); 
    y = random(0, height);
    r = 10;
    vx = random(-12, -8); 
    vy = random(-2, 2);
    timer = 255;
    timerBonus = 0.5;
    dt = random(0.1, 5);
    a = 0;
    da = random(-0.3, -0.1);    
    aGreen = TWO_PI;
    daGreen = radians(2);
  }

  void draw()
  {
    green = 140 * (1+sin(aGreen));

    if (!on) return;
    fill(red, green, blue, timer);
    pushMatrix();
    translate(x, y);
    rotate(a);
    noStroke();
    triangle(0, 10, 10, -10, -10, -10);    
    popMatrix();
  }

  void update()
  {
    // initialize if necessary
    if (!on) { 
      if (random(0, 1) < 0.5) initialize(); 
      return;
    }

    //move triangles
    x += vx;
    y += vy;

    //rotate triangles
    a += da;

    //update blue color channel
    aGreen += daGreen;

    green = constrain(green, 100, 160);
    blue = constrain(blue, 100, 240);

    //decay transparency
    timer -= dt;
    timerBonus -= dtBonus;


    //reverse square vy when it hits floor/ceiling
    if (y > height- r || y < r)
    {
      vy = -vy;
    }

    // When square exits screen, re-initialize
    if (x < 0-r || x > width+601 || timer < 0) {
      on = false;
    }
  }

  //check for square collisions
  void bounce() {
    for (int i = 0; i < triangles.length; i ++) {
      // if this is myself, continue
      if (this == triangles[i]) continue;
      // distance between two triangles
      float d = dist(x, y, triangles[i].x, triangles[i].y);
      // minimum distance between two triangles
      float md = r+triangles[i].r;
      // if I collide with one of them
      if (d < md) {
        // push back in the opposite direction
        float dx = (x - triangles[i].x)/r;
        float dy = (y - triangles[i].y)/r;
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


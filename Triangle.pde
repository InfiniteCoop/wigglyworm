class Triangle {
  float x, y;   // current position
  float vx, vy;  // velocity
  float l;   //side length
  float timer;   // time left before square disappears
  float timerBonus;  //time left before "BONUS!" message disappears
  float dt;  // extinguishing speed
  float a; //rotation angle
  float da; //rotation rate 
  float dtBonus;  //text extinguishing speed
  float spring = 0.05; //ball springiness (for collisions)
  boolean on = false;

  Triangle() {
  }

  // Initialize triangles offscreen (right of canvas)
  void initialize()
  {
    on = true;
    x = random(width+800, width+800); 
    y = random(0, height);
    l = 10;
    vx = random(-12, -8); 
    vy = random(-2, 2);
    timer = 255;
    timerBonus = 0.5;
    dt = random(0.1, 1);
    a = 0;
    da = random(-0.25, -0.05);    
  }

  void draw()
  {

    if (!on) return;
    fill(200, 200, 0, timer);
    pushMatrix();
    translate(x, y);
    rotate(a);
    noStroke();
    triangle(0, l, l, -l, -l, -l);    
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

    //decay transparency
    timer -= dt;
    timerBonus -= dtBonus;


    //reverse square vy when it hits floor/ceiling
    if (y > height- l || y < l)
    {
      vy = -vy;
    }

    // When square exits screen or becomes invisible, re-initialize
    if (x < 0-l || timer < 0) {
      on = false;
    }
  }
}

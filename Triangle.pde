//a class for the probiotic triangle power-up
class Triangle {
  float x, y;   // current position
  float vx, vy;  // velocity
  float l;   //triangle side length
  float timer;   // time left before triangle disappears
  float timerBonus;  //time left before bonus message disappears
  float dt;  // triangle transparency change speed
  float a; //rotation angle
  float da; //rotation rate 
  float dtBonus;  //text extinguishing speed
  boolean on = false;
  boolean explode = false;  //switched on/off by collision with worm head

  Triangle() {
  }

  // Initialize triangles offscreen (right of canvas)
  void initialize()
  {
    on = true;
    explode = false;
    x = random(width*2, width*3); 
    y = random(0, height);
    vx = random(-12, -8); 
    vy = random(-4, 4);
    l = 10;
    timer = 255;
    dt = 20;
    timerBonus = 255;
    dtBonus = 1;
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
    // initialize, if necessary
    if (!on) { 
      if (random(0, 1) < 0.5) initialize(); 
      return;
    }

    //move triangles
    x += vx;
    y += vy;

    //rotate triangles
    a += da;

    //reverse triangle vy when it hits floor/ceiling
    if (y > height-l || y < l)
    {
      vy = -vy;
    }

    // When triangle exits screen or becomes invisible, re-initialize
    if (x < 0-l || timer < 20) {
      on = false;
    }

    //test to see if triangle has collided with worm head (see collisions() function)
    if (explode == true)
    {
      //trigger triangle appearance change
      l += 20;
      timerBonus -= dtBonus;
      timer -= dt;

      //destroy any balls that touch triangle
      for (int i=0; i<nBalls; i++)
      {
        if (dist(triangle.x, triangle.y, balls[i].x, balls[i].y) < triangle.l*2 && triangle.timer > 40)
        {

          //play pop sound
          pop2.play();
          pop2.rewind();

          //remove ball (it will be reinitialized)
          balls[i].on = false;

          //print message
          fill((triangle.timerBonus));
          textAlign(CENTER);
          textFont(fontBonus, 48);
          text("+100!", balls[i].x, balls[i].y);

          //update score
          score += 100;
        }
      }
    }
  }
}


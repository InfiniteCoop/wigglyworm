//this class defines Timmy's body, which is comprised of joints, links, and his head

class WormJoint {
  float cx, cy;        // rest position
  float x, y;
  float vx=0, vy=0;    // velocity in the two directions   
  float r;        // joint radius
  float k = 0.08;      // spring constant
  float d = 0.75;      // damping
  float hg = 0.5;  // horizontal gravity
  float red = 50;    //color channels
  float green = 200;
  float blue = 200;
  float a;
  float da;

  // Initialize a worm joint at rest position (x0,y0)
  WormJoint(float x0, float y0, float r0)
  {
    x = x0;
    y = y0;
    r = r0;
    a = TWO_PI;
    da = radians(2);
  }

  void draw()
  {
    blue = 140 * (1+sin(a));
    fill(red, green, blue);
    //draw worm joints
    stroke(red, green, blue); 
    strokeWeight(4);
    line(cx, cy, x, y);
    fill(red, green, blue); 
    //draw worm eye connectors
    strokeWeight(2);
    line(mouseX, mouseY, mouseX+4, mouseY-12);
    line(mouseX, mouseY, mouseX-4, mouseY-12);
    //draw worm head
    noStroke();
    ellipse(mouseX, mouseY+2, 3*r, 3.5*r);
    ellipse(x, y, 2*r, 2*r);
    //draw worm eyes
    fill(255);
    ellipse(mouseX+4, mouseY-12, 1.5*r, 1.5*r);
    ellipse(mouseX-4, mouseY-12, 1.5*r, 1.5*r);
    fill(0);
    ellipse(mouseX+4, mouseY-12, r-2, r-2);
    ellipse(mouseX-4, mouseY-12, r-2, r-2);
    //draw worm mouth
    stroke(0);
    line(mouseX-2, mouseY+4, mouseX+2, mouseY+4);
  }

  // Update the spring, with a new center
  void update(float ncx, float ncy)
  {
    // set the new center
    cx = ncx; 
    cy = ncy;

    // usual spring stuff
    vx -= k * (x-cx); 
    vy -= k * (y-cy); 
    vx -= hg;
    vx *= d; 
    vy *= d;
    x += vx; 
    y += vy;
    a += da;

    green = constrain(green, 100, 240);
    blue = constrain(blue, 100, 240);

    //shrink joints after he eats a bonus square
    r *= 0.95;
    if (r < 4) r = 4;
    }
  }


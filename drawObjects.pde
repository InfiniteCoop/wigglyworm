void drawObjects()
{
      // Draw and update balls
    for (int i=0; i<nBalls; i++) balls[i].draw();
    for (int i=0; i<nBalls; i++) balls[i].update();
    for (int i=0; i<nBalls; i++) balls[i].bounce();

    //Draw and update squares
    for (int i=0; i<squares.length; i++) squares[i].draw();
    for (int i=0; i<squares.length; i++) squares[i].update();
    for (int i=0; i<squares.length; i++) squares[i].bounce();

    //Draw and update wiggly worm
    for (int i=0; i<nJoints; i++) joints[i].draw();

    // Recenter first joint at the mouse
    joints[0].update(mouseX, mouseY);

    // Recenter each following joint at preceding joint
    for (int i=1; i<nJoints; i++)
      joints[i].update(joints[i-1].x, joints[i-1].y);
}

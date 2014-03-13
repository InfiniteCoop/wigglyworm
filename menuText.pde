void menuText ()
{
  //display start messages
  textAlign(CENTER);
  fill(fontColor);
  textFont(fontBonus, 100);
  text("WIGGLY WORM", width/2, height/2 - 60);

  textFont(font, 16);
  fill(255);
  text("Use the mouse to help Timmy the misunderstood tapeworm evade the red antibiotics!", 
  width/2, height/2);
  text("Snack on delicious green nutrients to gain bonus points", 
  width/2, height/2 + 30);
    text("Pop the orange probiotics to destroy nearby antibiotics", 
  width/2, height/2 + 60);

  textFont(font, 14);
  text("Click anywhere to begin", width/2, height/2 + 160);

  //display high score in corner
  textFont(font, 20);
  textAlign(RIGHT);
  text("HIGH SCORE: " + hiScore, (width - 20), (height - 30));
}


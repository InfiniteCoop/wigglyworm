void menuText ()
{
  //display start messages
  textAlign(CENTER);
  fill(fontColor);
  textFont(fontTitle, 60);
  text("WIGGLY WORM", width/2, height/2 - 80);

  textFont(font, 16);
  fill(255);
  text("Use the mouse to help Timmy the misunderstood tapeworm evade the evil antibiotics!", 
  width/2, height/2);
  text("Snack on delicious green nutrients for bonus points.", 
  width/2, height/2 + 20);

  textFont(font, 14);
  text("Click anywhere to begin", width/2, height/2 + 80);

  //display high score in corner
  textFont(font, 20);
  textAlign(RIGHT);
  text("HIGH SCORE: " + hiScore, (width - 20), (height - 30));
}


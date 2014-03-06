void scoreText()
{
  //display score in left corner
  textAlign(LEFT);
  fill(255);
  textFont(font);
  text("SCORE: " + score, 20, (height - 30));

  //display high score in right corner
  textAlign(RIGHT);
  text("HIGH SCORE: " + hiScore, (width - 20), (height - 30));
}


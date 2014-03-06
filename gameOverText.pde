void gameOverText()
{
    
  //display "GAME OVER" messages
    textAlign(CENTER);
    fill(fontColor);

    textFont(font, 40);
    text("You killed Timmy!", (width/2), (height/2) - 40);
    fill(255);
    textFont(font, 20);
    text("Click to restart game", width/2, height/2);
    textFont(font, 14);
    text("(Hint: Timmy doesn't like sudden movements)", width/2, height/2 + 100);

    //display score in left corner
    textAlign(LEFT);
    textFont(font, 20);
    text("SCORE: " + score, 20, (height - 30));
    

    //display high score in corner
    textAlign(RIGHT);
    text("HIGH SCORE: " + hiScore, (width - 20), (height - 30));
}

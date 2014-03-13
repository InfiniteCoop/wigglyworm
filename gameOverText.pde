void gameOverText()
{
    
  //display "GAME OVER" messages
    textAlign(CENTER);
    fill(245,20,0);

    textFont(fontBonus, 60);
    text("You killed Timmy!", (width/2), (height/2) - 40);
    fill(255);
    textFont(font, 20);
    text("Click anywhere to restart game", width/2, height/2 + 20);

    //display score in left corner
    textAlign(LEFT);
    textFont(font, 20);
    text("SCORE: " + score, 20, (height - 30));
    

    //display high score in corner
    textAlign(RIGHT);
    text("HIGH SCORE: " + hiScore, (width - 20), (height - 30));
}

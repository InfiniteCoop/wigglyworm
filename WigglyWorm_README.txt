WIGGLY WORM v2.0
By Cooper Thomas
Computer Science 2 Final Project
12 March, 2014


PROJECT DESCRIPTION

Wiggly Worm is a simple arcade game in which players step into the shoes (err, segments?) of Timmy the Tapeworm, a lamentably misunderstood nematode battling for survival against an every-growing army of antibiotics. Using the mouse, players must steer Timmy (who is made up of several linked springs) away from the death-dealing antibiotics (balls). The longer that Timmy evades the antibiotics, the more points he gains. However, the antibiotics gradually multiply in number – and Timmy gradually grows longer – making survival progressively more difficult. 

Timmy can snack on tasty green nutrients (squares) to gain bonus points. He can also “pop”  the orange probiotics (triangles), which will destroy any antibiotics in their immediate vicinity.

The basic structure of the game (i.e., the three different game states) is based on Simon’s ROFLCopter sketch: www.openprocessing.org/sketch/49529


PROJECT COMPONENTS:

Game states: 
—-The game has three different game states (stored as variables): main menu, playing, and end game. While all three of these states are defined in the sketch’s draw function, only one state runs at a time. The game switches between states conditionally; for example, if a player hits an antibiotic ball, the game switches from the playing state to the end game state. If a player clicks the mouse during the main menu or end game states, the game switches to the playing state.

Classes:
—-The game contains four classes: WormJoint, Ball, Square, and Triangle. The WormJoint class defines several connected springs which comprise Timmy’s body. They are generated using an array. Timmy’s movements are very elastic-y, which makes the game more fun and challenging. The worm begins with just two joints, but gradually grows longer and longer (see scoreUpdate() function below). The WormJoint has draw and update methods. 

—-The antibiotic balls (of the Ball class) are also generated using an array. They are initialized to the right of the screen, and move from right to left (and up and down) at varying velocities. When each ball reaches the left of the screen, it disappears and is re-initialized at another random starting position to the right of the screen. The ball contains draw and update methods. The update method includes a bounce() function, which mediates intra-class collisions. The balls cannot collide with one another until they are within the playing field, to prevent against balls suddenly appearing with insane velocities (resulting from offscreen collisions).

—-The bonus squares (of the Square class) are generated in the same manner as the balls, except that they also become increasingly transparent as they move across the screen. Like the Ball class, the Square class has an internal collision detection function (in the update method) to ensure that the squares rebound off one another, as well the canvas walls.  

—-There is only one instance of the Probiotic class in the game. This class has draw and update methods. Like the balls and squares, the probiotic is initialized offscreen, an doves from right to left (reinitializing when it reaches the canvas extent). The class contains a “collision” state (stored as a boolean variable) that switches on particular object behaviors when triggered.

—-The BeatListener class implements the AudioListener class (of the minim library) to analyze the soundtrack’s rhythmic patterns.

Functions:
—-The game is initialized in setup using a global function (gameInit). This function (re)sets the score to 0, and (re)sets the number of balls and links to their starting values. By calling this function from the menu state or the end game state, the player can easily restart the game. 

—-The three types of objects are drawn with the drawObjects() function (called in global draw).

—-There is a scoreUpdate() function that is called in global draw(). This function adds one point to the score every frame. The function also contains local functions to add a new antibiotic ball every 1000 points, and to add a new worm joint every 2000 points (addBall and addJoint, respectively), to ensure that the game becomes increasingly difficult. The scoreUpdate() function triggers sound effects when Timmy eats a bonus square, gains a link, or collides with a ball. This function also tracks and updates the high score, as necessary.

—There is also a collision() function called in draw(). If Timmy’s head (which is set by mouseX and mouseY) collides with a visible square, Timmy gains 100 bonus points, and the square disappears and reinitializes offscreen. If Timmy collides with a ball, the game switches to the game end state (i.e., the player loses and must restart).

—-Three separate text() functions draw the menu text, the score text, and the endgame text.

—-Beat detection. The game uses the minim frequency analysis library to listen to the soundtrack, identify its beat, and cause the squares and triangle to pulse along with the beat.

—-soundSpeaker() switches the sound on/off icons (drawn in Illustrator) depending on whether the game has been muted or not.

Auxiliary content:
—-I composed and recorded the original soundtrack, and used my own voice to produce all of the sound effects. (Naturally, they were heavily distorted in Ableton.)
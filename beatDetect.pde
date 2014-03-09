void beatDetect()
{
  beat.detect(soundtrack.mix);
  for (int i=0; i<squares.length; i++)
  {
<<<<<<< HEAD
    if (beat.isOnset())
=======
    if (beat.isKick())
>>>>>>> development
    {
      squares[i].w += 10;
    }
    squares[i].w *= 0.85;
    if (squares[i].w < 10) squares[i].w = 10;
  }
}


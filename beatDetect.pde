void beatDetect()
{
  beat.detect(soundtrack.mix);
  for (int i=0; i<squares.length; i++)
  {
    if (beat.isKick())
    {
      squares[i].w += 10;
    }
    squares[i].w *= 0.85;
    if (squares[i].w < 10) squares[i].w = 10;
  }
}


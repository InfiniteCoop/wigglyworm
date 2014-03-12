void beatDetect()
{
  beat.detect(soundtrack.mix);

  if (beat.isKick())
  {
    triangle.l += 6;
  }
  triangle.l *= 0.85;
  if (triangle.l < 10) triangle.l = 10;  

  for (int i=0; i<squares.length; i++)
  {
    if (beat.isKick())
    {
      squares[i].w += 6;
    }
    squares[i].w *= 0.85;
    if (squares[i].w < 10) squares[i].w = 10;
  }
}


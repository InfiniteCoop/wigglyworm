void soundSpeaker()
{
  if (!muted)
  {
    image(speakerOn, width-80, 20);
  }
  else
  {
    image(speakerOff, width-80, 20);
  }
}

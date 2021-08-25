boolean mousePressedAndReleased() {
  if (mousePressed == true && cachePressed == 0) {
    cachePressed = 1;
  }
  if (mousePressed == false && cachePressed == 1) {
    cachePressed = 0;
    return true;
  }
  return false;
}
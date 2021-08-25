void setup() {
  size(800, 800, FX2D);
  noStroke();
}

void draw() {
  size = height/10;
  centerX = width/2;
  centerY = height/2;
  background(bgColor);
  drawRows();
  movimiento();
  victory();
}

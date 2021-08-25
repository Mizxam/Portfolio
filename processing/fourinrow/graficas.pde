float centerX;
float centerY;

color color1 = color(224, 48, 28);
color color2 = color(32, 78, 224);

color bgColor = color(100);

int size;

void drawRows() {
  size = height/10;
  for (int i = 0; i < columnas; i++) {
    for (int j = 0; j < filas; j++) {
      float offX = centerX - columnas * size/2; 
      float offY = centerY - filas * size/2;
      float x = offX + i*size;
      float y = offY + j*size;

      fill(255);
      if ((i+j)%2 == 1)
        fill(245);
      rect(x, y, size, size);

      if (tablero[i][j] == 1) {
        fill(color1);
        ellipse(x + size/2, y + size/2, size, size);
      } else if (tablero[i][j] == 2) {
        fill(color2);
        ellipse(x + size/2, y + size/2, size, size);
      }
    }
  }
}

void victory(){
  if (turn == 3) {
    bgColor = color1;
  }
  if (turn == 4) {
    bgColor = color2;
  }
  if(turn > 2){
    fill(245);
    textAlign(CENTER);
    textSize(height/8);
    text(turn == 3? "Red win!" : "Blue win!",width/2,height/2+height/10*4);
  }
}

ArrayList<particle> Particles = new ArrayList();

void bg(){
  
}

class particle{
  float size;
  PVector pos = new PVector();
  particle(float x, float y){
    size = random(25);
    pos.set(x,y);
  }
}

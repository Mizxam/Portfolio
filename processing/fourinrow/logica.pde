int turn = 1;
int cachePressed;

final int columnas = 5;
final int filas = 6;

int tablero[][] = new int[columnas][filas];

void dropCoin(int columna) {
  int tope = filas-1;

  for (int i = 0; i < filas; i++) {
    //println(tablero[columna][i]);
    if (tablero[columna][i] != 0) {
      //println("Hay tope en " + (i-1));
      tope = i-1;
      break;
    }
  }

  if (tope < 0)
    return;

  if (turn == 1) {
    tablero[columna][tope] = 1;
    checkLines(columna, tope);
    turn = turn > 2? turn : 2;
    return;
  } else if (turn == 2) {
    tablero[columna][tope] = 2;
    checkLines(columna, tope);
    turn = turn > 2? turn : 1;
    return;
  }
}

void movimiento() {
  int ancho = height/10;
  float offX = centerX - columnas * ancho/2; 
  float offY = centerY - filas * ancho/2;

  if (turn == 1) {
    fill(color1);
  }
  if (turn == 2) {
    fill(color2);
  }

  for (int i = 0; i < columnas; i++) {
    float y = offY - 3 * ancho / 2 + ancho/2;
    float x = offX + ancho/2;
    if (mouseX >= offX + ancho * i && mouseX <= offX + ancho * (i+1)) {
      ellipse(x + ancho*i, y, ancho, ancho);
      if (mousePressedAndReleased()) {
        dropCoin(i);
      }
    }
  }
}

void checkLines(int columna, int fila) {

  int counter4 = 0;
  // Ganar horizontal
  for (int i = 0; i < columnas; i++) {
    int current = tablero[i][fila];
    println( i + "/" + columnas + " : " +current);
    if (current == turn){
      counter4++;
    }
    else if(current != turn){
      counter4 = 0;
    }
  }
  println(turn % 2 == 1? "RED":"BLUE");
  println("CH = "+counter4);
  if (counter4 > 3) { turn = turn+2; return; }
  counter4 = 0;
  
  // Ganar vertical
  for (int i = filas-1; i > -1; i--) {
    if (tablero[columna][i] == turn)
      // Añadir 1 al contador si hay otra ficha próxima
      counter4++;
    else
      // Reestablecer el contador si no hay otra ficha seguida
      counter4 = 0;
  }
  println("CV = "+counter4);
  if (counter4 > 3) { turn = turn+2; return; }
  counter4 = 0;
  
  
  int distBottom = filas - fila;
  if (distBottom < 4)
      // Solo checkear diagonales si son posibles.
      return;
}

int[][] mimic;
int[][] mapa =      
  {{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,-2}};
ArrayList<pFP> mimicA;
ArrayList<PVector> iniciadores;
ArrayList<ArrayList<PVector>> leads;

void setup() {
  size(400, 400);
  iniciadores = new ArrayList();
  leads = new ArrayList();
  mimic = new int[20][20];
  mimicA = new ArrayList();
  iniciadores = scan(1, mapa);
  scanAdd(mimicA, iniciadores, scan(-2,mapa).get(0));
  println(scan(-2,mapa).get(0));
  cM(mapa, mimic);
}

void draw() {
  background(100);
  dM(mimic);
  act(mimicA);
  drawLeads();
  //println(leads.size());
  noStroke();
  //print(scan(1, mapa)+"\n");
}

ArrayList<PVector> scan(int objetivo, int map[][]) {
  ArrayList<PVector> resultado = new ArrayList();
  for (int x = 0; x < 20; x++) {
    for (int y = 0; y < 20; y++) {
      if (map[x][y] == objetivo)
        resultado.add(new PVector(x, y));
    }
  }
  return resultado;
}

void mousePressed() {
  //println(mouseX/40%10+" "+mouseY/40%10);
  if (mouseButton == LEFT) {
    mapa[int(mouseY/20%20)][int(mouseX/20%20)] = 1;
    mimic = new int[20][20];
    cM(mapa, mimic);
    iniciadores = scan(1, mapa);
    scanAdd(mimicA, iniciadores, scan(-2,mapa).get(0));
  }
  if (mouseButton == RIGHT) {
    mapa[int(mouseY/20%20)][int(mouseX/20%20)] = -1;
    mimic = new int[20][20];
    cM(mapa, mimic);
  }
  if (mouseButton == CENTER) {
    mapa[int(mouseY/20%20)][int(mouseX/20%20)] = 0;
    mimic = new int[20][20];
    cM(mapa, mimic);
  }
  leads.clear();
  act(mimicA);
}

class pFP {
  ArrayList<PVector> history = new ArrayList();
  int dist;
  int x, y;
  int x1,y1;
  boolean remove = false;
  pFP(int dist, PVector pos, PVector dest, ArrayList<PVector> _history) {
    println("creado"+dist);
    for(int i = 0; i < _history.size(); i++){
      this.history.add(_history.get(i));
    }
    this.history.add(new PVector(pos.x, pos.y));
    this.dist = dist;
    this.x  = int( pos.x);
    this.y  = int( pos.y);
    this.x1 = int(dest.x);
    this.y1 = int(dest.y);
    mimic[this.x][this.y] = dist;
    if(this.x == this.x1 && this.y == this.y1){
      leads.add(history);
      remove = true;
    }
  }

  void reproduce(ArrayList<pFP> a,int[][] mimic){
    if(remove)
      a.remove(this);
    int minX = -1;
    int minY = -1;
    int maxX =  1;
    int maxY =  1;
    if (this.x-1 < 0)
      minX = 0;
    if (this.x+1 > 19)
      maxX = 0;
    if (this.y-1 < 0)
      minY = 0;
    if (this.y+1 > 19)
      maxY = 0;
    if (mimic[this.x+minX][this.y] == 0 || mimic[this.x+minX][this.y] == -2 )
      a.add(new pFP(dist+1, new PVector(this.x+minX, this.y),new PVector(this.x1, this.y1),this.history));
    if (mimic[this.x+maxX][this.y] == 0 || mimic[this.x+maxX][this.y] == -2 )
      a.add(new pFP(dist+1, new PVector(this.x+maxX, this.y),new PVector(this.x1, this.y1),this.history));
    if (mimic[this.x][this.y+minY] == 0 || mimic[this.x][this.y+minY] == -2)
      a.add(new pFP(dist+1, new PVector(this.x, this.y+minY),new PVector(this.x1, this.y1),this.history));
    if (mimic[this.x][this.y+maxY] == 0 || mimic[this.x][this.y+maxY] == -2)
      a.add(new pFP(dist+1, new PVector(this.x, this.y+maxY),new PVector(this.x1, this.y1),this.history));
    a.remove(this);
  }
}

void dM(int[][] map) {
  textAlign(CENTER);
  for (int x = 0; x < 20; x++) {
    for (int y = 0; y < 20; y++) {
      if (map[y][x] >= 1)
        fill(255-map[y][x]*10, 0, 0);
      if (map[y][x] < 0)
        fill(0);
      rect(x*20, y*20, 20, 20);
      fill(255);
      text(map[y][x], x*20+10, y*20+10);
    }
  }
}

void cM(int[][] map, int[][] map2) {
  for (int x = 0; x < 20; x++) {
    for (int y = 0; y < 20; y++) {
      map2[x][y] = map[x][y];
    }
  }
}

void act(ArrayList<pFP> a) {
  //for (int i = a.size()-1; i > -1; i--){
  //a.get(i).reproduce(a, mimic);
  //}
  int cWave = 0;
  int quantity = 1;
  while (a.size() > 0) {
    while (quantity > 0) {
      for (int i = a.size()-1; i > -1; i--) {
        if (a.get(i).dist == cWave) {
          a.get(i).reproduce(a, mimic);
          quantity++;
        }
      }
      quantity--;
    }
    cWave++;
    quantity++;
  }
}

void scanAdd(ArrayList<pFP> b, ArrayList<PVector> pV, PVector dest) {
  for (int i = pV.size()-1; i > -1; i--) {
    b.add(new pFP(1, pV.get(i), dest, new ArrayList()));
  }
}

void drawLeads() {
  //println(leads.get(108).leads.size()-1);
  strokeWeight(2);
  stroke(255);
  for (int i = leads.size()-1; i > -1; i--) {
    for (int j = leads.get(i).size()-1; j > 0; j--) {
      println(leads.get(i).get(j));
      //ellipse(leads.get(i).get(j).y*40+20,leads.get(i).get(j).x*40+20,2,2);
      line(leads.get(i).get(j).y*20+10, leads.get(i).get(j).x*20+10, leads.get(i).get(j-1).y*20+10, leads.get(i).get(j-1).x*20+10);
    }
  }
  println("\n");
}

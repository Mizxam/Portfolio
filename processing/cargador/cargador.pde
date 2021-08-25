JSONArray input;
float R, zoom, Rz;
mesh M;
String route;
float rotx = PI;
float roty = PI;
float rotz = PI/4;
float lx, ly, lz;
boolean modo = false;


void setup() {
  selectInput("Select a file to process:", "fileSelected");
  fullScreen(P3D, 2);
  R = width/20;
  zoom = 1;
  M = new mesh();
}

void draw() {
  if (modo) {
    background(20, 21, 21);
  } else {
    background(200, 210, 210);
  }
  //zoom = -mouseX/100;
  //cam();
  directionalLight(200, 200, 200, 0, 0, -1);
  ambientLight(102, 102, 102);
  translate( width/2, height/2, -10*R*zoom);
  rotateX(rotx);
  rotateY(roty);
  //translate( width/2, height/2, 3*zoom*R);
  M.display();
}

void keyPressed() {
  if (keyCode == ESC) {
    exit();
  }
  if (modo) {
    if (key == 'n') {
      modo=!modo;
    }
  } else {
    if (key == 'm') {
      modo=!modo;
    }
  }
}

void cam() {
  beginCamera();
  camera();      
  translate( width/2, height/2, 3*zoom*R);
  //rotateX(PI/4);
  rotateX((2*mouseY-height)*PI/height);
  //rotateZ(PI/4);
  //rotateY(PI/4);
  rotateZ((2*mouseX-width)*PI/width);
  //translate( -pos.x, -pos.y, -pos.z);
  endCamera();
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    route = selection.getAbsolutePath();
    println("User selected " + route);
    M = new mesh(route);
  }
}

class mesh {
  boolean ready = false;
  boolean loaded = false;
  ArrayList<bloque> bloques = new ArrayList();

  mesh() {
  }

  mesh(String rrr) {
    if (rrr != null) {
      println(rrr);
      input = loadJSONArray(rrr);
      for (int i = 0; i < input.size(); i++) {
        println("Cargando..."+i);
        JSONObject cache = input.getJSONObject(i); 
        String name = cache.getString("name");
        float x = cache.getFloat("x");
        float y = cache.getFloat("y");
        float z = cache.getFloat("z");
        bloques.add(new bloque(name, x, y, z));
        if (lx < x) {
          lx = x;
        }
        if (ly < y) {
          ly = y;
        }
        if (lz < z) {
          lz = z;
        }
      }
      loaded = true;
    } else {
      println("Coso");
      loaded = false;
    }
  }

  void display() {
    for (int i = 0; i < bloques.size(); i++) {
      bloques.get(i).display();
    }
  }
}

class bloque {
  String name = "air";
  PVector pos = new PVector();
  PImage texture = new PImage();


  bloque(String name, float posx, float posy, float posz) {
    this.name = name;
    texture = loadImage("textures/"+name+".png");
    pos.set(posx, posy, posz);
  }

  void display() {
    textureMode(NORMAL);
    float xz = pos.x*R-(lx/2)*R, yz = pos.y*R-(ly/2)*R, zz = pos.z*R-(lz/2)*R;
    //box(xz,yz,zz,R);
    TexturedCube(xz, yz, zz, R/2, texture);
  }
}


void TexturedCube(float xz, float yz, float zz, float R, PImage tex) {
  beginShape(QUADS);
  texture(tex);
  stroke(100);
  //fill(0,0);

  // +Z "front" face
  vertex(xz+R*-1, yz+R*-1, zz+R* 1, 0, 0);
  vertex(xz+R* 1, yz+R*-1, zz+R* 1, 1, 0);
  vertex(xz+R* 1, yz+R* 1, zz+R* 1, 1, 1);
  vertex(xz+R*-1, yz+R* 1, zz+R* 1, 0, 1);

  // -Z "back" face
  vertex(xz+R* 1, yz+R*-1, zz+R* -1, 0, 0);
  vertex(xz+R*-1, yz+R*-1, zz+R* -1, 1, 0);
  vertex(xz+R*-1, yz+R* 1, zz+R* -1, 1, 1);
  vertex(xz+R* 1, yz+R* 1, zz+R* -1, 0, 1);

  // +Y "bottom" face
  vertex(xz+R*-1, yz+R* 1, zz+R*  1, 0, 0);
  vertex(xz+R* 1, yz+R* 1, zz+R*  1, 1, 0);
  vertex(xz+R* 1, yz+R* 1, zz+R* -1, 1, 1);
  vertex(xz+R*-1, yz+R* 1, zz+R* -1, 0, 1);

  // -Y "top" face
  vertex(xz+R*-1, yz+R*-1, zz+R* -1, 0, 0);
  vertex(xz+R* 1, yz+R*-1, zz+R* -1, 1, 0);
  vertex(xz+R* 1, yz+R*-1, zz+R*  1, 1, 1);
  vertex(xz+R*-1, yz+R*-1, zz+R*  1, 0, 1);

  // +X "right" face
  vertex(xz+R* 1, yz+R*-1, zz+R*  1, 0, 0);
  vertex(xz+R* 1, yz+R*-1, zz+R* -1, 1, 0);
  vertex(xz+R* 1, yz+R* 1, zz+R* -1, 1, 1);
  vertex(xz+R* 1, yz+R* 1, zz+R*  1, 0, 1);

  // -X "left" face
  vertex(xz+R*-1, yz+R* -1, zz+R* -1, 0, 0);
  vertex(xz+R*-1, yz+R* -1, zz+R*  1, 1, 0);
  vertex(xz+R*-1, yz+R*  1, zz+R*  1, 1, 1);
  vertex(xz+R*-1, yz+R*  1, zz+R* -1, 0, 1);

  endShape(CLOSE);
}

void mouseDragged() {
  float rate = 0.01;
  rotx += (pmouseY-mouseY) * rate;
  roty -= (mouseX-pmouseX) * rate;
}

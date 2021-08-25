ArrayList<bloque> bloques;
bloque bG[][][];
int layer,view,zoom,R,rz;
selector s1;

void setup(){
	//size(800,500,P2D);
	fullScreen(P2D,2);
	zoom = 1;
	R = width/30;
	rz = R*zoom;
	bloques = new ArrayList();
	bloques.add(new bloque("null"));
	bloques.add(new bloque("air"));	
	bloques.add(new bloque("wood"));	
	bloques.add(new bloque("cobble"));
	bloques.add(new bloque("glowstone"));
	//bloques.add(new bloque("cobble"));
	bG = new bloque[(width / rz)][50][(height / rz)+1];
	s1 = new selector();
	layer = 0;
	view = 0;
	for (int i = 0; i < (height / rz)+1; i++){
		for(int j = 0; j < (width / rz); j++){
			for(int k = 0 ; k < 49 ; k++){
				bG[j][k][i] = new bloque("air",j,k,i);
				//println("cargado =" + (i*(height / rz)+1+j));
			}
		}
	}
	setKeys();
}

void draw(){
	background(200, 210, 210);
	grid();
	s1.inGrid();
	s1.display();
	if(w.pressedreleased()){
		if(layer < 49){
			layer+=1;
		}
	}
	if(s.pressedreleased()){
		if(layer > 0){
			layer-=1;
		}
	}
	if(c.pressedreleased()){
		view+=1;
	}
	if(space.pressedreleased()){
		bloques.add(new tortuga());	
	}
	if(view > 4){
		view = 0;
	}
}

class bloque{
	String name;
	PVector pos;
	PImage texture;
	int res;
	bloque(){


	}

	bloque(String name){
		pos = new PVector();
		this.name = name;
		texture = loadImage("textures/"+name+".png");
		/*try{ texture = loadImage("textures/"+name+".png");
		}catch (NullPointerException e) {
			e.printStackTrace();
			texture = loadImage("textures/null.png");
		}*/
	}

	bloque(String name,float posx,float posy,float posz){
		pos = new PVector();
		pos.x = posx;
		pos.y = posy;
		pos.z = posz;
		this.name = name;
		texture = loadImage("textures/"+name+".png");
		/*try{ texture = loadImage("textures/"+name+".png");
		}catch (NullPointerException e) {
			e.printStackTrace();
			texture = loadImage("textures/null.png");
		}*/
	}

	void display(int posx,int posz){
		if(view == 0){
			if(pos.y == layer){
				image(texture, posx*rz, posz*rz, rz, rz);
			}
			if(layer == pos.y-1 || layer == pos.y+1){
			//else{
				//tint(255, 126);
				//image(texture, posx*rz, posy*rz, rz/2, rz/2);
			}
		}
		if(view == 1){

		}
		if(view == 2){

		}
		if(view == 3){

		}
	}

	void display(){
		if(view == 0){
			if(pos.y == layer){
				image(texture, pos.x*rz, pos.z*rz, rz, rz);
			}
			if(layer == pos.y-1 || layer == pos.y+1){
			//else{
				tint(255, 126);
				image(texture, pos.x*rz, pos.z*rz, rz, rz);
				tint(255, 255);
			}
		}
		if(view == 1){
			
		}
		if(view == 2){

		}
		if(view == 3){
			beginCamera();
    		camera();
    		//translate( width/2., height/2, 3*zoom*R);
    		//rotateX(PI/4);
    		rotateX((2*mouseY-height)*PI/height);
    		//rotateZ(PI/4);
    		rotateZ((2*mouseX-width)*PI/width);
    		//translate( -width/2, -height/2, -0);
    		endCamera();
		}
	}

}

class tortuga extends bloque{
	//bloque area[][][];
	boolean Rx = false, Ry = false, Rz = false, Sett = false,Sett1 = false;
	ArrayList<bloque> residuo = new ArrayList();
	JSONArray output = new JSONArray();
	int 	Sx = 0, Sy = 0, Sz = 0;
	int 	Ex = 0, Ey = 0, Ez = 0;

	tortuga(){
		super("tortuga");
		act();
	}

	void display(){
		if(view == 0){
			if(pos.y == layer){
				image(texture, pos.x*rz, pos.z*rz, rz, rz);
			}
			if(layer == pos.y-1 || layer == pos.y+1){
			//else{
				tint(255, 126);
				image(texture, pos.x*rz, pos.z*rz, rz, rz);
				tint(255, 255);
			}
		}
		/*if(space.pressedreleased()){
			println("Haciendo...");
			act();
		}*/
	}

	void act(){
		println("Haciendo...");
		if(!Sett){
			for(int x = 0; x < bG.length-1; x++){
				for(int y = 0; y < bG[0].length-1; y++){
					for(int z = 0; z < bG[0][0].length-1; z++){
						if(bG[x][y][z].name != "air"){
							println("x"+x+"y"+y+"z"+z);
							println("NO ES AIRE");
							if(!Rx || !Ry || !Rz){
								Sx = x;Sy = y;Sz = z;
								println(Sx+" "+Sy+" "+Sz);
								Rx = true;Ry = true;Rz = true;
							}
							if(Ex < x){
								Ex = x;
								println(Ex);
							}
							if(Ey < y){
								Ey = y;
								println(Ey);
							}
							if(Ez < z){
								Ez = z;
								println(Ez);
							}
						}
					}
				}
			}

			//area[][][] = new bloque[(Ex-Sx)+1][(Ey-Sy)+1][(Ez-Sz)+1];
			println("Agregando");
			for(int x = 0; x < (Ex-Sx)+1; x++){
				for(int y = 0; y < (Ey-Sy)+1; y++){
					for(int z = 0; z < (Ez-Sz+1); z++){
						//area[x][y][z] = new bloque(bG[Sx+x][Sy+y][Sz+z].name,x,y,z);
						println("x"+x+"y"+y+"z"+z);
						if(bG[Sx+x][Sy+y][Sz+z].name != "air"){
							residuo.add(new bloque(bG[Sx+x][Sy+y][Sz+z].name,x,y,z));
						}
					}
				}
			}

		for(int i = 0; i < residuo.size(); i++){
				JSONObject bQ = new JSONObject();
				bQ.setInt("id",i);
    			bQ.setString("name", residuo.get(i).name);
    			bQ.setFloat("x", residuo.get(i).pos.x);
    			bQ.setFloat("y", residuo.get(i).pos.y);
    			bQ.setFloat("z", residuo.get(i).pos.z);
    			output.setJSONObject(i, bQ);
			}
			saveJSONArray(output, "data/output"+month()+"_"+day()+"_"+hour()+"_"+minute()+".json");
		Sett = true;
		}
	}
}

void grid(){

	for (int i = 0; i < (height / rz)+1; i++){
		line(0,rz*i,width,rz*i);
	}
	for (int i = 0; i < (width / rz); i++){
		line(rz*i,0,rz*i,height);
	}

}

class selector{
	PVector pos;
	bloque selected;

	selector(){
		selected = bloques.get(1);
		pos = new PVector();
		pos.x = (width-5*rz);
		pos.y = 0;
	}

	void display(){
		fill(255);
		rect(5,height-rz-5,rz,rz,2);
		image(selected.texture,5,height-rz-5,rz,rz);
		textSize(rz);
		text("Y ="+layer,rz*2,height-rz-5);
		rect(pos.x, pos.y, (width/10)*2, height);
		float raz = ((width/10)*2)/3-5;
		float bx = 5+pos.x,bz = 5+pos.z;
		for(int i = 0 ; i < bloques.size() ; i++){
			rect(bx+(raz)*(i%3),bz+raz*int(i/3),rz,rz);
			image(bloques.get(i).texture,bx+(raz)*(i%3),bz+raz*int(i/3),rz,rz);
			if(mousePressed){
				if(dist(mouseX,mouseY,bx+raz*(i%3)+rz/2,bz+raz*int(i/3)+rz/2) < rz/2){
					selected = bloques.get(i); 
				}
			}
		}
	}

	void inGrid(){
		for (int i = 0; i < (height / rz)+1; i++){
			for(int j = 0; j < (width / rz); j++){
				if(layer > 0){
					bG[j][layer-1][i].display();
				}
				bG[j][layer][i].display();
				if(layer < 49){
					bG[j][layer+1][i].display();
				}
			}
		}
		if(mouseX > 0 && mouseX < width-(width/10)*2 && mouseY > 0 && mouseY < height){
			if(mousePressed){
				bG[int(mouseX/rz)][layer][int(mouseY/rz)] = new bloque(selected.name,mouseX/rz,layer,mouseY/rz);
			}
		}
	}

}

controlKey w, s, a, d, ctrl, space, shift, e, c;

class controlKey {
  char key = 0;
  String code;
  boolean pressed;
  boolean last;

  controlKey() {
  }
  boolean pressedreleased() {
    if (pressed == true) {
      last = true;
    }
    if (pressed == false && last == true) {
      last = false;
      return true;
    }
    return false;
  }

}

void keyPressed() {
  setKey(keyCode, true);
  if (keyCode == ESC) {
    exit();
  }
  if (key == 'r') {
    setup();
  }
  if (key == '+') {
    zoom++;
  }
  if (key == '-') {
    zoom--;
  }

}

void keyReleased() {
	setKey(keyCode, false);
}

boolean setKey(int k, boolean b) {
  switch (k) {
  case 'w':
  case 'W':
    return w.pressed = b;
  case 's':
  case 'S':
    return s.pressed = b;
  case 'd':
  case 'D':
    return d.pressed = b;
  case 'a':
  case 'A':
    return a.pressed = b;
  case ' ': 
    return space.pressed = b;
  case 'e':
  case 'E':
    return e.pressed = b;
  case 'c':
  case 'C':
    return c.pressed = b;
  case SHIFT:
    return shift.pressed = b;
  case CONTROL:
    return ctrl.pressed = b;
  default:  
    return b;
  }

}

void setKeys() {
  w = new controlKey();
  s = new controlKey();
  d = new controlKey();
  a = new controlKey();
  space = new controlKey ();
  shift = new controlKey ();
  ctrl = new controlKey ();
  e = new controlKey ();
  c = new controlKey ();

}

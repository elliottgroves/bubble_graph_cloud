ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Connection> connections = new ArrayList<Connection>();
int ry = 0, rx = 0, transX = 0, transY = 0, zoom = 10, startX = -1, startY = -1;

void setup() {
  size(600,400,P3D);
  dataSetup();
}

void draw() {
  background(200);
  pushMatrix();
  translate(width/2.0 + transX, height/2.0 + transY);
  
  zoom = constrain(zoom, 2, 50);
  scale(zoom/10.0);
  
  rx++;
  ry++;
  rotateX(rx/100.0);
  rotateY(ry/100.0);
  
  for(int i = 0; i < nodes.size(); i++) {
    nodes.get(i).render();
  }
  
  for(int i = 0; i < connections.size(); i++) {
    connections.get(i).render();
  }
  
  ArrayList<PVector> nodeScreenPositions = new ArrayList<PVector>();
  
  for(int i = 0; i < nodes.size(); i++) {
    nodeScreenPositions.add(new PVector(round(nodes.get(i).sX()), round(nodes.get(i).sY())));
    nodeScreenPositions.add(new PVector(nodes.get(i).lX, nodes.get(i).hX));
  }
  
  popMatrix();
  
  for(int i = 0; i < nodeScreenPositions.size(); i++) {
    text((i +1) + ": " + nodeScreenPositions.get(i).toString() +  " " + nodes.get(floor(i/2)).isMouseOver(), 10, 40*i + 20);
  }
  
}

void mousePressed() {
  startX = mouseX - transX;
  startY = mouseY - transY;
}

void mouseDragged() {
  transX = mouseX - startX;
  transY = mouseY - startY;
}

void mouseReleased() {
  transX = mouseX - startX;
  transY = mouseY - startY;
  
  startX = startY = -1;
}

void mouseWheel(MouseEvent event) {
  zoom -= event.getCount();
}

void dataSetup() {
  nodes.add(new Node(50, 50, 50));
  nodes.add(new Node(-50, -50, -50));
  connections.add(new Connection(50, 50, 50, -50, -50, -50));
}

class Node {
  int x, y, z, s;
  float hX = 0, hY = 0, lX = 0, lY = 0;
  
  Node(int xx, int yy, int zz) {
    x = xx; y = yy; z = zz;
    s = 40;
  }
  
  void render() {
    hX = hY = 0;
    lX = lY = width;
    PVector[] corners = new PVector[8];
    corners[0] = new PVector(x - s/2, y - s/2, z - s/2); //top back left
    corners[1] = new PVector(x - s/2, y + s/2, z - s/2); //top back right
    corners[2] = new PVector(x - s/2, y - s/2, z + s/2); //top front left
    corners[3] = new PVector(x - s/2, y + s/2, z + s/2); //top front right
    corners[4] = new PVector(x + s/2, y - s/2, z - s/2); //bottom back left
    corners[5] = new PVector(x + s/2, y + s/2, z - s/2); //bottom back right
    corners[6] = new PVector(x + s/2, y - s/2, z + s/2); //bottom front left
    corners[7] = new PVector(x + s/2, y + s/2, z + s/2); //bottom front right
    
    for(int i = 0; i < 7; i++) {
      if(sxfv(corners[i]) > hX) hX = sxfv(corners[i]);
      if(sxfv(corners[i]) < lX) lX = sxfv(corners[i]);
      if(syfv(corners[i]) > hY) hY = syfv(corners[i]);
      if(syfv(corners[i]) < lY) lY = syfv(corners[i]);
    }
    
    pushMatrix();
      translate(x,y,z);
      if(isMouseOver()) stroke(0); else stroke(255);
      noFill();
      box(s);
    popMatrix();
    
  }
  
  boolean isMouseOver() {
    return (mouseX > lX && mouseX < hX && mouseY > lY && mouseY < hY);
  }
  
  float sX() {
    return screenX(x,y,z); 
  }
  
  float sY() {
    return screenY(x,y,z); 
  }
}

class Connection {
  int x1, y1, z1, x2, y2, z2;
  Connection(int xo, int yo, int zo, int xt, int yt, int zt) {
    x1 = xo; y1 = yo; z1 = zo; x2 = xt; y2 = yt; z2 = zt;
  }
  
  void render() {
    stroke(255);
    line(x1, y1, z1, x2, y2, z2);
  }
}

// get rounded float screen x from 3d PVector
float sxfv(PVector v) {
  return round(screenX(v.x, v.y, v.z));
}

// get rounded float screen y from 3d PVector
float syfv(PVector v) {
  return round(screenY(v.x, v.y, v.z));
}
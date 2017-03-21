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
  popMatrix();
  for(int i = 0; i < nodes.size(); i++) {
    text("" + nodes.get(i).isMouseOver(), nodes.get(i).sX(), nodes.get(i).sY());
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
  int x, y, z, size;
  Node(int xx, int yy, int zz) {
    x = xx; y = yy; z = zz;
    size = 40;
  }
  
  void render() {
    pushMatrix();
      translate(x,y,z);
      stroke(255);
      noFill();
      box(size);
    popMatrix();
  }
  
  boolean isMouseOver() {
    return false;
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
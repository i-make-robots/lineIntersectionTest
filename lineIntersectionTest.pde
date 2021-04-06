//-------------------------------------------------------------------
// Do two lines intersect?
// Visually confirming our test works.
// This code by dan@marginallyclever.com 2021-04-06
//
// Original lesson from https://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect/
//-------------------------------------------------------------------

class Point2D {
  float x,y;
}

class Particle {
  Point2D p,v;
  
  Particle() {
    p = new Point2D();
    p.x=random(width);
    p.y=random(height);

    float speed = 10;
    v = new Point2D();
    v.x = random(speed*2) - speed;
    v.y = random(speed*2) - speed;
  }
  
  void move(float delta) {
    float x2 = p.x + v.x * delta;
    float y2 = p.y + v.y * delta;

    // bounce off screen edge
    if(x2<0) {
      x2 = -x2;
      v.x = -v.x;
    }
    if(x2>=width) {
      x2 = width-(x2-width);
      v.x = -v.x;
    }
    
    if(y2<0) {
      y2 = -y2;
      v.y = -v.y;
    }
    if(y2>=height) {
      y2 = height-(y2-height);
      v.y = -v.y;
    }
    p.x=x2;
    p.y=y2;
  }
}

class Line {
  Particle a=new Particle();
  Particle b=new Particle();
  
  void draw() {
    line(a.p.x,a.p.y, b.p.x,b.p.y);
  }
  
  void move(float delta) {
    a.move(delta);
    b.move(delta);
  }
}

Line [] lines;

void setup() {
  size(800,800);
  
  lines = new Line[2];
  for(int i=0;i<lines.length;++i ) {
    lines[i]=new Line();
  }
  /*
  lines[0].a.p.x=50;
  lines[0].a.p.y=10;
  lines[0].b.p.x=50;
  lines[0].b.p.y=50;
  lines[1].a.p.x=50;
  lines[1].a.p.y=40;
  lines[1].b.p.x=50;
  lines[1].b.p.y=90;
  */
}

void draw() {
  background(255);
  
  for(Line n : lines) {
    n.move(0.3);
    n.draw();
  }
  
  for(int i=0;i<lines.length-1;++i) {
    Line a = lines[i];
    for(int j=i+1;j<lines.length;++j) {
      Line b = lines[j];
      if(doIntersect(a.a.p,a.b.p,b.a.p,b.b.p)) {
        stroke(255,0,0);
        a.draw();
        stroke(0,0,255);
        b.draw();
        stroke(0);
      }
    }
  }
}

boolean onSegment(Point2D p, Point2D q, Point2D r) {
  return (q.x <= Math.max(p.x, r.x) && q.x >= Math.min(p.x, r.x) &&
          q.y <= Math.max(p.y, r.y) && q.y >= Math.min(p.y, r.y));
}

int orientation(Point2D p, Point2D q, Point2D r) {
  // See https://www.geeksforgeeks.org/orientation-3-ordered-Points/
  // for details of below formula.
  double val = (q.y - p.y) * (r.x - q.x) -
               (q.x - p.x) * (r.y - q.y);

  if (Math.abs(val)<1e-7) return 0; // colinear

  return (val > 0)? 1: 2; // clock or counterclock wise
} 

boolean doIntersect(Point2D p1, Point2D q1, Point2D p2, Point2D q2) {
  // Find the four orientations needed for general and special cases
  int o1 = orientation(p1, q1, p2);
  int o2 = orientation(p1, q1, q2);
  int o3 = orientation(p2, q2, p1);
  int o4 = orientation(p2, q2, q1);

  // General case
  if (o1 != o2 && o3 != o4)
      return true;

  // Special Cases
  // p1, q1 and p2 are colinear and p2 lies on segment p1q1
  if (o1 == 0 && onSegment(p1, p2, q1)) return true;

  // p1, q1 and q2 are colinear and q2 lies on segment p1q1
  if (o2 == 0 && onSegment(p1, q2, q1)) return true;

  // p2, q2 and p1 are colinear and p1 lies on segment p2q2
  if (o3 == 0 && onSegment(p2, p1, q2)) return true;

  // p2, q2 and q1 are colinear and q1 lies on segment p2q2
  if (o4 == 0 && onSegment(p2, q1, q2)) return true;

  return false; // Doesn't fall in any of the above cases
}

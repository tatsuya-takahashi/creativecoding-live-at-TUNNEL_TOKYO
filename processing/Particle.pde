// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// A circular particle

import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.IOException;


int maxCount = 1;

class Box {

  // We need to keep track of a Body and a radius
  Body body;
  float r;

  color col;
  color colf;
  String text;
  
  boolean isTouched = false;

  boolean delete = false;

  Box(float x, float y, float r_) {
    r = r_;
    // This function puts the particle in the Box2d world
    makeBody(x, y, r);
    body.setUserData(this);
    col = color(0,0,100,100);
    colf = color(0,0,0,100);
    
    try {
    File f = new File("/Users/tatsuya.takahashi/tweets.csv");
    BufferedReader br = new BufferedReader(new FileReader(f));
 
    String[][] data = new String[maxCount][10];
    String line = br.readLine();
    this.text = "";
    for (int row = 0; line != null; row++) {
      if (row >= maxCount) {
        this.text = line.split(",", 0)[4];
        maxCount = maxCount + 1;
        break;
      }
      data[row] = line.split(",", 0);
      line = br.readLine();
    }
    br.close();
    
    if (this.text == "") {
      int rowNum = int(random(1, maxCount - 1));
      this.text = data[rowNum][4];
    }
    
    } catch(IOException ex) {
      //
    }
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  void delete() {
    delete = true;
  }

  // Change color when hit
  void change() {
    if (!this.isTouched) {
      this.isTouched = true;
      col = color(random(0,359), 40, 80);
      colf = color(0,0,100);
    }

  }

  // Is the particle ready for deletion?
  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2 || delete) {
      killBody();
      return true;
    }
    return false;
  }
  // 
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(a);
    fill(col);
    // stroke(0);
    // strokeWeight(0);
    // strokeJoin(ROUND);
    noStroke();
    rect(0,0,360,60, 5);
    // ellipse(0, 0, r*20, r*2);
    fill(colf);
    PFont font = createFont("Yu Gothic",9 ,true);
    textFont (font);
    textSize(9);
    text(this.text, 0, 0, 360, 40);
    // Let's add a line so we can see the rotation
    // line(0, 0, r, 0);
    popMatrix();
  }

  // Here's our function that adds the particle to the Box2D world
  void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.createBody(bd);
    
    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(200);
    float box2dH = box2d.scalarPixelsToWorld(25);
    sd.setAsBox(box2dW, box2dH);

    //// Make the body's shape a circle
    //CircleShape cs = new CircleShape();
    //cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = 0.3;

    // Attach fixture to body
    body.createFixture(fd);

    body.setAngularVelocity(random(-0.01, 0.01));
  }
}

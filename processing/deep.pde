// *********************************************
//
//   WANDERING PARTICLES
//   by André Casey, 2017
//   www.andrecasey.com
//  
//   Adaptation of the particles example from 
//   sketch.js by Justin Windle into Processing
//   using p5js. 
//   https://github.com/soulwire/sketch.js
//
// *********************************************
import java.util.Random;
import themidibus.*;
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
MidiBus foxdot;
MidiBus nanoKey;
Box2DProcessing box2d;

// An ArrayList of particles that will fall on the surface
ArrayList<Box> boxes;
Boundary wall;
Boundary wall2;


// ----------------------------------------
// Configuration
// ----------------------------------------

// GLOBALS
int MAX_PARTICLES = 1000;
//var COLORS = [ '#31CFAD', '#ADDF8C', '#FF6500', '#FF0063', '#520042', '#DAF7A6' ];
String[] COLORS = {"#69D2E7", "#A7DBD8", "#E0E4CC", "#F38630", "#FA6900", "#FF4E50", "#F9D423" };
//var COLORS = [ '#581845', '#900C3F', '#C70039', '#C70039', '#FFC300', '#DAF7A6' ];
//var COLORS = [ 'rgba(49,207,173,.7)', 'rgba(173,223,140,.7)', 'rgba(255,101,0,.7)', 'rgba(255,0,99,.7)', 'rgba(82,0,66,.7)' ];

//ARRAYS
ArrayList<Circle> particles = new ArrayList<Circle>();
ArrayList<Circle> pool = new ArrayList<Circle>();

//VARIABLES
float wander1 = 0.5;
float wander2 = 2.0;
float drag1 = .9;
float drag2 = .99;
float force1 = 2;
float force2 = 8;
float theta1 = -0.5;
float theta2 = 0.5;
//float size1 = 5;
//float size2 = 180;
float sizeScalar = 0.97;
Random javarandom = new Random();

float angle = 0;

int cc = 0;

// ----------------------------------------
// Particle Functions
// ----------------------------------------

class Circle {
  
    boolean alive;
    float size;
    float wander;
    float theta;
    float drag;
    int h;
    int s;
    int b;
    PVector location;
    PVector velocity;
  
    public Circle(int x, int y, float size) {
      this.alive = true;
      this.size = size;
      this.wander = 0.15;
      this.theta = random( TWO_PI );
      this.drag = 0.92;
      this.h = 0;
      this.s = 0;
      this.b = 100;
      this.location = new PVector(x, y);
      this.velocity = new PVector(0.0, 0.0);
    }
    void move() {
        this.location.add(this.velocity);
        this.velocity.mult(this.drag);
        this.theta += random( theta1, theta2 ) * this.wander;
        this.velocity.x += sin( this.theta ) * 0.1;
        this.velocity.y += cos( this.theta ) * 0.1;
        this.size *= sizeScalar;
        this.alive = this.size > 0.5;
    }
    void show() {
      //arc( this.location.x, this.location.y, this.size, 0, TWO_PI );
      fill( this.h, this.s, this.b, 100 );
      noStroke();
      ellipse(this.location.x,this.location.y, this.size, this.size);
    }

}

void spawn(int  x,int y, int h, int s, int b, float size1, float size2) {
    Circle particle;
    float theta;
    float force;
    if ( particles.size() >= MAX_PARTICLES ) {
        pool.add(particles.get(0));
        particles.remove(0);
    }
    particle = new Circle(x, y, random(size1,size2));
    particle.wander = random( wander1, wander2 );
    // particle.clr = COLORS[random.nextInt(5)];
    particle.h = h;
    particle.s = s;
    particle.b = b;
    particle.drag = random( drag1, drag2 );
    theta = random( TWO_PI );
    force = random( force1, force2 );
    particle.velocity.x = sin( theta ) * force;
    particle.velocity.y = cos( theta ) * force;
    particles.add( particle );
}
void update() {
    int i;
    Circle particle;
    for ( i = particles.size() - 1; i >= 0; i-- ) {
        particle = particles.get(i);
        if ( particle.alive ) {
          particle.move();
        } else {
          Circle tmpParticle = particles.get(i);
          pool.add(tmpParticle);
          particles.remove(i);
          // pool.add( particles.splice( i, 1 )[0] );
        }
    }
}
//void moved() {
//    // Particle particle;
//    float max;
//    int i;
//    max = random( 1, 4 );
//    //  println(max);
//    for ( i = 0; i < max; i++ ) {
//      spawn( mouseX, mouseY );
//    }
//}


// ----------------------------------------
// Runtime
// ----------------------------------------

void setup() {
  // createCanvas(windowWidth, windowHeight);
  fullScreen();
  // size(1280, 780);
  smooth();

  // colorMode(HSB);
  colorMode(HSB,360,100,100);
  frameRate(30);
  MidiBus.list();
  foxdot = new MidiBus(this, 0, 0);
  nanoKey = new MidiBus(this, 1, 0);
  
  
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  // Turn on collision listening!
  box2d.listenForCollisions();

  // Create the empty list
  boxes = new ArrayList<Box>();

  wall = new Boundary(width/2, height, width - 100, 10);
  wall2 = new Boundary(width/2, 400, 500, 10);

  
}

void draw() {
  update();
    // drawingContext.globalCompositeOperation = "normal";
  background(198 + cc, 13, 61 + cc, 100);

    
  if (random(30) < 0.1) {
    float sz = random(10, 20);
    boxes.add(new Box(random(width / 2 - 300, width / 2 + 300), 20, 50));
  }

  // box
  box2d.step();

  // Look at all particles
  for (int i = boxes.size()-1; i >= 0; i--) {
    Box p = boxes.get(i);
    p.display();
    // Particles that leave the screen, we delete them
    // (note they have to be deleted from both the box2d world and our list
    if (p.done()) {
      boxes.remove(i);
    }
  }

   // drawingContext.globalCompositeOperation = "lighter";
  for (int i = particles.size() - 1; i >= 0; i--) {
      particles.get(i).show();
    }

  wall.display();
  wall2.display();
}

//void mouseMoved() {
//   moved();
//}

//void touchMoved() {
//    moved();
//}

void noteOn(int channel, int number, int value){
    println(number);
  // println("a");
  // println("channel:" + channel + " number:" + number +" value:"+ value);
  
  // void spawn(int  x,int y, int h, int s, int b, float size1, float size2) {
  if (channel == 0) {
    // nanoKey
    int postionX = (width / 60) * (number - 36);
    int positionY = height - ( (height / 60) * (number - 36) );
    spawn(postionX,  positionY, int(random(0, 360)),  50, 100, value * 5, value * 5);
  }
  if (channel == 1) {
    // pads
    spawn(100,         height - 200, 200,  50, 100, value, value);
    spawn(width - 100, height - 200, 200,  50, 100, value, value);
  }
  if (channel == 2) {
    // Guitar
    spawn((number- 60) * 40,  400, 360,  30, 100, 20, 20);
    //spawn(number + 1000, 700, 200,  50, 100, value, value);
  }
  if (channel == 4) {
    // bass
    spawn(width / 2,  (height + 200) - number * 10, 200,  0, 50, 50, 50);
    // spawn(number + 1000, 700, 200,  50, 100, value, value);
  }
  if (channel == 5) {
    // Synth
    angle += 0.01;
    float x = ((width / 2) * cos(angle)) + width / 2;
    spawn(int(x),  200, 150,  50, 100, 40, 40);
  }
  if (channel == 10) {
    // bass drum
    spawn(width / 2,  height - 100, 40,  100, 90, 100, 100);
  }
}



void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  //println();
  //println("Note Off:");
  //println("--------");
  //println("Channel:"+channel);
  //println("Pitch:"+pitch);
  //println("Velocity:"+velocity);
}


void controllerChange(int channel, int number, int value, long timestamp, String bus_name) {
  // Receive a controllerChange
  if (number == 1) {
    cc = value - 64;
  }
}

// Collision event functions!
void beginContact(Contact cp) {
  // Get both shapes
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Box.class && o2.getClass() == Box.class) {
    Box p1 = (Box) o1;
    p1.change();
    // p1.delete();
    Box p2 = (Box) o2;
    p2.change();
    // p2.delete();
    Vec2 pos = box2d.getBodyPixelCoord(p1.body);
    spawn(int(pos.x),  int(pos.y), int(random(0, 360)),  100, 100, 100, 100);
    
  }

  if (o1.getClass() == Boundary.class) {
    Box p = (Box) o2;
    p.change();
  }
  if (o2.getClass() == Boundary.class) {
    Box p = (Box) o1;
    p.change();
  }
}

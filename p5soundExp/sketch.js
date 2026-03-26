let radius = 10 ; 
let soundSource, spatializer;
let cnv;

let x = 0;
let y = 0;
let z = 100;

let vX;
let vY;
let vZ;

function preload() {
  soundSource = loadSound('/assets/sorry.mp3');
}

function setup() {
  describe(
    'A 3D shape with a sound source attached to it. The sound source is spatialized using the Panner3D class. Click to play the sound.'
  );
  cnv = createCanvas(300, 300, WEBGL);
  cnv.mousePressed(playSound);

  camera(0, 0, 0, 0, 0, 1);
  
  textAlign(CENTER,CENTER);
  
  angleMode(DEGREES);

  vX = random(-0.5, 0.5);
  vY = random(-0.5, 0.5);
  vZ = random(-0.5, 0.5) * 1.5;

  spatializer = new p5.Panner3D();
  spatializer.maxDist(100);
  soundSource.loop();
  soundSource.disconnect();
  soundSource.connect(spatializer);
}

function playSound() {
  soundSource.play();
}

function draw() {
  background(220);
  push();
  textSize(5);
  fill(0);
  translate(0,0,100);
  //text('click to play', 0, 0);
  pop();
  // Update Box and Sound Source Position
  push();
  moveSoundBox();
  box(5, 5, 5);
  pop();
}

// Rotate 1 degree per frame along all three axes
function moveSoundBox() {
  x = x + vX;
  y = y + vY;
  z = z + vZ;

  if (x > radius || x < -radius) {
    vX = -vX;
  }
  if (y > radius || y < -radius) {
    vY = -vY;
  }
  if (z > 250 || z < 80) {
    vZ = -vZ;
  }
  //set the position of the 3D panner
  spatializer.set(x, y, z);
  //set the postion of the box
  translate(x, y, z);
  rotateX(45 + frameCount);
  rotateZ(45);
}
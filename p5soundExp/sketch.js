let song;

function preload() {
  song = loadSound("./assets/sorry.mp3")
}

function setup() {
  createCanvas(400, 400);
  song.playMode("restart");
  song.play();
}

function mouseClicked() {
  if (song.isPlaying()) {
    song.pause()
  } else {
    song.play()
  }
}

function draw() {
  background(200);
}

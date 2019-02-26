import processing.sound.*;
AudioIn input;
Amplitude amp;
FFT fft;

ShapeContainer sc;
PVector[][] positions;

float scale;
float theta;
float theta_vel;
float theta_acc;
float r;
float r_con;
int rad_pos;
float t_rad;
float t_init;
boolean init;
float rot;
// float wert;
// int counter;

int bands = int(pow(2,9));
float[] spectrum = new float[bands];

void setup() {
	size(600,600);
	// fullScreen(P2D);
	// fullScreen();
	// frameRate(120);
  // smooth();

  fft = new FFT(this, bands);
  input = new AudioIn(this, 0);
  input.start();
  amp = new Amplitude(this);
  amp.input(input);
	fft.input(input);

	sc = new ShapeContainer("",17);
  intVec();

  //// parameter initalisation
  r_con = height*6e-3;
  theta = random(TWO_PI);
  theta_acc = 1e-2;
  // tt = (float)2*60/120;
  scale = min(width,height);
 // wert = 1/(cos(PI/4)*sin(PI/4));
}

void draw(){
	background(255);

	//// sound analysis
  // input.amp(0);
  float amp_sc = map(amp.analyze(), 0, 0.5, 0, 1);
	// float volume_temp;
	// if (volume >= 0.48) {// possible normalisation if input is too loud
	// 	counter += 1;
	// 	rot_temp = volume;
	// }
	// println(amp_sc);
  float scale_ = map(amp_sc, 0, 1, scale*0.8, scale*1.2); // take the full frequency bandwith
  fft.analyze(spectrum);
  rot = ((spectrum[0]+spectrum[1])/2+spectrum[3]*0.3)*10; // take the lower frequencies

  //// move characters of logo w.r.t. to current input amplitude
  if (t_init < 5) {// initial phase
    r = r_con*(50*exp(-3*t_init));
    t_init += 0.01;
    drawPositions(0, new PVector(scale_,scale_), r, theta);
  }
  else {
   // float[] radien = {tan(t_rad/5), sin(t_rad/5), t_rad*0.051, 1/(cos(PI/4+t_rad/20)*sin(PI/4+t_rad/20))-wert, sqrt(1-cos(t_rad)), abs(sq(sin(t_rad/5))),
                     // 3*80, 3*100, 3*46, 3*50, 3*80, 3*80};
    float[] radien = {t_rad*0.051, 3*100}; // radius function + number of "go throughs (0-2pi)"
    if (!init) {rad_pos=int(random(radien.length/2)); init=true; theta=0; println("Radius function is number: "+rad_pos);}
    r = r_con*radien[rad_pos];
    if (theta<=radien[radien.length/2+rad_pos]&&abs(rot)>=0.1) {
    	if (theta_vel <= 0.03) {theta_vel += theta_acc*rot*0.3;}
    // if (rot >= 0.6) { theta_vel += theta_acc*rot*0.6; }
    // if (rot >= 0.6) { theta +=  signw(random(-1,1))*random(TWO_PI);}
     // println(theta_vel);
      theta += theta_vel;
      if (t_rad<=20){ t_rad += 0.05*(rot*1.3);}
      drawPositions(0, new PVector(scale_,scale_), r, theta);
    }
    else {
      theta_vel += -theta_acc*sign(theta_vel,theta)*40*signw(theta_vel);
      theta += theta_vel*10*signw(theta);
      t_rad += -t_rad*0.05*sign(t_rad,theta);
      drawPositions(0, new PVector(scale_,scale_), r, theta);
      if (theta_vel<=0&&theta>=radien[radien.length/2+rad_pos]*.75) {
        scale+=-.1*scale;
        if (scale<=1) {
         // delay(2000);
          t_init = 0;
          init = false;
          t_rad = 0;
          theta = random(TWO_PI);
          scale=min(width,height);
          intVec();
        }
      }
    }
  }
// println(frameRate);
}



void intVec() {
   positions = new PVector[1][sc.shapes.length];
    for(int i=0;i<sc.shapes.length; i++) {
      float rng=0.065;
      // positions[p][i] = new PVector(0,0,0);
      // positions[p][i].add(new PVector(random(-rng,rng),random(-rng,rng),0));
      positions[0][i] = new PVector(random(-rng,rng),random(-rng,rng),0);
    }
}

void drawPositions(int position, PVector scale, float ra, float phi) {
	for(int i=0;i<sc.shapeCount;i++){
		float xpos=(positions[position][i].x*width*ra*cos(phi))+(width-scale.x)/2;
		float ypos=(positions[position][i].y*height*ra*sin(phi))+(height-scale.y)/2;
		shape(sc.shapes[i], xpos, ypos, scale.x, scale.y);
	}
}

int sign(float f, float phi) {
  if (f >= 0&&phi>=0) return 1;
  if (f < 0&&phi<0) return 0;
  return 0;
}

int signw(float f) {
  if (f >= 0) return 1;
  if (f < 0) return 0;
  return 0;
}


// void lerpPositions(int position1, int position2, float t) {
// 	for(int i=0;i<sc.shapeCount;i++) {
// 		int xpos=int(lerp(positions[position1][i].x, positions[position2][i].x, t)*float(width));
// 		int ypos=int(lerp(positions[position1][i].y, positions[position2][i].y, t)*float(width));
// 		shape(sc.shapes[i], xpos, ypos, (float)width, (float)height); //maybe the shapes would have a different rot?
// 	}
// }

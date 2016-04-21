var n;
var lineDistance;
var numNodes;
var numPoints;
var nodeSize;
var param;
var positive;
var negative;
var accent;
var accent2;

function setup() {
  var c = createCanvas(800, 450);
  //canvas.parent('myClass');
  noStroke();
  lineDistance = 120;
  numPoints = 150;
  nodeSize = 200;
  param = 1.5;
  positive = color(220);
  negative = color(18, 37, 44);
  accent = color(152, 0, 0);
  accent2 = color(255, 102, 0);

  n = new Node(width/2, height/2, nodeSize, numPoints);
  n.initPoints();
}

function draw() {
  noFill();
  background(negative);
  n.node();
}


function Node(_centerX, _centerY, _nodeSize, _pointsContained) {
  this.rand;
  this.innerSquareSide;
  this.centerX;
  this.centerY;
  this.nodeSize;
  this.p = [];
  this.centerX = _centerX;
  this.centerY = _centerY;
  this.nodeSize = _nodeSize;
  this.pointsContained = _pointsContained;
  this.innerSquareSide = (nodeSize * sqrt(2)) / 2;
  this.rand = Math.round(random(this.pointsContained));


  this.initPoints = function() {
    for (var i = 0; i < this.pointsContained; i++) {
      this.p[i] = new Point();
      if (i == this.rand) this.p[i].sourcePoint = true;
      this.setLocation(this.p[i]);
    }
  }


  this.setLocation = function(p) {
    return p.location.set(random(-width / 2, width / 2), random(-height / 2, height / 2));
  }


  this.node = function() {
    push();
    translate(this.centerX, this.centerY);
    for (var i = 0; i < this.pointsContained; i++) {
      this.p[i].ccounter = 0;
      this.p[i].run();
      if (this.p[i].location.x > width / 2) this.p[i].location.x = 0;
      if (this.p[i].location.y > height / 2) this.p[i].location.y = 0;
      this._x = this.p[i].location.x;
      this._y = this.p[i].location.y;

      for (var j = 0; j < this.pointsContained/2; j++) {
        this._x2 = this.p[j].location.x;
        this._y2 = this.p[j].location.y;
        this.r = dist(this._x, this._y, this._x2, this._y2);

        if (this.r <= lineDistance) {
          this.opacityMap = map(this.r, 0, lineDistance, 255, 0);
          if (i % 12 === 0) {
            stroke(152, 0, 0, this.opacityMap);
            fill(152, 0, 0, 150);
          } else {
            stroke(215, this.opacityMap);
            fill(215, 150);
          }
          strokeWeight(1);
          line(this._x, this._y, this._x2, this._y2);
        }
      }
      if (this.p[i].location.mag() > width / 2) this.p[i].location.set(0, 0);
    }
    pop();
  }
}


function Point() {
  this.location = createVector();
  this.velocity = createVector(random(-param, param), random(-param, param));
  this.wind;
  this.r = random(6, 12);
  this.sourcePoint = false;


  this.run = function() {
    this.wind = createVector(random(-0.1, 0.1), random(-0.1, 0.1));
    this.location.add(this.velocity);
    this.velocity.add(this.wind);
    this.velocity.limit(param);
    strokeWeight(3);
    point(this.location.x, this.location.y);
    noStroke();
    ellipse(this.location.x, this.location.y, this.r, this.r);
  }
}
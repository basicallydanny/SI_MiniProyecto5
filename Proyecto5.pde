import java.util.HashMap;
import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress pdAddress;

Movie[] movies; 
Table table;
int maxMovies = 100;
int defaultGenreColor = color(245, 245, 245);
ArrayList<PVector> positions = new ArrayList<PVector>(); 

int bgColorStart;
int bgColorEnd;
float bgTransitionTime = 7000;
float bgTransitionProgress = 0;
float lastTime = 0;  

HashMap<String, Integer> genreColors = new HashMap<String, Integer>();

void setup() {
  fullScreen();
  frameRate(60);
  loadData();
  noStroke();
   
   oscP5 = new OscP5(this, 12000); // Local Port
   pdAddress = new NetAddress("192.168.100.177", 8000); // Address and PureData Port

  genreColors.put("Action", color(255, 0, 0));         // Rojo
  genreColors.put("Adventure", color(255, 140, 0));    // Naranja
  genreColors.put("Comedy", color(255, 255, 0));       // Amarillo
  genreColors.put("Drama", color(72, 61, 139));        // Azul Oscuro
  genreColors.put("Fantasy", color(186, 85, 211));     // Fucsia
  genreColors.put("Horror", color(54, 54, 54));        // Gris
  genreColors.put("Sci-Fi", color(60, 179, 113));      // Verde
  genreColors.put("Thriller", color(128, 0, 128));     // Morado
  genreColors.put("Mystery", color(0, 128, 128));      // Verde Azulado
  genreColors.put("Romance", color(255, 192, 203));    // Rosa
  genreColors.put("Animation", color(0, 255, 255));    // Cyan
  genreColors.put("Biography", color(222, 184, 135));  // Beige
  genreColors.put("Crime", color(220, 20, 60));       // Carmesí
  bgColorStart = color(random(255), random(255), random(255));
  bgColorEnd = color(random(255), random(255), random(255));
}

void loadData() {
  table = loadTable("data.csv", "header");
  int totalRows = min(table.getRowCount(), maxMovies);
  movies = new Movie[totalRows];
  for (int i = 0; i < totalRows; i++) {
    TableRow row = table.getRow(i);
    String title = row.getString("Title");
    float rating = row.getFloat("Rating");
    float revenue = row.getFloat("Revenue (Millions)");
    float runtime = row.getFloat("Runtime (Minutes)");
    String genre = row.getString("Genre");
    movies[i] = new Movie(title, rating, revenue, runtime, genre);
  }
}

void draw() {
  float currentTime = millis();
  float deltaTime = currentTime - lastTime;
  lastTime = currentTime;
  bgTransitionProgress += deltaTime;
  if (bgTransitionProgress > bgTransitionTime) {
    bgTransitionProgress = 0;
    bgColorStart = bgColorEnd;
    bgColorEnd = color(random(255), random(255), random(255));
  }
  int bgColor = lerpColor(bgColorStart, bgColorEnd, bgTransitionProgress / bgTransitionTime);
  background(bgColor);
  for (int i = 0; i < movies.length; i++) {
    movies[i].display();
  }
}

void mousePressed() {
  for (int i = 0; i < movies.length; i++) {
    if (movies[i].isMouseOver()) {
      movies[i].triggerEffect();
      SendOSC1(movies[i]);
    }
  }
}

void SendOSC1(Movie movie) {
  int genreColor = genreColors.getOrDefault(movie.genre, defaultGenreColor);
  OscMessage sending1 = new OscMessage("");
  sending1.add(int(movie.revenue));
  sending1.add(int(movie.runtime));
  sending1.add(int(movie.rating));
  sending1.add(abs(genreColor));
  oscP5.send(sending1, pdAddress);
}

class Movie {
  String title;
  float rating;
  float revenue;
  float runtime;
  String genre;
  float x, y;
  float diameter;
  color bubbleColor;
  boolean effectTriggered = false;
  float countdown = 0;

  Movie(String title, float rating, float revenue, float runtime, String genre) {
    this.title = title;
    this.rating = rating;
    this.revenue = Float.isNaN(revenue) ? 0 : revenue;  // Set to 0 if NaN
    this.runtime = runtime;
    this.genre = genre;

    diameter = map(rating, 0, 10, 20, 80);
    bubbleColor = color(map(this.revenue, 0, 500, 0, 255));
    
    boolean overlap = true;
    while (overlap) {
      x = random(diameter / 2, width - diameter / 2);
      y = random(diameter / 2, height - diameter / 2);
      overlap = false;
      for (PVector p : positions) {
        if (dist(x, y, p.x, p.y) < diameter) {
          overlap = true;
          break;
        }
      }
    }
    positions.add(new PVector(x, y));
  }

  void display() {
    fill(bubbleColor, 150);
    ellipse(x, y, diameter, diameter);
    if (effectTriggered && countdown > 0) {
      float pulse = sin(frameCount * 0.1) * (runtime / 10);
      float auraSize = diameter + pulse + map(runtime, 0, 200, 20, 100);
      fill(150, 150, 255, 50);
      ellipse(x, y, auraSize, auraSize);
      countdown--;
    }
    if (dist(mouseX, mouseY, x, y) < diameter / 2) {
      fill(255);
      textAlign(CENTER);
      text(title + " (" + rating + ")", x, y - diameter / 2 - 10);
    }
  }

  boolean isMouseOver() {
    return dist(mouseX, mouseY, x, y) < diameter / 2;
  }

  void triggerEffect() {
    effectTriggered = true;
    countdown = runtime / 10 * frameRate;
    if (genreColors.containsKey(genre)) {
      bgColorEnd = genreColors.get(genre);
    } else {
      bgColorEnd = defaultGenreColor;
    }
  }
}

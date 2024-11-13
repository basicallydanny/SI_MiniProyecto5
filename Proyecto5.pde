import java.util.HashMap;

Movies[] movies; 
Table table;
int maxMovies = 100;
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

  genreColors.put("Action", color(255, 0, 0));         // Tomato Red
  genreColors.put("Adventure", color(255, 140, 0));    // Dark Orange
  genreColors.put("Comedy", color(255, 255, 0));       // Peach
  genreColors.put("Drama", color(72, 61, 139));          // Dark Slate Blue
  genreColors.put("Fantasy", color(186, 85, 211));       // Medium Orchid
  genreColors.put("Horror", color(54, 54, 54));          // Dark Gray
  genreColors.put("Sci-Fi", color(60, 179, 113));        // Medium Sea Green
  genreColors.put("Thriller", color(105, 105, 105));     // Dim Gray
  genreColors.put("Mystery", color(70, 130, 180));       // Steel Blue
  genreColors.put("Romance", color(255, 182, 193));      // Light Pink
  genreColors.put("Animation", color(135, 206, 235));    // Sky Blue
  bgColorStart = color(random(255), random(255), random(255));
  bgColorEnd = color(random(255), random(255), random(255));
}

void loadData() {
  table = loadTable("cleaned_data.csv", "header");
  int totalRows = min(table.getRowCount(), maxMovies);
  movies = new Movies[totalRows];
  for (int i = 0; i < totalRows; i++) {
    TableRow row = table.getRow(i);
    String title = row.getString("Title");
    float rating = row.getFloat("Rating");
    float revenue = row.getFloat("Revenue (Millions)");
    float runtime = row.getFloat("Runtime (Minutes)");
    String genre = row.getString("Genre");
    movies[i] = new Movies(title, rating, revenue, runtime, genre);
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
    }
  }
}

class Movies {
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

  Movies(String title, float rating, float revenue, float runtime, String genre) {
    this.title = title;
    this.rating = rating;
    this.revenue = revenue;
    this.runtime = runtime;
    this.genre = genre;

    diameter = map(rating, 0, 10, 20, 80);

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

    bubbleColor = color(255, map(revenue, 0, 500, 100, 255), map(revenue, 0, 500, 100, 255));
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
    }
  }
}

Participant participant;
JSONArray condList;

void setup() {
  println("test");
  condList = loadJSONArray("json/conditions/taxes.json");
  condList.append(loadJSONArray("json/conditions/disorders.json"));
  saveJSONArray(condList, "json/conditions/clump.json");
  participant = new Participant(false, condList);
  frameRate(30);
}

void draw() {
  if (frameCount % 90 == 0){
    participant.clockControl();
  }
}

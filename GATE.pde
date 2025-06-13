import FileSystem;
Participant participant;
void setup() {
  //println("setup start");
  frameRate(30);
  participantInit();
}

void participantInit() {
  JSONArray condList;
  JSONArray eventList;
  
  condList = loadJSONArray("json/conditions/taxes.json");
  condList.append(loadJSONArray("json/conditions/disorders.json"));
  
  eventList = loadJSONArray("json/events/taxes.json");
  saveJSONArray(condList, "json/conditions/clump.json");
  
  participant = new Participant(false, condList, eventList);
}

void draw() {
  if (frameCount % 90 == 0){
    participant.clockControl();
  }
}

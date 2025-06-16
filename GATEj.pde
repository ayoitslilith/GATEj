import java.nio.file.FileSystem;

Participant participant;

void setup() {
  //println("setup start");
  frameRate(30);
  float windowSize = 35.0;
  participantInit();
  System.out.println("Initialization complete!");
}

void participantInit() {
  JSONArray condList;
  JSONArray eventList;
  
  condList = loadJSONArray("json/conditions/disorders.json");
  condList.append(loadJSONArray("json/conditions/taxes/taxes.json"));
  condList.append(loadJSONArray("json/conditions/taxes/stomach.json"));
  
  eventList = loadJSONArray("json/events/taxes/stomach.json");

  saveJSONArray(condList, "json/conditions/clump.json");
  saveJSONArray(eventList, "json/events/clump.json");
  
  participant = new Participant(false, condList, eventList);
}

void diagnostic(String message) {
  System.out.println(message);
}

void draw() {
  if (frameCount % 90 == 0){
    participant.clockControl();
  }
}

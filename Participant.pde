class Participant {
  
  //int participantSeed;
  
  float phys, psyc, stim;
  FloatDict inStats;
  FloatDict chStats;
  FloatDict caps; //unimplemented
  String[] physStatNames = {"hygienics", "immunology", "musculoskeletal", "diatetics"};
  String[] psycStatNames = {"stability", "certainty", "identity", "serenity"};
  String[] stimStatNames = {"currency", "focus", "passion", "superordinance"};
  String[] inStatNames = {"hygienics", "immunology", "musculoskeletal", "diatetics",
                       "stability", "certainty", "identity", "serenity",
                       "currency", "focus", "passion", "superordinance"};
 
  JSONArray activeConds;
  JSONArray possibleConds;
  
  JSONArray events;
  //JSONArray checkMods;
  //String[] checkNames = {"Mind Reading", "Polarizing", "Magical Thinking", "Fortune Telling", "Filtering", "Catastrophizing"}

  private Listener pListener = null;

  Participant(boolean loadPrev, JSONArray possibleCondsParam, JSONArray eventsParam) {
    possibleConds = possibleCondsParam;
    if (loadPrev) {
      println("No loading code yet, sorry!");
    }
    else {
      //participantSeed = random.nextInt(0, 999999));
      inStats = new FloatDict();
      
      inStats.set("phys", 3.0);
      inStats.set("psyc", 3.0);
      inStats.set("stim", 3.0);
      
      inStats.set("hygienics", 3.0);
      inStats.set("immunology", 3.0);
      inStats.set("musculoskeletal", 3.0);
      inStats.set("dietetics", 3.0);
      
      inStats.set("stability", 3.0);
      inStats.set("certainty", 3.0);
      inStats.set("identity", 3.0);
      inStats.set("serenity", 3.0);
      
      inStats.set("currency", 3.0);
      inStats.set("focus", 3.0);
      inStats.set("passion", 3.0);
      inStats.set("superordinance", 3.0);
      
      
      inStats.set("minute", 0.0);
      inStats.set("hour", 9.0);
      inStats.set("day", 1.0);
      
      inStats.set("step", 0.0);
      
      inStats.set("work_shift", 1.0);
      
      activeConds = new JSONArray();
      addCond("At Least I'm Alive");
      events = eventsParam;
    }
  }

  void statChangeClear() {
    chStats.set("phys", 0.0);
    chStats.set("psyc", 0.0);
    chStats.set("stim", 0.0);
    
    chStats.set("hygienics", 0.0);
    chStats.set("immunology", 0.0);
    chStats.set("musculoskeletal", 0.0);
    chStats.set("dietetics", 0.0);
    
    chStats.set("stability", 0.0);
    chStats.set("certainty", 0.0);
    chStats.set("identity", 0.0);
    chStats.set("serenity", 0.0);
    
    chStats.set("currency", 0.0);
    chStats.set("focus", 0.0);
    chStats.set("passion", 0.0);
    chStats.set("superordinance", 0.0);
  }
  
  void applyStatChanges() {
    for (int i = 0; i < inStatNames.length; i++) {
      
      inStats.set(inStatNames[i], inStats.get(inStatNames[i]) + chStats.get(inStatNames[i]));
    }
    statChangeClear();
  }
  
  void inStatUp(String stat) {
    inStats.set(stat, inStats.get(stat) + 1);
  }
  
  void addCond(String name){
    for (int i = 0; i < possibleConds.size(); i++) {
      if (possibleConds.getJSONObject(i).getString("name").equals(name)) {
        activeConds.append(possibleConds.getJSONObject(i));
        break;
      }
    }
  }
  
  void removeConds(String name){
    for (int i = 0; i < activeConds.size(); i++){
      if (activeConds.getJSONObject(i).getString("name").equals(name)) {
        activeConds.remove(i);
      }
    }
  }
  
  void runEffect(JSONObject effect) {
    JSONArray affectedStats;
    switch (effect.getString("effectType")) {
      case "changeArith":
        affectedStats = effect.getJSONArray("stats");
        for (int u = 0; u < affectedStats.size(); u++) {
          chStats.set(affectedStats.getString(u), chStats.get(affectedStats.getString(u)) + affectedStats.getFloat(u));
        }
        break;
      case "checkMod":
        //checkMods.get += effect.getFloat("val"); //unused
        break;
      case "changeCap":
        float val = effect.getFloat("val");
        affectedStats = effect.getJSONArray("stats");
        if (val > 0) {
          for (int i = 0; i < affectedStats.size(); i++) {
              if (chStats.get(affectedStats.getString(i)) > val) {
                chStats.set(affectedStats.getString(i), val);
              }
          }
        }
        else if (val < 0) {
          for (int i = 0; i > affectedStats.size(); i++) {
            if (chStats.get(affectedStats.getString(i)) < val) {
              chStats.set(affectedStats.getString(i), val);
            }
          }
        }
        else if (val == 0) {
          for (int i = 0; i > affectedStats.size(); i++) {
            chStats.set(affectedStats.getString(i), 0); 
          }
        }
        break; 
       case "event":
         runEvent(effect.getString("event"));
         break;
       case "addCond":
         addCond(effect.getString("condition"));
         break;
       case "removeCond":
         removeConds(effect.getString("condition"));
         break;
    }
  }
  
  void runEvent(String name){
    for (int i = 0; i < events.size(); i++) {
      if (events.getJSONObject(i).getString("name").equals(name)) {
        JSONObject event = events.getJSONObject(i);
        int roll = random.nextInt(6) + 1 
        for (int o = 0; o < event.getJSONArray("checks").size(); o++) {
          
        }
      }
    }
  }
  
  void doEffectTag(String tag) {
    for (int i = 0; i < activeConds.size(); i++) {
      JSONArray condEffects = activeConds.getJSONObject(i).getJSONArray("effects");
      for (int o = 0; o < condEffects.size(); o++) {
        JSONObject effect = condEffects.getJSONObject(o);
        JSONArray tags = effect.getJSONArray("tags");
        boolean tagPresent = false;
        for (int u = 0; u < tags.size(); u++) {
          if (tags.getString(u) == tag) {
            runEffect(effect);
            break;
          }
        }
      }
    }
  }
  
  void step() {
    doEffectTag("taxes");
    applyStatChanges();
    checkMod = 0;
    chStats.set("step") = inStats.get("step") + 1.0;
  }
  
  void clock() {
    inStatUp("minute");
    if (inStats.get("minute") % 10 == 0) {
      step();
    }
    if (inStats.get("minute") % 60 == 0) {
      inStatUp("hour");
      inStats.set("minute", 0);
      if (inStats.get("hour") == 17) {
        inStats.set("shift", -1.0);
      }
      else if (inStats.get("hour") == 24) {
        inStats.set("hour", 0.0);
      }
      else if (inStats.get("hour") == 9) {
        inStats.set("shift", 1.0);
      }
    }
  }
  
  void clockControl() {
    if (inStats.get("shift") > 0) {
      clock();
    }
    else {
      for (int i = 0; i < 10; i++) {
        clock();
      }
    }
  }
  
  void saveParticipant() {
    //unimplemented
  }
}

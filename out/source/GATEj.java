/* autogenerated by Processing revision 1297 on 2025-06-16 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import java.nio.file.FileSystem;
import java.util.concurrent.Future;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class GATEj extends PApplet {




Participant participant;

public void setup() {
  //println("setup start");
  frameRate(30);
  float windowSize = 35.0f;
  participantInit();
  System.out.println("Initialization complete!");
}

public void participantInit() {
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

public void diagnostic(String message) {
  System.out.println(message);
}

public void draw() {
  if (frameCount % 90 == 0){
    participant.clockControl();
  }
}
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
  float checkMod;
  
  
  
  Participant(boolean loadPrev, JSONArray possibleCondsParam, JSONArray eventsParam){
    possibleConds = possibleCondsParam;
    if (loadPrev) {
      println("No loading code yet, sorry!");
    }
    else {
      //participantSeed = int(random(0, 999999));
      inStats = new FloatDict();
      
      inStats.set("phys", 3.0f);
      inStats.set("psyc", 3.0f);
      inStats.set("stim", 3.0f);
      
      inStats.set("hygienics", 3.0f);
      inStats.set("immunology", 3.0f);
      inStats.set("musculoskeletal", 3.0f);
      inStats.set("dietetics", 3.0f);
      
      inStats.set("stability", 3.0f);
      inStats.set("certainty", 3.0f);
      inStats.set("identity", 3.0f);
      inStats.set("serenity", 3.0f);
      
      inStats.set("currency", 3.0f);
      inStats.set("focus", 3.0f);
      inStats.set("passion", 3.0f);
      inStats.set("superordinance", 3.0f);
      
      
      inStats.set("minute", 0.0f);
      inStats.set("hour", 9.0f);
      inStats.set("day", 1.0f);
      
      inStats.set("step", 0.0f);
      
      inStats.set("shift", 1.0f);
      
      activeConds = new JSONArray();
      addCond("At Least I'm Alive");
      events = eventsParam;
    } 
  }
  
  public void statChangeClear() {
    chStats.set("phys", 0.0f);
    chStats.set("psyc", 0.0f);
    chStats.set("stim", 0.0f);
    
    chStats.set("hygienics", 0.0f);
    chStats.set("immunology", 0.0f);
    chStats.set("musculoskeletal", 0.0f);
    chStats.set("dietetics", 0.0f);
    
    chStats.set("stability", 0.0f);
    chStats.set("certainty", 0.0f);
    chStats.set("identity", 0.0f);
    chStats.set("serenity", 0.0f);
    
    chStats.set("currency", 0.0f);
    chStats.set("focus", 0.0f);
    chStats.set("passion", 0.0f);
    chStats.set("superordinance", 0.0f);
  }
  
  public void applyStatChanges() {
    for (int i = 0; i < inStatNames.length; i++) {
      
      inStats.set(inStatNames[i], inStats.get(inStatNames[i]) + chStats.get(inStatNames[i]));
    }
    statChangeClear();
  }
  
  public void inStatUp(String stat) {
    inStats.set(stat, inStats.get(stat) + 1);
  }
  
  public void addCond(String name){
    for (int i = 0; i < possibleConds.size(); i++) {
      if (possibleConds.getJSONObject(i).getString("name").equals(name)) {
        activeConds.append(possibleConds.getJSONObject(i));
        break;
      }
    }
  }
  
  public void removeConds(String name){
    for (int i = 0; i < activeConds.size(); i++){
      if (activeConds.getJSONObject(i).getString("name").equals(name)) {
        activeConds.remove(i);
      }
    }
  }
  
  public void runEffect(JSONObject effect) {
    JSONArray affectedStats;
    switch (effect.getString("effectType")) {
      case "changeArith":
        affectedStats = effect.getJSONArray("stats");
        for (int u = 0; u < affectedStats.size(); u++) {
          chStats.set(affectedStats.getString(u), chStats.get(affectedStats.getString(u)) + affectedStats.getFloat(u));
        }
        break;
      case "checkMod":
        checkMod += effect.getFloat("val");
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
  
  public void runEvent(String name){
    for (int i = 0; i < events.size(); i++) {
      if (events.getJSONObject(i).getString("name").equals(name)) {
        JSONObject event = events.getJSONObject(i);
        for (int o = 0; o < event.getJSONArray("checks").size(); o++) {
          
        }
      }
    }
  }
  
  public void doEffectTag(String tag) {
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
  
  public void step() {
    doEffectTag("taxes");
    applyStatChanges();
    checkMod = 0;
  }
  
  public void clock() {
    inStatUp("minute");
    if (inStats.get("minute") % 10 == 0) {
      step();
    }
    if (inStats.get("minute") % 60 == 0) {
      inStatUp("hour");
      inStats.set("minute", 0);
      if (inStats.get("hour") == 17) {
        inStats.set("shift", -1.0f);
      }
      else if (inStats.get("hour") == 24) {
        inStats.set("hour", 0.0f);
      }
      else if (inStats.get("hour") == 9) {
        inStats.set("shift", 1.0f);
      }
    }
  }
  
  public void clockControl() {
    if (inStats.get("shift") > 0) {
      clock();
    }
    else {
      for (int i = 0; i < 10; i++) {
        clock();
      }
    }
  }
  
  public void saveParticipant() {
    //unimplemented
  }
  
}


  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "GATEj" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

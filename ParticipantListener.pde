// base
interface ParticipantListener {
  public String diagnosticOutput(String message);  // event diagnostics, displayed through the phone app
  public String socialMediaOutput(String message); // things the participant will say on social media. let's see if i have time
  public String instatsOutput(JSONArray inStats, String[] inStatNames);  // refers to the main group of twelve
  public String chstatsOutput(JSONArray chStats);  // changestats to be clear
  public String exstatsOutput(JSONArray exStats);  // might not actually implement exstats. let's see where my whims take me
}

// use this to produce command line output for the participant (DON'T ACTUALLY OK?)
/**
class ParticipantListenerConsole implements ParticipantListenerBase {
    
    public String diagnosticOutput(String message) {
        return message;
    }

    public String socialMediaOutput(String message) {
        return message;
    }

    public String inStatsOutput(JSONArray inStats, String[] inStatNames) {
        String toOutput = "";
        for (int i = 0; i < inStatNames.length; i++) {
            toOuput.append(
                "Stat: \'" + inStatNames[i] + "\'\n Value: \'" + Float.toString(inStats.get(inStatNames[i])) + "\'\n\n"
            );
        }
        toOutput.append("\n");
        return toOutput;
    }

    public String chstatsOutput(JSONArray chStats) {
        String toOutput = "";
        for (int i = 0; i < inStatNames.length; i++) {
            toOuput.append(
                "Stat: \'" + inStatNames[i] + "\'\n Change: \'" + Float.toString(chStats.get(inStatNames[i])) + "\'\n\n"
            );
        }
        toOutput.append("\n");
        return toOutput;
    }
    
    public String exStatsOutput(JSONArray exStats) {
        return null;
    }

}

// currently not implemented
class ParticipantListenerGUI implements ParticipantListenerBase {

}*/

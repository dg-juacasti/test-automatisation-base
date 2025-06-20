import java.util.HashMap;
import java.util.Map;

public class DataManager {
    private static Map<String, Object> sharedData = new HashMap<>();
    
    public static void saveCharacterData(Map<String, Object> characterData) {
        sharedData.put("character", characterData);
        System.out.println("Character data saved: " + characterData);
    }
    
    public static Map<String, Object> getCharacterData() {
        Map<String, Object> data = (Map<String, Object>) sharedData.get("character");
        System.out.println("Retrieved character data: " + data);
        return data;
    }
    
    public static void clearCharacterData() {
        sharedData.remove("character");
        System.out.println("Character data cleared");
    }
}

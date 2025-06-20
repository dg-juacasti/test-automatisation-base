package helpers;

import java.util.Arrays;
import java.util.List;
import java.util.Random;
import java.util.UUID;

public class DataGenerator {
    private static final Random random = new Random();
    
    public static String randomHeroName() {
        List<String> names = Arrays.asList(
            "Captain Thunder", "Quantum Woman", "Nebula Knight", "Shadowblade", 
            "Phoenix Warrior", "Frost Giant", "Emerald Guardian", "Crimson Defender",
            "Star Hunter", "Void Master", "Lunar Wolf", "Solar Eagle"
        );
        return names.get(random.nextInt(names.size())) + " " + UUID.randomUUID().toString().substring(0, 6);
    }
    
    public static String randomAlterEgo() {
        List<String> firstNames = Arrays.asList(
            "John", "Sarah", "Michael", "Diana", "Peter", "Natasha", "Bruce", "Wanda",
            "Victor", "Jessica", "Scott", "Jean"
        );
        
        List<String> lastNames = Arrays.asList(
            "Smith", "Johnson", "Richards", "Parker", "Rogers", "Stark", "Banner", "Maximoff",
            "Strange", "Quill", "Grey", "Summers"
        );
        
        return firstNames.get(random.nextInt(firstNames.size())) + " " + 
               lastNames.get(random.nextInt(lastNames.size()));
    }
    
    public static String randomDescription() {
        List<String> descriptions = Arrays.asList(
            "A powerful hero with extraordinary abilities.",
            "Master of mystic arts and defender of the universe.",
            "Highly trained specialist with unparalleled combat skills.",
            "Scientific genius who developed incredible technology.",
            "Enhanced individual with superhuman strength and speed.",
            "Cosmic entity capable of manipulating energy at will.",
            "Former villain turned hero seeking redemption.",
            "Guardian of ancient artifacts and forbidden knowledge."
        );
        
        return descriptions.get(random.nextInt(descriptions.size()));
    }
    
    public static List<String> randomPowers() {
        List<List<String>> powerSets = Arrays.asList(
            Arrays.asList("Flight", "Super Strength"),
            Arrays.asList("Telekinesis", "Mind Control"),
            Arrays.asList("Invisibility", "Phasing"),
            Arrays.asList("Energy Blasts", "Force Fields"),
            Arrays.asList("Healing Factor", "Enhanced Senses"),
            Arrays.asList("Time Manipulation", "Dimensional Travel"),
            Arrays.asList("Elemental Control", "Weather Manipulation"),
            Arrays.asList("Shapeshifting", "Size Alteration")
        );
        
        return powerSets.get(random.nextInt(powerSets.size()));
    }
    
    public static int randomInvalidId() {
        return 9000 + random.nextInt(1000);
    }
}

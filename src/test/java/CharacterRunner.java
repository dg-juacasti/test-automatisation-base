import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.Test;

import static org.junit.Assert.assertTrue;

public class CharacterRunner {

  @Test
  public void testRunner(){

    Results results = Runner.path("src/test/java/com/pichincha/features")
      .tags("~@ignore").outputCucumberJson(true).parallel(1);

    assertTrue(results.getErrorMessages(), results.getFailCount() == 0);
  }
}
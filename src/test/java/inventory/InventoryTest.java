package inventory;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.DynamicNode;

class InventoryTest {

    @Karate.Test
    Iterable<DynamicNode> testInventory() {
        return Karate.run("classpath:inventory");
    }
}
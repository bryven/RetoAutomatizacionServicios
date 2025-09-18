package transversal;

import java.util.Random;

public class SimpleIdGenerator {
    public int generateId() {
        return new Random().nextInt(1000); // genera número entre 0 y 999
    }
}

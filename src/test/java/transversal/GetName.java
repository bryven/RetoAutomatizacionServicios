package transversal;

import java.util.Random;

public class GetName {
    private static final String[] CATEGORIES = {"DOGS","CATS","BIRDS","FISH","REPTILES","SMALL PETS","EXOTIC PETS","FARM ANIMALS","INSECTS","AMPHIBIANS"};
    private static final String[] NAMES = {"MAX","BELLA","CHARLIE","LUNA","COCO","ROCKY","DAISY","MILO","LOLA","OLIVER","SIMBA","NALA","TEDDY","LUCY","ZOE","BRUNO","CHLOE","DUKE","SASHA","BUDDY"};
    public static final String[] STATUS = {"available", "pending", "sold"};

    public String returnCategory() {
        Random random = new Random();
        String category = CATEGORIES[random.nextInt(CATEGORIES.length)];
        return category;
    }
    public String returnName() {
        Random random = new Random();
        String name = NAMES[random.nextInt(NAMES.length)];
        return name;
    }
    public String returnStatus() {
        Random random = new Random();
        String status = STATUS[random.nextInt(STATUS.length)];
        return status;
    }
}

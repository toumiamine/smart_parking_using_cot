package smart.parking.cot.Entity;


public class ParkingSlot {

    private String id;
    private int isAvailable;

    public ParkingSlot() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getIsAvailable() {
        return isAvailable;
    }

    public void setAvailable(int isAvailable) {
        this.isAvailable = isAvailable;
    }

}

package smart.parking.cot.Entity;


public class ParkingSlot {

    private String id;
    private boolean isAvailable;

    public ParkingSlot() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public boolean getIsAvailable() {
        return isAvailable;
    }

    public void setAvailable(boolean isAvailable) {
        this.isAvailable = isAvailable;
    }

}

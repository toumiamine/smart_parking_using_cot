package smart.parking.cot.Entity;
import jakarta.nosql.mapping.Column;
import jakarta.nosql.mapping.Entity;
import jakarta.nosql.mapping.Id;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;

@Entity
public class Parking {
    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    private String parking_id;
    @Column
    private float longitude;
    @Column
    private float latitude;
    @Column
    private String name;


    Parking() {

    }

    public void setParking_id(String parking_id) {
        this.parking_id = parking_id;
    }

    public void setLongitude(float longitude) {
        this.longitude = longitude;
    }

    public void setLatitude(float latitude) {
        this.latitude = latitude;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String get_parking_id() {
        return parking_id;
    }

    public float get_parking_lat() {
        return longitude;
    }

    public float get_parking_long() {
        return latitude;
    }

    public String get_parking_name() {
        return name;
    }


    public static Parking.ParkingBuilder builder() {
        return new ParkingBuilder();
    }

    public static class ParkingBuilder {
        private String parking_id;
        private float longitude;
        private float latitude;
        private String name;

        public Parking.ParkingBuilder  WithId(String parking_id) {
            this.parking_id = parking_id;
            return this;
        }

        public Parking.ParkingBuilder WithLong(float longitude) {
            this.longitude=longitude;
            return this;
        }

        public Parking.ParkingBuilder WithLat(float latitude) {
            this.latitude=latitude;
            return this;
        }

        public Parking.ParkingBuilder WithName(String name) {
            this.name=name;
            return this;
        }

        public Parking build() {

            Parking parking = new Parking();
            parking.parking_id = parking_id;
            parking.latitude=latitude;
            parking.longitude=longitude;
            parking.name=name;

            return parking;
        }



    }
}

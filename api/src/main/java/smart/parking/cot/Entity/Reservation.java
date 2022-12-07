package smart.parking.cot.Entity;


import jakarta.nosql.mapping.Column;
import jakarta.nosql.mapping.Entity;
import jakarta.nosql.mapping.Id;
import jakarta.security.enterprise.identitystore.Pbkdf2PasswordHash;

import java.util.Set;

import static java.util.Objects.requireNonNull;

@Entity
public class Reservation {
    @Id
    private String id;
    @Column
    private String reservation_date;

    @Column
    private String start_date;

    @Column
    private String end_date;

    @Column
    private String validity;


    Reservation() {
    }

    public String getId() {
        return id;
    }

    public String getReservation_date() {
        return reservation_date;
    }

    public String getValidity() {
        return validity;
    }

    public String getStart_date() {
        return start_date;
    }
    public String getEnd_date() {
        return end_date;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setReservation_date(String reservation_date) {
        this.reservation_date = reservation_date;
    }

    public void setValidity(String validity) {
        this.validity = validity;
    }


    public void setStart_date(String start_date) {
        this.start_date = start_date;
    }

    public void setEnd_date(String end_date) {
        this.end_date = end_date;
    }
    public static ReservationBuilder builder() {
        return new ReservationBuilder();
    }
    public static class ReservationBuilder {
        private String id;

        private String reservation_date;

        private String validity;

        private String start_date;

        private String end_date;

        private ReservationBuilder() {
        }

        public ReservationBuilder WithId(String id) {
            this.id = id;
            return this;
        }

        public ReservationBuilder WithReservationDate(String reservation_date) {
            this.reservation_date = reservation_date;
            return this;
        }

        public ReservationBuilder WithStartDate(String start_date) {
            this.start_date = start_date;
            return this;
        }

        public ReservationBuilder WithEndDate(String end_date) {
            this.end_date = end_date;
            return this;
        }

        public ReservationBuilder WithValidity(String validity) {
            this.validity = validity;
            return this;
        }

        public Reservation build() {
            requireNonNull(reservation_date, "reservation_date is required");
            requireNonNull(validity, "validity is required");

            Reservation reservation = new Reservation();
            reservation.id = id;
            reservation.start_date = start_date;
            reservation.end_date = end_date;
            reservation.reservation_date = reservation_date;
            reservation.validity = validity;
            return reservation;
        }

    }
}

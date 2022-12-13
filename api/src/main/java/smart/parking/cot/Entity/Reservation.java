package smart.parking.cot.Entity;


import jakarta.json.bind.annotation.JsonbDateFormat;
import jakarta.nosql.mapping.Column;
import jakarta.nosql.mapping.Entity;
import jakarta.nosql.mapping.Id;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.security.enterprise.identitystore.Pbkdf2PasswordHash;

import java.util.Date;
import java.util.Set;

import static java.util.Objects.requireNonNull;

@Entity
public class Reservation {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private String id;

    @JsonbDateFormat("dd-MM-yyyy'T'HH:mm:ss")
    @Column
    private Date reservation_date;
    @JsonbDateFormat("dd-MM-yyyy'T'HH:mm:ss")
    @Column
    private Date start_date;

    @Column
    @JsonbDateFormat("dd-MM-yyyy'T'HH:mm:ss")
    private Date end_date;

    @Column
    private String user_id;

    @Column
    private float price;


    Reservation() {
    }

    public String getId() {
        return id;
    }

    public Date getReservation_date() {
        return reservation_date;
    }


    public Date getStart_date() {
        return start_date;
    }
    public Date getEnd_date() {
        return end_date;
    }

    public String getUser_id() {
        return user_id;
    }
    public float getPrice() {
        return price;
    }
    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }
    public void setId(String id) {
        this.id = id;
    }

    public void setPrice(float price) {
        this.price = price;
    }
    public void setReservation_date(Date reservation_date) {
        this.reservation_date = reservation_date;
    }



    public void setStart_date(Date start_date) {
        this.start_date = start_date;
    }

    public void setEnd_date(Date end_date) {
        this.end_date = end_date;
    }
    public static ReservationBuilder builder() {
        return new ReservationBuilder();
    }
    public static class ReservationBuilder {
        private String id;

        private Date reservation_date;

        private Date start_date;

        private Date end_date;

        private String user_id;

        private float price;

        private ReservationBuilder() {
        }

        public ReservationBuilder WithId(String id) {
            this.id = id;
            return this;
        }


        public ReservationBuilder WithPrice(float price) {
            this.price = price;
            return this;
        }


        public ReservationBuilder WithReservationDate(Date reservation_date) {
            this.reservation_date = reservation_date;
            return this;
        }

        public ReservationBuilder WithUserId(String  user_id) {
            this.user_id = user_id;
            return this;
        }

        public ReservationBuilder WithStartDate(Date start_date) {
            this.start_date = start_date;
            return this;
        }

        public ReservationBuilder WithEndDate(Date end_date) {
            this.end_date = end_date;
            return this;
        }


        public Reservation build() {
            requireNonNull(reservation_date, "reservation_date is required");
            requireNonNull(start_date, "start_date is required");
            requireNonNull(end_date, "end_date is required");
            Reservation reservation = new Reservation();
            reservation.id = id;
            reservation.price = price;
            reservation.user_id = user_id;
            reservation.start_date = start_date;
            reservation.end_date = end_date;
            reservation.reservation_date = reservation_date;
            return reservation;
        }

    }
}

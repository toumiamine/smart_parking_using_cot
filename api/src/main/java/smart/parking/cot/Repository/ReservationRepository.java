package smart.parking.cot.Repository;

import jakarta.nosql.mapping.Repository;
import smart.parking.cot.Entity.Reservation;

import java.util.List;
import java.util.Optional;

public interface ReservationRepository extends Repository<Reservation, String> {

    List<Reservation> findByUser_id(String user_id);
    Optional<Reservation> findByuser_id(String user_id);
    List<Reservation> findAll();
}

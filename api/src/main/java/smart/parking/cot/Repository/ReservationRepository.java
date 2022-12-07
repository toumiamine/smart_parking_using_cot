package smart.parking.cot.Repository;

import jakarta.nosql.mapping.Repository;
import smart.parking.cot.Entity.Reservation;

import java.util.Optional;
import java.util.stream.Stream;

public interface ReservationRepository extends Repository<Reservation, String> {
    Optional<Reservation> findById(String id);

    Stream<Reservation> findAll();
}

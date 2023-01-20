package smart.parking.cot.Repository;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.nosql.mapping.Repository;
import smart.parking.cot.Entity.Parking;


import java.util.List;
import java.util.Optional;


@ApplicationScoped
public interface ParkingRepository extends Repository<Parking,String> {

    Optional<Parking> findById(String id);
    List<Parking> findAll();

}

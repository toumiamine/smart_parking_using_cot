package smart.parking.cot.services;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.nosql.mapping.Database;
import jakarta.nosql.mapping.DatabaseType;
import smart.parking.cot.Entity.Parking;

import smart.parking.cot.Repository.ParkingRepository;

import java.util.List;


@ApplicationScoped

public class parkingService {
    @Inject
    @Database(DatabaseType.DOCUMENT)
    private ParkingRepository repository;

    public void create(Parking parking) {


        Parking parking1 = Parking.builder()
                .WithId(parking.get_parking_id())
                .WithLat(parking.get_parking_lat())
                .WithLong(parking.get_parking_long())
                .WithName(parking.get_parking_name())

                .build();
        repository.save(parking1);


    }

    public List<Parking> get_all_parking(){
        return repository.findAll();



    }
}

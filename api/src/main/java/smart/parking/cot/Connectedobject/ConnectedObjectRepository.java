package smart.parking.cot.Connectedobject;


import jakarta.nosql.mapping.Repository;

import jakarta.enterprise.context.ApplicationScoped;
import java.util.List;
import java.util.Optional;
import java.util.stream.Stream;

@ApplicationScoped
public interface ConnectedObjectRepository extends Repository<ConnectedObject, String> {

    Optional<ConnectedObject> findById(String id);

    List<ConnectedObject> findAll();
}

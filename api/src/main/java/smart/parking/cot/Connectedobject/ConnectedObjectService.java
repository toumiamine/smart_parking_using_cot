package smart.parking.cot.Connectedobject;


import jakarta.nosql.mapping.Database;
import jakarta.nosql.mapping.DatabaseType;


import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import smart.parking.cot.Repository.ConnectedObjectRepository;

import java.util.Optional;

@ApplicationScoped
public class ConnectedObjectService {

    @Inject
    @Database(DatabaseType.DOCUMENT)
    private ConnectedObjectRepository repository;

    public void create(ConnectedObject connectedObject) {

        ConnectedObject connectedObject1 = ConnectedObject.builder()
                .withPin(connectedObject.getPin())
                .withType(connectedObject.getType())
                .withState(connectedObject.getState())
                .withValue(connectedObject.getValue())
                .withId(connectedObject.getId())

                .build();
        repository.save(connectedObject1);
    }

    void delete(String id) {
        repository.deleteById(id);
    }
   public  void updatePin(int pin , ConnectedObject connectedObject,String id) {


         Optional<ConnectedObject> connectedObject1 = repository.findById(id);

        connectedObject.updatePin(pin);
        repository.save(connectedObject);
    }



}








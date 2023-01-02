package smart.parking.cot.Connectedobject;


import jakarta.nosql.mapping.Database;
import jakarta.nosql.mapping.DatabaseType;


import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import java.util.List;
import java.util.Map;
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


    public Map<String, Integer> getList_spots(ConnectedObject connectedObject) {
        List<ConnectedObject> list_of_connected_object = repository.findAll();
        Map<String, Integer> map = null;
        for (int i = 0; i < list_of_connected_object.size(); i++) {
            ConnectedObject object = list_of_connected_object.get(i);
            if (object.getType() == "Slot") {
                map.put(object.getId(),object.getValue());
            }
        }
        return map;
    }





}








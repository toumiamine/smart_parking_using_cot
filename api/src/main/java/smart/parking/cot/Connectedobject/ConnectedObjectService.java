package smart.parking.cot.Connectedobject;


import jakarta.nosql.mapping.Database;
import jakarta.nosql.mapping.DatabaseType;
import org.eclipse.paho.client.mqttv3.*;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;


import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.net.ssl.SSLSocketFactory;
import java.security.Principal;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Stream;

import static java.nio.charset.StandardCharsets.UTF_8;

@ApplicationScoped
public class ConnectedObjectService {

    @Inject
    @Database(DatabaseType.DOCUMENT)
    private ConnectedObjectRepository repository;

    public void create(ConnectedObject connectedObject) {

        ConnectedObject connectedObject1 = ConnectedObject.builder()

                .withPin(connectedObject.getPin())
                .withName(connectedObject.getName())
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


    public Map<String,Float> getList_spots(ConnectedObject connectedObject) {
        List<ConnectedObject> list_of_connected_object = repository.findAll();
        Map<String,Float> map = null;
        for (int i = 0; i < list_of_connected_object.size(); i++) {
            ConnectedObject object = list_of_connected_object.get(i);
            if (object.getName() == "Slot") {
                map.put(object.getId(),object.getValue());
            }
        }
        return map;
    }





}








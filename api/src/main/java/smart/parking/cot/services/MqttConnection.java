package smart.parking.cot.services;

import jakarta.annotation.PostConstruct;
import jakarta.ejb.Startup;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.ejb.Singleton;
import jakarta.nosql.mapping.Database;
import jakarta.nosql.mapping.DatabaseType;
import org.eclipse.paho.client.mqttv3.*;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.json.JSONObject;
import smart.parking.cot.Connectedobject.ConnectedObject;
import smart.parking.cot.Repository.ReservationRepository;
import smart.parking.cot.Ressources.ParkingWebsocket;

import javax.net.ssl.SSLSocketFactory;

@ApplicationScoped
@Singleton
@Startup
public class MqttConnection {
    @Inject
    private ReservationService service;

    @Inject
    @Database(DatabaseType.DOCUMENT)
    private ReservationRepository repository;


    public void sendmsg(MqttClient client,String msg,String topic) throws MqttException {
        MqttMessage message = new MqttMessage(msg.getBytes());
        client.publish(topic,message);
    }

    public boolean isAvai(String m) {
        if (repository.existsById(m)) {
           return true;
        }
        return false;
    }

    @PostConstruct
    public void start() {
        try {
            System.out.println("starting mqtt");

            //CLIENT CONNECTION OPTIONS
            MqttClient client = new MqttClient(
                    "wss://mqtt.smart-parking.me:8083", // serverURI in format: "protocol://name:port"
                    MqttClient.generateClientId(), // ClientId
                    new MemoryPersistence()); // Persistence
            MqttConnectOptions mqttConnectOptions = new MqttConnectOptions();
            mqttConnectOptions.setConnectionTimeout(0);
            mqttConnectOptions.setUserName("broker");
            mqttConnectOptions.setPassword("broker".toCharArray());
            mqttConnectOptions.setSocketFactory(SSLSocketFactory.getDefault());
            // using the default socket factory
            //mqttConnectOptions.setConnectionTimeout(1000);
            client.connect(mqttConnectOptions);


            client.setCallback(new MqttCallback() {

                @Override
                // Called when the client lost the connection to the broker
                public void connectionLost(Throwable cause) {
                    System.out.println("client lost connection " + cause);
                }

                @Override
                public void messageArrived(String topic, MqttMessage message) {
//check if the topic is IRSensor
if (topic.equals("IRSensor")) {
         try {
        System.out.println(new String(message.getPayload()));
        JSONObject obj = new JSONObject(new String(message.getPayload()));
        ConnectedObject connectedObject = new ConnectedObject();
        String id = obj.getString("id");
        int pin = obj.getInt("pin");
        String state = obj.getString("state");
        String type = obj.getString("type");
        String value = obj.getString("value");
        connectedObject.setId(id);
        connectedObject.setPin(pin);
        connectedObject.setState(state);
        connectedObject.setType(type);
        connectedObject.setValue(value);
        //Broadcast the message to all users using websockets
        ParkingWebsocket.broadcastMessage(connectedObject);
    }
    catch (Exception e ) {
        System.out.println("hi"+e);
    }
}
//check if the topic is AccessManagement
                    else if (topic.equals("AccessManagement")) {
                        try {
                           JSONObject obj = new JSONObject(new String(message.getPayload()));
                            ConnectedObject connectedObject = new ConnectedObject();
                            String id = obj.getString("id");
                            int pin = obj.getInt("pin");
                            String state = obj.getString("state");
                            String type = obj.getString("type");
                            String value = obj.getString("value");
                            connectedObject.setId(id);
                            connectedObject.setPin(pin);
                            connectedObject.setState(state);
                            connectedObject.setType(type);
                            connectedObject.setValue(value);

                            if (connectedObject.getValue() != null) {
                                boolean isavaialble = service.isReservationValid(connectedObject.getValue().replace("\n", ""));
                                if (isavaialble == true) {
                                    String s = "openDoor";
                                    client.publish("EntryDoor",new MqttMessage(s.getBytes()) );
                                }
                                else {
                                    String s = "ReservationFailed";
                                    client.publish("EntryDoor",new MqttMessage(s.getBytes()) );
                                }
                            }
                        }
                        catch (Exception e ) {

                        }
                    }
                }


                @Override
                // Called when an outgoing publish is complete
                public void deliveryComplete(IMqttDeliveryToken token) {
                    System.out.println("delivery complete " + token);
                }
            });

            client.subscribe("AccessManagement", 1);
            client.subscribe("IRSensor", 1);
           // client.subscribe("verification", 1);
        } catch (MqttException e) {

        }
    }
        }





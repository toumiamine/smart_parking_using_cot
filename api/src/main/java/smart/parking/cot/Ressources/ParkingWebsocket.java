package smart.parking.cot.Ressources;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.nosql.mapping.Database;
import jakarta.nosql.mapping.DatabaseType;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import smart.parking.cot.Connectedobject.ConnectedObject;
import smart.parking.cot.Connectedobject.ConnectedObjectEnconder;
import smart.parking.cot.Connectedobject.ConnectedObjectDecoder;

import java.io.*;
import java.util.*;
import jakarta.websocket.EncodeException;
import jakarta.websocket.OnClose;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import smart.parking.cot.services.MqttConnection;
import smart.parking.cot.Repository.ReservationRepository;

import javax.net.ssl.SSLSocketFactory;
@ApplicationScoped
@ServerEndpoint(
        value = "/websocket_channel",
        encoders = {ConnectedObjectEnconder.class},
        decoders = {ConnectedObjectDecoder.class})
public class ParkingWebsocket {

    @Inject
    @Database(DatabaseType.DOCUMENT)
    ReservationRepository repository;




    MqttClient client; // Persistence

    {
        try {
            client = new MqttClient(
                    "wss://mqtt.smart-parking.me:8083", // serverURI in format: "protocol://name:port"
                    MqttClient.generateClientId(), // ClientId
                    new MemoryPersistence());

            MqttConnectOptions mqttConnectOptions = new MqttConnectOptions();
            mqttConnectOptions.setUserName("broker");
            mqttConnectOptions.setPassword("broker".toCharArray());
            mqttConnectOptions.setSocketFactory(SSLSocketFactory.getDefault()); // using the default socket factory
            client.connect(mqttConnectOptions);


        } catch (MqttException e) {
            throw new RuntimeException(e);
        }
    }

    public static final List<ConnectedObject> connectedObjects = Collections.synchronizedList(new LinkedList<ConnectedObject>());
    private static Hashtable<String, Session> sessions = new Hashtable<>();

    @OnMessage
    public void handleMessage(ConnectedObject connectedObject, Session session) throws MqttException {
        sendMessage(connectedObject);

    }


   /* @OnMessage
    public void onMessage(Session session, ParkingSlot parkingSlot) throws ParseException {
        System.out.println(parkingSlot.getId());
        System.out.println(parkingSlot.getIsAvailable());
        parkingSlots.add(parkingSlot);
        for (Session openSession : sessions) {
            try {
                openSession.getBasicRemote().sendObject(parkingSlot);
            } catch (IOException | EncodeException ex) {
                sessions.remove(openSession);
            }
        }
    }*/
   public static void broadcastMessage(ConnectedObject connectedObject) {
       if (connectedObject.getType().equals("Servo") & connectedObject.getId().equals("entry")) {
           System.out.println("Hani ntesti lehné");
           //System.out.println(repository.findAll());
           System.out.println("Printed sucess");
           // System.out.println(service.isReservationValid(connectedObject.getValue()));
       }
       else {
           for (Session session : sessions.values()) {
               try {
                   session.getBasicRemote().sendObject(connectedObject);
               } catch (IOException | EncodeException e) {
                   e.printStackTrace();
               }
           }
       }

   }

    public void sendMessage(ConnectedObject connectedObject) {
        // Affichage sur la console du server Web.
        //System.out.println( connectedObject );

        // On envoie le message à tout le monde.
        for( Session session : sessions.values() ) {
            try {
                session.getBasicRemote().sendObject( connectedObject );
            } catch( Exception exception ) {
                System.out.println( "ERROR: cannot send message to " + session.getId() );
            }
        }
    }


    @OnOpen
    public void open(Session session) {
        MqttConnection Cnx = new MqttConnection();
        Cnx.start();

        sessions.put( session.getId(), session );
    }

    @OnClose
    public void onClose(Session session) throws IOException, EncodeException {
        sessions.remove(session);
    }
}

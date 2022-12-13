package smart.parking.cot.Ressources;
import jakarta.websocket.server.PathParam;
import org.eclipse.paho.client.mqttv3.MqttException;
import smart.parking.cot.Entity.ParkingDecoder;
import smart.parking.cot.Entity.ParkingEncoder;
import smart.parking.cot.Entity.ParkingSlot;

import java.io.*;
import java.text.ParseException;
import java.util.*;
import jakarta.websocket.EncodeException;
import jakarta.websocket.OnClose;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import smart.parking.cot.services.MqttConnection;


@ServerEndpoint(
        value = "/slots",
        encoders = {ParkingEncoder.class},
        decoders = {ParkingDecoder.class})
public class ParkingAvailabiltyWebsocket {

    public static final List<ParkingSlot> parkingSlots = Collections.synchronizedList(new LinkedList<ParkingSlot>());
  //  private static final Set<Session> sessions = Collections.synchronizedSet(new HashSet<Session>());
    private static Hashtable<String, Session> sessions = new Hashtable<>();

    @OnMessage
    public void handleMessage(ParkingSlot parkingSlot, Session session) {
     /*   String pseudo = (String) session.getUserProperties().get( "pseudo" );
        String fullMessage = pseudo + " >>> " + message;*/

        sendMessage( parkingSlot );
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
   public static void broadcastMessage(ParkingSlot parkingSlot) {
       for (Session session : sessions.values()) {
           try {
               session.getBasicRemote().sendObject(parkingSlot);
           } catch (IOException | EncodeException e) {
               e.printStackTrace();
           }
       }
   }

    public void sendMessage(ParkingSlot parkingSlot) {
        // Affichage sur la console du server Web.
        System.out.println( parkingSlot );

        // On envoie le message à tout le monde.
        for( Session session : sessions.values() ) {
            try {
                session.getBasicRemote().sendObject( parkingSlot );
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

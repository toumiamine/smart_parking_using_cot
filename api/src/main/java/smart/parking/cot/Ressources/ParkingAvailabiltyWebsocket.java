package smart.parking.cot.Ressources;
import jakarta.websocket.server.PathParam;
import org.eclipse.paho.client.mqttv3.MqttException;
import smart.parking.cot.Entity.ParkingDecoder;
import smart.parking.cot.Entity.ParkingEncoder;
import smart.parking.cot.Entity.ParkingSlot;

import java.io.*;
import java.text.ParseException;
import java.util.*;
import javax.websocket.EncodeException;
import javax.websocket.OnClose;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;


@ServerEndpoint(
        value = "/slots",
        encoders = {ParkingEncoder.class},
        decoders = {ParkingDecoder.class})
public class ParkingAvailabiltyWebsocket {

    public static final List<ParkingSlot> parkingSlots = Collections.synchronizedList(new LinkedList<ParkingSlot>());
  //  private static final Set<Session> sessions = Collections.synchronizedSet(new HashSet<Session>());
    private Hashtable<String, Session> sessions = new Hashtable<>();

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
    public void open(Session session, @PathParam("id") String id , @PathParam("avai") boolean avai ) {
        ParkingSlot parkingSlot = new ParkingSlot();
        parkingSlot.setAvailable(avai);
        parkingSlot.setId(id);
        sendMessage(parkingSlot);
        //session.getUserProperties().put( "pseudo", pseudo );
        sessions.put( session.getId(), session );
    }

    @OnClose
    public void onClose(Session session) throws IOException, EncodeException {
        sessions.remove(session);
    }
}

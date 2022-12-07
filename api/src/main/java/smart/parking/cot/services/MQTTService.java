package smart.parking.cot.services;

import com.google.gson.Gson;
import org.eclipse.paho.client.mqttv3.*;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import smart.parking.cot.Entity.ParkingSlot;
import smart.parking.cot.Ressources.ParkingAvailabiltyWebsocket;

import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.json.spi.JsonProvider;
import javax.net.ssl.SSLSocketFactory;
import javax.websocket.EncodeException;
import javax.websocket.Session;
import java.io.IOException;
import java.text.ParseException;

import static smart.parking.cot.Ressources.ParkingAvailabiltyWebsocket.parkingSlots;

public class MQTTService {
    public static void main(String args[]) throws MqttException, ParseException {
        MqttClient client = new MqttClient(
                "wss://mqtt.smart-parking.me:8083", // serverURI in format: "protocol://name:port"
                MqttClient.generateClientId(), // ClientId
                new MemoryPersistence()); // Persistence

        MqttConnectOptions mqttConnectOptions = new MqttConnectOptions();
        mqttConnectOptions.setUserName("broker");
        mqttConnectOptions.setPassword("broker".toCharArray());
        mqttConnectOptions.setSocketFactory(SSLSocketFactory.getDefault()); // using the default socket factory
        client.connect(mqttConnectOptions);
        client.setCallback(new MqttCallback() {

            @Override
            // Called when the client lost the connection to the broker
            public void connectionLost(Throwable cause) {
                System.out.println("client lost connection " + cause);
            }

            @Override
            public void messageArrived(String topic, MqttMessage message) {
                System.out.println(topic + "::::: " + new String(message.getPayload()));

               // Gson g = new Gson();
             //   ParkingSlot parkingSlot = g.fromJson(new String(message.getPayload()), ParkingSlot.class);
               // ParkingAvailabiltyWebsocket.sendMessage(parkingSlot);
               // parkingSlots.add(parkingSlot);

            }

            @Override
            // Called when an outgoing publish is complete
            public void deliveryComplete(IMqttDeliveryToken token) {
                System.out.println("delivery complete " + token);
            }
        });

        client.subscribe("abc", 2);
      //  System.out.println("05 in payload isssssssssss" + "05".getBytes());

   /*     String time1="2022/01/02 0:01:30";
        String time2="2022/01/02 0:01:35";

        SimpleDateFormat timeFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        Date date1 = timeFormat.parse(time1);
        Date date2 = timeFormat.parse(time2);

        long sum = date1.getTime() + date2.getTime();

        System.out.println(sum);*/


     /*   client.publish(
                "imen",
                "true".getBytes(),
                1, // QoS = 2
                false);*/
        // client.disconnect();
    }

}


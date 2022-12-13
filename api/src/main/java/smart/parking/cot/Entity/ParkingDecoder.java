package smart.parking.cot.Entity;

import jakarta.websocket.DecodeException;
import jakarta.websocket.Decoder;
import jakarta.websocket.EndpointConfig;

import java.io.IOException;
import java.io.Reader;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.json.spi.JsonProvider;


public class ParkingDecoder implements Decoder.TextStream<ParkingSlot> {

    @Override
    public ParkingSlot decode(Reader reader)  {
        try {
            JsonProvider provider = JsonProvider.provider();
            JsonReader jsonReader = provider.createReader(reader);
            JsonObject jsonParkingSlot = jsonReader.readObject();
            ParkingSlot parkingSlot = new ParkingSlot();
            parkingSlot.setId(jsonParkingSlot.getString("id"));
            parkingSlot.setAvailable(jsonParkingSlot.getInt("isAvailable"));
            return parkingSlot;
        }
        catch (Exception e) {
            System.out.println(e);
        }
        ParkingSlot parkingSlot = new ParkingSlot();
        parkingSlot.setAvailable(0);
        parkingSlot.setId("");
return parkingSlot;
    }

    @Override
    public void init(EndpointConfig ec) {
    }

    @Override
    public void destroy() {
    }
}

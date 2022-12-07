package smart.parking.cot.Entity;

import java.io.IOException;
        import java.io.Reader;
        import javax.json.JsonObject;
        import javax.json.JsonReader;
        import javax.json.spi.JsonProvider;
        import javax.websocket.DecodeException;
        import javax.websocket.Decoder;
        import javax.websocket.EndpointConfig;

public class ParkingDecoder implements Decoder.TextStream<ParkingSlot> {

    @Override
    public ParkingSlot decode(Reader reader) throws DecodeException, IOException {
        JsonProvider provider = JsonProvider.provider();
        JsonReader jsonReader = provider.createReader(reader);
        JsonObject jsonParkingSlot = jsonReader.readObject();
        ParkingSlot parkingSlot = new ParkingSlot();
        parkingSlot.setId(jsonParkingSlot.getString("id"));
        parkingSlot.setAvailable(jsonParkingSlot.getBoolean("isAvailable"));
        return parkingSlot;

    }

    @Override
    public void init(EndpointConfig ec) {
    }

    @Override
    public void destroy() {
    }
}

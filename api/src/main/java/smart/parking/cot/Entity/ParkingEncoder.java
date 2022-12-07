package smart.parking.cot.Entity;

import java.io.IOException;
import java.io.Writer;
import javax.json.JsonObject;
import javax.json.JsonWriter;
import javax.json.spi.JsonProvider;
import javax.websocket.EncodeException;
import javax.websocket.Encoder;
import javax.websocket.EndpointConfig;

public class ParkingEncoder implements Encoder.TextStream<ParkingSlot> {

    @Override
    public void encode(ParkingSlot parkingSlot, Writer writer) throws EncodeException, IOException {
        JsonProvider provider = JsonProvider.provider();
        JsonObject jsonParkingSlot = provider.createObjectBuilder()
                .add("action", "add")
                .add("id", parkingSlot.getId())
                .add("isAvailable", parkingSlot.getIsAvailable())
                .build();
        try (JsonWriter jsonWriter = provider.createWriter(writer)) {
            jsonWriter.write(jsonParkingSlot);
        }
    }

    @Override
    public void init(EndpointConfig ec) {
    }

    @Override
    public void destroy() {
    }
}

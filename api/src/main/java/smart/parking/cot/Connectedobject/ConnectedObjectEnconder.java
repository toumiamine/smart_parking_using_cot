package smart.parking.cot.Connectedobject;

import jakarta.websocket.Encoder;

import java.io.IOException;
import java.io.Writer;
import javax.json.JsonObject;
import javax.json.JsonWriter;
import javax.json.spi.JsonProvider;
import jakarta.websocket.EncodeException;
import jakarta.websocket.Encoder;
import jakarta.websocket.EndpointConfig;
import smart.parking.cot.Connectedobject.ConnectedObject;

public class ConnectedObjectEnconder implements Encoder.TextStream<ConnectedObject> {

    @Override
    public void encode(ConnectedObject connectedObject, Writer writer) throws EncodeException, IOException {
        JsonProvider provider = JsonProvider.provider();
        JsonObject jsonParkingSlot = provider.createObjectBuilder()
                .add("action", "add")
                .add("id", connectedObject.getId())
                .add("pin", connectedObject.getPin())
                .add("value", connectedObject.getValue())
                .add("state",connectedObject.getState())
                .add("type",connectedObject.getType())
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

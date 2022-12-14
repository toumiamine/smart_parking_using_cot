package smart.parking.cot.Connectedobject;

import jakarta.websocket.Decoder;
import jakarta.websocket.EndpointConfig;
import smart.parking.cot.Connectedobject.ConnectedObject;

import java.io.Reader;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.json.spi.JsonProvider;


public class ConnectedObjectDecoder implements Decoder.TextStream<ConnectedObject> {

    @Override
    public ConnectedObject decode(Reader reader)  {
        try {
            JsonProvider provider = JsonProvider.provider();
            JsonReader jsonReader = provider.createReader(reader);
            JsonObject jsonConnectedObject = jsonReader.readObject();
            ConnectedObject connectedObject = new ConnectedObject();
            connectedObject.setId(jsonConnectedObject.getString("id"));
            connectedObject.setPin(jsonConnectedObject.getInt("pin"));
            connectedObject.setState(jsonConnectedObject.getString("state"));
            connectedObject.setType(jsonConnectedObject.getString("type"));
            connectedObject.setValue(jsonConnectedObject.getInt("value"));
            return connectedObject;
        }
        catch (Exception e) {
            System.out.println(e);
        }
        ConnectedObject connectedObject = new ConnectedObject();
        connectedObject.setId("");
        connectedObject.setValue(0);
        connectedObject.setType("test");
        connectedObject.setState("test");
        connectedObject.setPin(-1);
return connectedObject;
    }

    @Override
    public void init(EndpointConfig ec) {
    }

    @Override
    public void destroy() {
    }
}

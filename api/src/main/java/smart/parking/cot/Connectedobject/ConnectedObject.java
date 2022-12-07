package smart.parking.cot.Connectedobject;

import jakarta.nosql.mapping.Column;
import jakarta.nosql.mapping.Entity;
import jakarta.nosql.mapping.Id;



@Entity
public class ConnectedObject {
    @Id
    private  String id;
    @Column
    private  String name;
    @Column
    private  int pin ;
    @Column
    private  float value ;
    @Column
    private  String state ;



    public ConnectedObject(){

    }
    public String getName() {
        return name;
    }
    public String getId() { return  id ;}
    public int getPin() {return  pin ;}
    public String getState(){return  state ;}
    public float getValue(){return  value ;}








    public static ConnectedObjectBuilder builder() {
        return new ConnectedObjectBuilder();}

    public void updatePin(int pin) {
        this.pin=pin;
    }


    public static class ConnectedObjectBuilder {

        private String name;
        private int pin;
        private float value;
        private String state ;
        private String id;



        private ConnectedObjectBuilder() {

        }

        public ConnectedObjectBuilder withPin (int pin) {
            this.pin = pin;
            return this;
        }
        public ConnectedObjectBuilder withName (String name) {
            this.name=name;
            return this;
        }

        public ConnectedObjectBuilder withValue(float value) {
            this.value=value;
            return this;


        }
        public ConnectedObjectBuilder withState(String state) {
            this.state=state;
            return this;


        }
        public ConnectedObjectBuilder withId(String id) {
            this.id=id;
            return this;


        }



        public ConnectedObject build() {

            ConnectedObject connectedObject= new ConnectedObject();
            connectedObject.id=id;
            connectedObject.name=name;
            connectedObject.pin=pin;
            connectedObject.state=state;
            connectedObject.value=value;

            return  connectedObject;
        }
    }
}





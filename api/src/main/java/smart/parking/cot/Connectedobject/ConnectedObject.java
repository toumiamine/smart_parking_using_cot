package smart.parking.cot.Connectedobject;

import jakarta.nosql.mapping.Column;
import jakarta.nosql.mapping.Entity;
import jakarta.nosql.mapping.Id;



@Entity
public class ConnectedObject {
    @Id
    private  String id;
    @Column
    private  String type;
    @Column
    private  int pin ;
    @Column
    private  String value ;
    @Column
    private  String state ;



    public ConnectedObject(){

    }
    public String getType() {
        return type;
    }
    public String getId() { return  id ;}
    public int getPin() {return  pin ;}
    public String getState(){return  state ;}
    public String getValue(){return  value ;}

    public void setId(String id){this.id = id;}
    public void setValue(String value){this.value = value;}
    public void setType(String type){this.type = type;}
    public void setPin(int pin){this.pin = pin;}

    public void setState(String state){this.state = state;}
    public static ConnectedObjectBuilder builder() {
        return new ConnectedObjectBuilder();}

    public void updatePin(int pin) {
        this.pin=pin;
    }


    public static class ConnectedObjectBuilder {

        private  String type;
        private int pin;
        private String value;
        private String state ;
        private String id;



        private ConnectedObjectBuilder() {

        }

        public ConnectedObjectBuilder withPin (int pin) {
            this.pin = pin;
            return this;
        }
        public ConnectedObjectBuilder withType (String type) {
            this.type=type;
            return this;
        }

        public ConnectedObjectBuilder withValue(String value) {
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
            connectedObject.type=type;
            connectedObject.pin=pin;
            connectedObject.state=state;
            connectedObject.value=value;

            return  connectedObject;
        }
    }
}





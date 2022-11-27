package smart.parking.security.Connectedob;


import smart.parking.security.UserDTO;

import javax.annotation.security.RolesAllowed;
import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.validation.Valid;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

@Path("objects")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
@ApplicationScoped
public class ConnectedObjectResource {

    @Inject
    private ConnectedObjectService service;
    @POST
    public void create(ConnectedObject connectedObject) {
        service.create(connectedObject);
    }


    @DELETE
    @Path("/{id}")
    public void delete(@PathParam("id") String id) {
        service.delete(id);
    }


    @Path("/co/{id}")
    @PUT
    public void updatePin(@PathParam("id")  int pin ,ConnectedObject connectedobject, String id) {
        service.updatePin(pin,connectedobject,id);
    }


}

package smart.parking.cot.Connectedobject;




import jakarta.annotation.security.RolesAllowed;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;

@Path("objects")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
@ApplicationScoped
public class ConnectedObjectResource {
    @Inject
    private smart.parking.cot.Connectedobject.ConnectedObjectService service;
    @POST
    @RolesAllowed("ADMIN")
    public void create(ConnectedObject connectedObject) {
        service.create(connectedObject);
    }

    @DELETE
    @RolesAllowed("ADMIN")
    @Path("/{id}")
    public void delete(@PathParam("id") String id) {
        service.delete(id);
    }


    @Path("/co/{id}")
    @RolesAllowed("ADMIN")
    @PUT
    public void updatePin(@PathParam("id")  int pin ,ConnectedObject connectedobject, String id) {
        service.updatePin(pin,connectedobject,id);
    }


}

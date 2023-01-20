package smart.parking.cot.Ressources;


import jakarta.annotation.security.RolesAllowed;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import smart.parking.cot.Entity.Parking;
import smart.parking.cot.services.parkingService;

import java.util.List;

@Path("parking")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)

@ApplicationScoped
public class ParkingResources {

    @Inject
    private parkingService service;
    @RolesAllowed("ADMIN")
    @Path("create")
    @POST
    public void create(@Valid Parking parking) {service.create(parking);
    }

    @RolesAllowed({"USER","ADMIN"})
    @Path("listAll")
    @GET
    public List<Parking> get_all_parking() {return service.get_all_parking();
    }


}

package smart.parking.cot.Ressources;

import jakarta.annotation.security.RolesAllowed;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import smart.parking.cot.Entity.Reservation;
import smart.parking.cot.Entity.UserDTO;
import smart.parking.cot.security.SecurityService;
import smart.parking.cot.services.ReservationService;

import java.text.ParseException;
import java.util.List;


@Path("reservation")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
@ApplicationScoped
public class ReservationRessource {

    @Inject
    private ReservationService service;
    @Path("create")
    @POST
    public void create(@Valid Reservation reservation) {
        service.create(reservation);
    }

    @Path("list")
    @GET
    @RolesAllowed("ADMIN")
    public List<Reservation> getReservations() {
        return service.getReservation();
    }

    @Path("user/{id}")
    @GET
    public List<Reservation> getUserReservation(@PathParam("id")  String id) {
        return service.getUserReservation(id);
    }



}




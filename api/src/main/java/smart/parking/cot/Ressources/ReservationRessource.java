package smart.parking.cot.Ressources;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import smart.parking.cot.Entity.Reservation;
import smart.parking.cot.Entity.UserDTO;
import smart.parking.cot.security.SecurityService;
import smart.parking.cot.services.ReservationService;

import java.text.ParseException;


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

    @Path("check")
    @POST
    public void check(@Valid String id) throws ParseException {
        service.check_reservation(id);
    }


}




package smart.parking.cot.Ressources;

import jakarta.annotation.security.PermitAll;
import jakarta.annotation.security.RolesAllowed;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.nosql.mapping.Database;
import jakarta.nosql.mapping.DatabaseType;
import jakarta.validation.Valid;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import smart.parking.cot.Entity.Reservation;
import smart.parking.cot.Repository.ReservationRepository;
import smart.parking.cot.services.ReservationService;

import java.text.ParseException;
import java.util.List;
import java.util.Map;


@Path("reservation")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
@ApplicationScoped
public class ReservationRessource {
    @Inject
    private ReservationService service;

    @Inject
    @Database(DatabaseType.DOCUMENT)
    private ReservationRepository repository;
    @Path("create")
    @RolesAllowed({"USER","ADMIN"})
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
    @Path("total")
    @GET
    @RolesAllowed("ADMIN")
    public int TotalReservations() {
        return service.TotalReservations();
    }

    @Path("totals/{month}")
    @GET
    @RolesAllowed("ADMIN")
    public int monthlyReservation(@PathParam("month")int month) {
        return service.monthlyReservation(month);
    }


    @Path("id/{id}")
    @GET
    @PermitAll
    public Reservation FindByID(@PathParam("id")String id) {
        return repository.findById(id).orElseThrow();
    }



    @Path("totals/week")
    @GET
    @RolesAllowed("ADMIN")
    public int weeklyReservation() {
        return service.weeklyReservation();
    }

    @Path("user/{id}")
    @GET
    @RolesAllowed({"ADMIN","USER"})
    public List<Reservation> getUserReservation(@PathParam("id")  String id) {
        return service.getUserReservation(id);
    }

    @Path("delt/{id}")
    @DELETE
    @RolesAllowed("ADMIN")
    public void delete(@PathParam("id") String id) {
        service.delete(id);
    }

    @Path("range/{start_date}/{end_date}")
    @GET
    @RolesAllowed("ADMIN")
    public int range_reservation(@PathParam("start_date") String start_date , @PathParam("end_date") String end_date) throws ParseException {
        return service.range_reservation(start_date,end_date);
    }

    @Path("range77/{start_date}/{end_date}")
    @GET
    @RolesAllowed("ADMIN")
    public Map<String, String> range(@PathParam("start_date") String start_date , @PathParam("end_date") String end_date) throws ParseException {
        return service.range77(start_date,end_date);
    }

    @Path("prices")
    @GET
    @RolesAllowed("ADMIN")
    public float total_prices(){
        return service.total_reservation_prices();    }

}




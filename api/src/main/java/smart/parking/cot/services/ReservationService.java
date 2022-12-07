package smart.parking.cot.services;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.nosql.mapping.Database;
import jakarta.nosql.mapping.DatabaseType;
import smart.parking.cot.Entity.Reservation;
import smart.parking.cot.Repository.ReservationRepository;
import smart.parking.cot.security.UserAlreadyExistException;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Optional;
import java.util.TimeZone;

@ApplicationScoped
public class ReservationService {

    @Inject
    @Database(DatabaseType.DOCUMENT)
    private ReservationRepository repository;

    public void create(Reservation reservation) {
        if (repository.existsById(reservation.getId())) {
            throw new UserAlreadyExistException("There is an reservation with this id: " + reservation.getId());
        } else {
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
            LocalDateTime now = LocalDateTime.now();
            Integer validity = 2;
            Reservation reservation1 = Reservation.builder()
                    .WithId("01")
                    .WithStartDate(reservation.getStart_date())
                    .WithEndDate(reservation.getEnd_date())
                    .WithReservationDate(dtf.format(now))
                    .WithValidity(String.valueOf(validity))
                    .build();
            repository.save(reservation1);
        }
    }

    public boolean check_reservation(String id) throws ParseException {
        if (repository.existsById(id)) {
            Optional<Reservation> res = repository.findById(id);
            Date now = new Date(); // This object contains the current date value

            SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

            Integer validity = Integer.valueOf(res.get().getValidity());
            String time1=res.get().getStart_date();
            String time2=res.get().getEnd_date();

            SimpleDateFormat timeFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            Date date1 = timeFormat.parse(time1);
            Date date2 = timeFormat.parse(time2);
       if (now.compareTo(date1) > 0 &  now.compareTo(date2) <0 ) {
return true;
       }
       else {
           return false;
       }
        } else {
            return false;

        }
    }


}

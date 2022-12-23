package smart.parking.cot.services;

import com.itextpdf.io.font.constants.StandardFonts;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfPage;
import com.itextpdf.kernel.pdf.PdfReader;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.kernel.pdf.canvas.PdfCanvas;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import jakarta.nosql.mapping.Database;
import jakarta.nosql.mapping.DatabaseType;
import smart.parking.cot.Entity.Reservation;
import smart.parking.cot.Entity.User;
import smart.parking.cot.Repository.ReservationRepository;
import smart.parking.cot.Repository.UserRepository;
import smart.parking.cot.security.UserAlreadyExistException;
import java.io.File;
import java.io.IOException;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
@ApplicationScoped
public class ReservationService {

    @Inject
    @Database(DatabaseType.DOCUMENT)
    private ReservationRepository repository;


    @Inject
    @Database(DatabaseType.DOCUMENT)
    private UserRepository repository_user;


    public void create(Reservation reservation) {
        if (repository.existsById(reservation.getId())) {
            throw new UserAlreadyExistException("There is an reservation with this id: " + reservation.getId());
        } else {
            java.util.Date date = new java.util.Date();
            Reservation reservation1 = Reservation.builder()
                    .WithUserId(reservation.getUser_id())
                    .WithStartDate(reservation.getStart_date())
                    .WithEndDate(reservation.getEnd_date())
                    .WithSelectedSpot(reservation.getSelectedSpot())
                    .WithPrice(reservation.getPrice())
                    .WithId(reservation.getId())
                    .WithReservationDate(date)
                    .build();
            repository.save(reservation1);
            Optional<User> user_class = repository_user.findById(reservation.getUser_id());
            try (PdfReader reader = new PdfReader( "C:\\Users\\Lenovo\\Desktop\\INDP3\\P2\\Projet Kaaniche\\smart_parking_using_cot\\api\\src\\main\\webapp\\WEB-INF\\template.pdf" );
                 PdfWriter writer = new PdfWriter( "C:\\Users\\Lenovo\\Desktop\\INDP3\\P2\\Projet Kaaniche\\smart_parking_using_cot\\api\\src\\main\\webapp\\WEB-INF\\Invoice.pdf");
                 PdfDocument document = new PdfDocument( reader, writer ) ) {

                PdfPage page = document.getPage( 1 );
                PdfCanvas canvas = new PdfCanvas( page );
                PdfFont helveticaFont = PdfFontFactory.createFont(StandardFonts.HELVETICA);
                PdfFont helveticaBoldFont = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);

                canvas.setFontAndSize( helveticaFont, 8 );
                canvas.beginText();

                canvas.setTextMatrix(492F, 701.5F);
                canvas.showText(reservation.getId());

                DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
                LocalDateTime now = LocalDateTime.now();
                canvas.setTextMatrix(462F, 682F);
                canvas.showText(dtf.format(now));

                canvas.setFontAndSize( helveticaBoldFont, 12 );
                canvas.setTextMatrix(72.5F, 597F);
                canvas.showText(user_class.get().getFull_name());

                canvas.setFontAndSize( helveticaFont, 9 );
                canvas.setTextMatrix( 79, 533 );
                canvas.showText("Reservation");

                canvas.setTextMatrix( 160, 533 );
                SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy'T'HH:mm:ss");
                String start_date = sdf.format(reservation.getStart_date());
                canvas.showText(start_date);

                canvas.setTextMatrix( 300, 533 );
                String end_date = sdf.format(reservation.getEnd_date());
                canvas.showText(end_date);

                canvas.setTextMatrix( 398, 533 );
                canvas.showText(reservation.getPrice()+ " TND");

                canvas.setTextMatrix( 490, 498 );
                canvas.showText(reservation.getPrice()*0.19 + " TND");

                canvas.setFontAndSize( helveticaBoldFont, 9 );
                canvas.setTextMatrix( 490, 462 );
                canvas.showText(reservation.getPrice()*1.19 + " TND");
                canvas.endText();





            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            String to=reservation.getUser_id();
            final String user="contact@smart-parking.me";
            final String password="MedMed123@";

            Properties properties = System.getProperties();
            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.starttls.enable", "true");
            properties.put("mail.smtp.host", "mail.privateemail.com");
            properties.put("mail.smtp.port", "587");


            Session session = Session.getInstance(properties,
                    new jakarta.mail.Authenticator() {
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(user,password);    }   });

            try{
                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(user));
                message.addRecipient(Message.RecipientType.TO,new InternetAddress(to));
                message.setSubject("Invoice -- Smart Parking");

                BodyPart messageBodyPart1 = new MimeBodyPart();
                messageBodyPart1.setText("Thank you for your order");



                String filename = "Invoice.pdf";//change accordingly

                MimeBodyPart attachmentPart = new MimeBodyPart();
                attachmentPart.attachFile(new File("C:/Users/Lenovo/Desktop/INDP3/P2/Projet Kaaniche/smart_parking_using_cot/api/src/main/webapp/WEB-INF/Invoice.pdf"));
                attachmentPart.setFileName("Invoice.pdf");

                Multipart multipart = new MimeMultipart();
                multipart.addBodyPart(messageBodyPart1);
                multipart.addBodyPart(attachmentPart);

                message.setContent(multipart );

                Transport.send(message);
                System.out.println("message sent....");

            }catch (MessagingException | IOException ex) {ex.printStackTrace();}
        }
    }


    public List<Reservation> getReservation() {
        return repository.findAll();
    }
    public int  TotalReservations() {
        return repository.findAll().size();
    }


    public int monthlyReservation(int month) {
        List <Reservation> lista = repository.findAll();
        List<Reservation> lista1 = new ArrayList<>();
        for (int i = 0; i < lista.size(); i++) {
            System.out.println( lista.get(i));
            Reservation reser = lista.get(i);



            Date end_date = lista.get(i).getEnd_date();
            Date start_date = lista.get(i).getStart_date();
            Calendar s = Calendar.getInstance();
            Calendar e = Calendar.getInstance();
             s.setTime(start_date);
            System.out.println(start_date + "startdate"+s +"clendar");
            System.out.println("month");
            System.out.println( s.get(Calendar.MONTH)+1);
            System.out.println(s.get(Calendar.MONTH) == month-1);
            if (s.get(Calendar.MONTH) == month-1 )
            {
                System.out.println( "if is ok");
                lista1.add(reser);


            }
        }   System.out.println(lista1);
        System.out.println(lista1.size());
            return lista1.size();

        }

    public int weeklyReservation() {
        List<Reservation> lista = repository.findAll();
        List<Reservation> lis = new ArrayList<>();
        for (int i = 0; i < lista.size(); i++) {
            Reservation reser = lista.get(i);
            Date date = lista.get(i).getStart_date();
            Calendar c1 = Calendar.getInstance();
            Integer year1 = c1.get(c1.YEAR);
            Integer week1 = c1.get(c1.WEEK_OF_YEAR);
            Calendar c = Calendar.getInstance();
            c.setTime(date);
            Integer year2 = c.get(c.YEAR);
            Integer week2 = c.get(c.WEEK_OF_YEAR);
            System.out.println(year1+ " year1");
            System.out.println(year2 + " year2");
            System.out.println(week1+ " week1");
            System.out.println(week2 + " week2");

            if ( week1 == week2) {
                    System.out.println("if is ok");
                    lis.add(reser);

            }


        }    System.out.println(lis);
        System.out.println(lis.size());
        return lis.size();
    }


    public List<Reservation> getUserReservation(String id) {
        return repository.findByUser_id(id);
    }

  public boolean check_reservation(String id){
      System.out.println("hello");
        if (repository.existsById(id)) {
            Optional<Reservation> res = repository.findById(id);
            System.out.println("hello");
            Date now = new Date(); // This object contains the current date value
            Date end_date = res.get().getEnd_date();
            Date start_date = res.get().getStart_date();
            System.out.println("hello");
            if (now.compareTo(end_date)<0 & now.compareTo(start_date)>0) {
                return true;
            }
            return false;
        }
      return false;

    }


    public void delete(String id) {

        //Optional<Reservation> res = repository.findById(id);
        repository.deleteById(id);

    }


}

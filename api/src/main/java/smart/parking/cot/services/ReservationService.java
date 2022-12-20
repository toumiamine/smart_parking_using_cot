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
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
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


}

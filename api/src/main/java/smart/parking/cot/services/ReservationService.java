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

import java.text.DateFormat;
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
                    .WithSelectedSpot(reservation.getSelectedSpot())
                    .WithPrice(reservation.getPrice())
                    .WithId(reservation.getId())
                    .WithReservationDate(date)
                    .build();
            repository.save(reservation1);
            Optional<User> user_class = repository_user.findById(reservation.getUser_id());
            try (PdfReader reader = new PdfReader("C:\\Users\\Lenovo\\Desktop\\INDP3\\P2\\Projet Kaaniche\\smart_parking_using_cot\\api\\src\\main\\webapp\\WEB-INF\\template.pdf");
                 PdfWriter writer = new PdfWriter("C:\\Users\\Lenovo\\Desktop\\INDP3\\P2\\Projet Kaaniche\\smart_parking_using_cot\\api\\src\\main\\webapp\\WEB-INF\\Invoice.pdf");
                 PdfDocument document = new PdfDocument(reader, writer)) {

                PdfPage page = document.getPage(1);
                PdfCanvas canvas = new PdfCanvas(page);
                PdfFont helveticaFont = PdfFontFactory.createFont(StandardFonts.HELVETICA);
                PdfFont helveticaBoldFont = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);

                canvas.setFontAndSize(helveticaFont, 8);
                canvas.beginText();

                canvas.setTextMatrix(492F, 701.5F);
                canvas.showText(reservation.getId());
                DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
                LocalDateTime now = LocalDateTime.now();
                canvas.setTextMatrix(462F, 682F);
                canvas.showText(dtf.format(now));

                canvas.setFontAndSize(helveticaBoldFont, 12);
                canvas.setTextMatrix(72.5F, 597F);
                canvas.showText(user_class.get().getFull_name());

                canvas.setFontAndSize(helveticaFont, 9);
                canvas.setTextMatrix(79, 533);
                canvas.showText("Reservation");

                canvas.setTextMatrix(160, 533);
                SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy'T'HH:mm:ss");
                String start_date = sdf.format(reservation.getStart_date());
                canvas.showText(start_date);

                canvas.setTextMatrix(300, 533);
                String end_date = sdf.format(reservation.getEnd_date());
                canvas.showText(end_date);

                canvas.setTextMatrix(398, 533);
                canvas.showText(reservation.getPrice() + " TND");

                canvas.setTextMatrix(490, 498);
                canvas.showText(reservation.getPrice() * 0.19 + " TND");

                canvas.setFontAndSize(helveticaBoldFont, 9);
                canvas.setTextMatrix(490, 462);
                canvas.showText(reservation.getPrice() * 1.19 + " TND");
                canvas.endText();


            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            String to = reservation.getUser_id();
            final String user = "contact@smart-parking.me";
            final String password = "MedMed123@";

            Properties properties = System.getProperties();
            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.starttls.enable", "true");
            properties.put("mail.smtp.host", "mail.privateemail.com");
            properties.put("mail.smtp.port", "587");


            Session session = Session.getInstance(properties,
                    new jakarta.mail.Authenticator() {
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(user, password);
                        }
                    });

            try {
                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(user));
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
                message.setSubject("Invoice -- Smart Parking");


                String filename = "Invoice.pdf";//change accordingly
                DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
                LocalDateTime now = LocalDateTime.now();
                MimeBodyPart attachmentPart = new MimeBodyPart();
                attachmentPart.attachFile(new File("C:/Users/Lenovo/Desktop/INDP3/P2/Projet Kaaniche/smart_parking_using_cot/api/src/main/webapp/WEB-INF/Invoice.pdf"));
                attachmentPart.setFileName("Invoice.pdf");
                BodyPart messageBodyPart = new MimeBodyPart();
                String htmlText = "<html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:v=\"urn:schemas-microsoft-com:vml\" xmlns:o=\"urn:schemas-microsoft-com:office:office\">\n" +
                        "\n" +
                        "<head>\n" +
                        "  <!--[if gte mso 9]>\n" +
                        "<xml>\n" +
                        "  <o:OfficeDocumentSettings>\n" +
                        "    <o:AllowPNG/>\n" +
                        "    <o:PixelsPerInch>96</o:PixelsPerInch>\n" +
                        "  </o:OfficeDocumentSettings>\n" +
                        "</xml>\n" +
                        "<![endif]-->\n" +
                        "  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n" +
                        "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
                        "  <meta name=\"x-apple-disable-message-reformatting\">\n" +
                        "  <!--[if !mso]><!-->\n" +
                        "  <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n" +
                        "  <!--<![endif]-->\n" +
                        "  <title></title>\n" +
                        "\n" +
                        "  <style type=\"text/css\">\n" +
                        "    @media only screen and (min-width: 620px) {\n" +
                        "      .u-row {\n" +
                        "        width: 600px !important;\n" +
                        "      }\n" +
                        "      .u-row .u-col {\n" +
                        "        vertical-align: top;\n" +
                        "      }\n" +
                        "      .u-row .u-col-100 {\n" +
                        "        width: 600px !important;\n" +
                        "      }\n" +
                        "    }\n" +
                        "    \n" +
                        "    @media (max-width: 620px) {\n" +
                        "      .u-row-container {\n" +
                        "        max-width: 100% !important;\n" +
                        "        padding-left: 0px !important;\n" +
                        "        padding-right: 0px !important;\n" +
                        "      }\n" +
                        "      .u-row .u-col {\n" +
                        "        min-width: 320px !important;\n" +
                        "        max-width: 100% !important;\n" +
                        "        display: block !important;\n" +
                        "      }\n" +
                        "      .u-row {\n" +
                        "        width: 100% !important;\n" +
                        "      }\n" +
                        "      .u-col {\n" +
                        "        width: 100% !important;\n" +
                        "      }\n" +
                        "      .u-col>div {\n" +
                        "        margin: 0 auto;\n" +
                        "      }\n" +
                        "    }\n" +
                        "    \n" +
                        "    body {\n" +
                        "      margin: 0;\n" +
                        "      padding: 0;\n" +
                        "    }\n" +
                        "    \n" +
                        "    table,\n" +
                        "    tr,\n" +
                        "    td {\n" +
                        "      vertical-align: top;\n" +
                        "      border-collapse: collapse;\n" +
                        "    }\n" +
                        "    \n" +
                        "    p {\n" +
                        "      margin: 0;\n" +
                        "    }\n" +
                        "    \n" +
                        "    .ie-container table,\n" +
                        "    .mso-container table {\n" +
                        "      table-layout: fixed;\n" +
                        "    }\n" +
                        "    \n" +
                        "    * {\n" +
                        "      line-height: inherit;\n" +
                        "    }\n" +
                        "    \n" +
                        "    a[x-apple-data-detectors='true'] {\n" +
                        "      color: inherit !important;\n" +
                        "      text-decoration: none !important;\n" +
                        "    }\n" +
                        "    \n" +
                        "    table,\n" +
                        "    td {\n" +
                        "      color: #000000;\n" +
                        "    }\n" +
                        "    \n" +
                        "    #u_body a {\n" +
                        "      color: #0000ee;\n" +
                        "      text-decoration: underline;\n" +
                        "    }\n" +
                        "  </style>\n" +
                        "\n" +
                        "\n" +
                        "\n" +
                        "  <!--[if !mso]><!-->\n" +
                        "  <link href=\"https://fonts.googleapis.com/css?family=Cabin:400,700\" rel=\"stylesheet\" type=\"text/css\">\n" +
                        "  <!--<![endif]-->\n" +
                        "\n" +
                        "</head>\n" +
                        "\n" +
                        "<body class=\"clean-body u_body\" style=\"margin: 0;padding: 0;-webkit-text-size-adjust: 100%;background-color: #f9f9f9;color: #000000\">\n" +
                        "  <!--[if IE]><div class=\"ie-container\"><![endif]-->\n" +
                        "  <!--[if mso]><div class=\"mso-container\"><![endif]-->\n" +
                        "  <table id=\"u_body\" style=\"border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;min-width: 320px;Margin: 0 auto;background-color: #f9f9f9;width:100%\" cellpadding=\"0\" cellspacing=\"0\">\n" +
                        "    <tbody>\n" +
                        "      <tr style=\"vertical-align: top\">\n" +
                        "        <td style=\"word-break: break-word;border-collapse: collapse !important;vertical-align: top\">\n" +
                        "          <!--[if (mso)|(IE)]><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr><td align=\"center\" style=\"background-color: #f9f9f9;\"><![endif]-->\n" +
                        "\n" +
                        "\n" +
                        "          <div class=\"u-row-container\" style=\"padding: 0px;background-color: transparent\">\n" +
                        "            <div class=\"u-row\" style=\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: #ffffff;\">\n" +
                        "              <div style=\"border-collapse: collapse;display: table;width: 100%;height: 100%;background-color: transparent;\">\n" +
                        "                <!--[if (mso)|(IE)]><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr><td style=\"padding: 0px;background-color: transparent;\" align=\"center\"><table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"width:600px;\"><tr style=\"background-color: #ffffff;\"><![endif]-->\n" +
                        "\n" +
                        "                <!--[if (mso)|(IE)]><td align=\"center\" width=\"600\" style=\"width: 600px;padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\" valign=\"top\"><![endif]-->\n" +
                        "                <div class=\"u-col u-col-100\" style=\"max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;\">\n" +
                        "                  <div style=\"height: 100%;width: 100% !important;\">\n" +
                        "                    <!--[if (!mso)&(!IE)]><!-->\n" +
                        "                    <div style=\"height: 100%; padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\">\n" +
                        "                      <!--<![endif]-->\n" +
                        "\n" +
                        "                      <table style=\"font-family:'Cabin',sans-serif;\" role=\"presentation\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\">\n" +
                        "                        <tbody>\n" +
                        "                          <tr>\n" +
                        "                            <td style=\"overflow-wrap:break-word;word-break:break-word;padding:20px;font-family:'Cabin',sans-serif;\" align=\"left\">\n" +
                        "\n" +
                        "                              <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">\n" +
                        "                                <tr>\n" +
                        "                                  <td style=\"padding-right: 0px;padding-left: 0px;\" align=\"center\">\n" +
                        "\n" +
                        "                                    <img align=\"center\" border=\"0\" src=\"https://assets.unlayer.com/projects/123771/1671830673560-logo.png\" alt=\"Image\" title=\"Image\" style=\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 13%;max-width: 72.8px;\"\n" +
                        "                                      width=\"72.8\" />\n" +
                        "\n" +
                        "                                  </td>\n" +
                        "                                </tr>\n" +
                        "                              </table>\n" +
                        "\n" +
                        "                            </td>\n" +
                        "                          </tr>\n" +
                        "                        </tbody>\n" +
                        "                      </table>\n" +
                        "\n" +
                        "                      <!--[if (!mso)&(!IE)]><!-->\n" +
                        "                    </div>\n" +
                        "                    <!--<![endif]-->\n" +
                        "                  </div>\n" +
                        "                </div>\n" +
                        "                <!--[if (mso)|(IE)]></td><![endif]-->\n" +
                        "                <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\n" +
                        "              </div>\n" +
                        "            </div>\n" +
                        "          </div>\n" +
                        "\n" +
                        "\n" +
                        "\n" +
                        "          <div class=\"u-row-container\" style=\"padding: 0px;background-color: transparent\">\n" +
                        "            <div class=\"u-row\" style=\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: #34d186;\">\n" +
                        "              <div style=\"border-collapse: collapse;display: table;width: 100%;height: 100%;background-color: transparent;\">\n" +
                        "                <!--[if (mso)|(IE)]><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr><td style=\"padding: 0px;background-color: transparent;\" align=\"center\"><table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"width:600px;\"><tr style=\"background-color: #34d186;\"><![endif]-->\n" +
                        "\n" +
                        "                <!--[if (mso)|(IE)]><td align=\"center\" width=\"600\" style=\"width: 600px;padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\" valign=\"top\"><![endif]-->\n" +
                        "                <div class=\"u-col u-col-100\" style=\"max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;\">\n" +
                        "                  <div style=\"height: 100%;width: 100% !important;\">\n" +
                        "                    <!--[if (!mso)&(!IE)]><!-->\n" +
                        "                    <div style=\"height: 100%; padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\">\n" +
                        "                      <!--<![endif]-->\n" +
                        "\n" +
                        "                      <table style=\"font-family:'Cabin',sans-serif;\" role=\"presentation\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\">\n" +
                        "                        <tbody>\n" +
                        "                          <tr>\n" +
                        "                            <td style=\"overflow-wrap:break-word;word-break:break-word;padding:40px 10px 10px;font-family:'Cabin',sans-serif;\" align=\"left\">\n" +
                        "\n" +
                        "                              <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">\n" +
                        "                                <tr>\n" +
                        "                                  <td style=\"padding-right: 0px;padding-left: 0px;\" align=\"center\">\n" +
                        "\n" +
                        "                                    <img align=\"center\" border=\"0\" src=\"https://cdn.templates.unlayer.com/assets/1597218650916-xxxxc.png\" alt=\"Image\" title=\"Image\" style=\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 26%;max-width: 150.8px;\"\n" +
                        "                                      width=\"150.8\" />\n" +
                        "\n" +
                        "                                  </td>\n" +
                        "                                </tr>\n" +
                        "                              </table>\n" +
                        "\n" +
                        "                            </td>\n" +
                        "                          </tr>\n" +
                        "                        </tbody>\n" +
                        "                      </table>\n" +
                        "\n" +
                        "                      <table style=\"font-family:'Cabin',sans-serif;\" role=\"presentation\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\">\n" +
                        "                        <tbody>\n" +
                        "                          <tr>\n" +
                        "                            <td style=\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Cabin',sans-serif;\" align=\"left\">\n" +
                        "\n" +
                        "                              <div style=\"color: #e5eaf5; line-height: 140%; text-align: center; word-wrap: break-word;\">\n" +
                        "                                <p style=\"font-size: 14px; line-height: 140%;\"><span style=\"color: #000000; font-size: 14px; line-height: 19.6px;\"><strong>T H A N K S   F O R   Y O U R   O R D E R !</strong></span></p>\n" +
                        "                              </div>\n" +
                        "\n" +
                        "                            </td>\n" +
                        "                          </tr>\n" +
                        "                        </tbody>\n" +
                        "                      </table>\n" +
                        "\n" +
                        "                      <table style=\"font-family:'Cabin',sans-serif;\" role=\"presentation\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\">\n" +
                        "                        <tbody>\n" +
                        "                          <tr>\n" +
                        "                            <td style=\"overflow-wrap:break-word;word-break:break-word;padding:0px 10px 31px;font-family:'Cabin',sans-serif;\" align=\"left\">\n" +
                        "\n" +
                        "                              <div style=\"color: #e5eaf5; line-height: 140%; text-align: center; word-wrap: break-word;\">\n" +
                        "                                <p style=\"font-size: 14px; line-height: 140%;\"><span style=\"font-size: 28px; line-height: 39.2px; color: #000000;\"><strong><span style=\"line-height: 39.2px; font-size: 28px;\">HERE'S YOUR INVOICE</span></strong>\n" +
                        "                                  </span>\n" +
                        "                                </p>\n" +
                        "                              </div>\n" +
                        "\n" +
                        "                            </td>\n" +
                        "                          </tr>\n" +
                        "                        </tbody>\n" +
                        "                      </table>\n" +
                        "\n" +
                        "                      <!--[if (!mso)&(!IE)]><!-->\n" +
                        "                    </div>\n" +
                        "                    <!--<![endif]-->\n" +
                        "                  </div>\n" +
                        "                </div>\n" +
                        "                <!--[if (mso)|(IE)]></td><![endif]-->\n" +
                        "                <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\n" +
                        "              </div>\n" +
                        "            </div>\n" +
                        "          </div>\n" +
                        "\n" +
                        "\n" +
                        "\n" +
                        "          <div class=\"u-row-container\" style=\"padding: 0px;background-color: transparent\">\n" +
                        "            <div class=\"u-row\" style=\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: #ffffff;\">\n" +
                        "              <div style=\"border-collapse: collapse;display: table;width: 100%;height: 100%;background-color: transparent;\">\n" +
                        "                <!--[if (mso)|(IE)]><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr><td style=\"padding: 0px;background-color: transparent;\" align=\"center\"><table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"width:600px;\"><tr style=\"background-color: #ffffff;\"><![endif]-->\n" +
                        "\n" +
                        "                <!--[if (mso)|(IE)]><td align=\"center\" width=\"600\" style=\"width: 600px;padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\" valign=\"top\"><![endif]-->\n" +
                        "                <div class=\"u-col u-col-100\" style=\"max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;\">\n" +
                        "                  <div style=\"height: 100%;width: 100% !important;\">\n" +
                        "                    <!--[if (!mso)&(!IE)]><!-->\n" +
                        "                    <div style=\"height: 100%; padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\">\n" +
                        "                      <!--<![endif]-->\n" +
                        "\n" +
                        "                      <table style=\"font-family:'Cabin',sans-serif;\" role=\"presentation\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\">\n" +
                        "                        <tbody>\n" +
                        "                          <tr>\n" +
                        "                            <td style=\"overflow-wrap:break-word;word-break:break-word;padding:33px 55px;font-family:'Cabin',sans-serif;\" align=\"left\">\n" +
                        "\n" +
                        "                              <div style=\"line-height: 160%; text-align: center; word-wrap: break-word;\">\n" +
                        "                                <p style=\"font-size: 14px; line-height: 160%;\"><span style=\"font-size: 22px; line-height: 35.2px;\">Hi "+ user_class.get().getFull_name()+", </span></p>\n" +
                        "                                <p style=\"font-size: 14px; line-height: 160%;\"><span style=\"font-size: 18px; line-height: 28.8px;\">I hope you’re well. Please see attached invoice number <strong>"+reservation.getId()+"</strong> for <strong>"+ reservation.getSelectedSpot()+"</strong> Spot, due on <strong>"+dtf.format(now)+"</strong>. Don’t hesitate to reach out if you have any questions.</span></p>\n" +
                        "                              </div>\n" +
                        "\n" +
                        "                            </td>\n" +
                        "                          </tr>\n" +
                        "                        </tbody>\n" +
                        "                      </table>\n" +
                        "\n" +
                        "                      <table style=\"font-family:'Cabin',sans-serif;\" role=\"presentation\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\">\n" +
                        "                        <tbody>\n" +
                        "                          <tr>\n" +
                        "                            <td style=\"overflow-wrap:break-word;word-break:break-word;padding:33px 55px 60px;font-family:'Cabin',sans-serif;\" align=\"left\">\n" +
                        "\n" +
                        "                              <div style=\"line-height: 160%; text-align: center; word-wrap: break-word;\">\n" +
                        "                                <p style=\"line-height: 160%; font-size: 14px;\"><span style=\"font-size: 18px; line-height: 28.8px;\">Thanks,</span></p>\n" +
                        "                                <p style=\"line-height: 160%; font-size: 14px;\"><span style=\"font-size: 18px; line-height: 28.8px;\">The Company Team</span></p>\n" +
                        "                              </div>\n" +
                        "\n" +
                        "                            </td>\n" +
                        "                          </tr>\n" +
                        "                        </tbody>\n" +
                        "                      </table>\n" +
                        "\n" +
                        "                      <!--[if (!mso)&(!IE)]><!-->\n" +
                        "                    </div>\n" +
                        "                    <!--<![endif]-->\n" +
                        "                  </div>\n" +
                        "                </div>\n" +
                        "                <!--[if (mso)|(IE)]></td><![endif]-->\n" +
                        "                <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\n" +
                        "              </div>\n" +
                        "            </div>\n" +
                        "          </div>\n" +
                        "\n" +
                        "\n" +
                        "\n" +
                        "          <div class=\"u-row-container\" style=\"padding: 0px;background-color: transparent\">\n" +
                        "            <div class=\"u-row\" style=\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: #e5eaf5;\">\n" +
                        "              <div style=\"border-collapse: collapse;display: table;width: 100%;height: 100%;background-color: transparent;\">\n" +
                        "                <!--[if (mso)|(IE)]><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr><td style=\"padding: 0px;background-color: transparent;\" align=\"center\"><table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"width:600px;\"><tr style=\"background-color: #e5eaf5;\"><![endif]-->\n" +
                        "\n" +
                        "                <!--[if (mso)|(IE)]><td align=\"center\" width=\"600\" style=\"width: 600px;padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\" valign=\"top\"><![endif]-->\n" +
                        "                <div class=\"u-col u-col-100\" style=\"max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;\">\n" +
                        "                  <div style=\"height: 100%;width: 100% !important;\">\n" +
                        "                    <!--[if (!mso)&(!IE)]><!-->\n" +
                        "                    <div style=\"height: 100%; padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\">\n" +
                        "                      <!--<![endif]-->\n" +
                        "\n" +
                        "                      <table style=\"font-family:'Cabin',sans-serif;\" role=\"presentation\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\">\n" +
                        "                        <tbody>\n" +
                        "                          <tr>\n" +
                        "                            <td style=\"overflow-wrap:break-word;word-break:break-word;padding:41px 55px 18px;font-family:'Cabin',sans-serif;\" align=\"left\">\n" +
                        "\n" +
                        "                              <div style=\"color: #003399; line-height: 160%; text-align: center; word-wrap: break-word;\">\n" +
                        "                                <p style=\"font-size: 14px; line-height: 160%;\"><span style=\"font-size: 20px; line-height: 32px;\"><strong>Get in touch</strong></span></p>\n" +
                        "                                <p style=\"font-size: 14px; line-height: 160%;\"><span style=\"font-size: 16px; line-height: 25.6px; color: #000000;\">+216 71 123 456</span></p>\n" +
                        "                                <p style=\"font-size: 14px; line-height: 160%;\"><span style=\"font-size: 16px; line-height: 25.6px; color: #000000;\">contact@smart-parking.me</span></p>\n" +
                        "                              </div>\n" +
                        "\n" +
                        "                            </td>\n" +
                        "                          </tr>\n" +
                        "                        </tbody>\n" +
                        "                      </table>\n" +
                        "\n" +
                        "                      <table style=\"font-family:'Cabin',sans-serif;\" role=\"presentation\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\">\n" +
                        "                        <tbody>\n" +
                        "                          <tr>\n" +
                        "                            <td style=\"overflow-wrap:break-word;word-break:break-word;padding:10px 10px 33px;font-family:'Cabin',sans-serif;\" align=\"left\">\n" +
                        "\n" +
                        "                              <div align=\"center\">\n" +
                        "                                <div style=\"display: table; max-width:244px;\">\n" +
                        "                                  <!--[if (mso)|(IE)]><table width=\"244\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr><td style=\"border-collapse:collapse;\" align=\"center\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"border-collapse:collapse; mso-table-lspace: 0pt;mso-table-rspace: 0pt; width:244px;\"><tr><![endif]-->\n" +
                        "\n" +
                        "\n" +
                        "                                  <!--[if (mso)|(IE)]><td width=\"32\" style=\"width:32px; padding-right: 17px;\" valign=\"top\"><![endif]-->\n" +
                        "                                  <table align=\"left\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"32\" height=\"32\" style=\"width: 32px !important;height: 32px !important;display: inline-block;border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;margin-right: 17px\">\n" +
                        "                                    <tbody>\n" +
                        "                                      <tr style=\"vertical-align: top\">\n" +
                        "                                        <td align=\"left\" valign=\"middle\" style=\"word-break: break-word;border-collapse: collapse !important;vertical-align: top\">\n" +
                        "                                          <a href=\"https://facebook.com/\" title=\"Facebook\" target=\"_blank\">\n" +
                        "                                            <img src=\"https://cdn.tools.unlayer.com/social/icons/circle-black/facebook.png\" alt=\"Facebook\" title=\"Facebook\" width=\"32\" style=\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: block !important;border: none;height: auto;float: none;max-width: 32px !important\">\n" +
                        "                                          </a>\n" +
                        "                                        </td>\n" +
                        "                                      </tr>\n" +
                        "                                    </tbody>\n" +
                        "                                  </table>\n" +
                        "                                  <!--[if (mso)|(IE)]></td><![endif]-->\n" +
                        "\n" +
                        "                                  <!--[if (mso)|(IE)]><td width=\"32\" style=\"width:32px; padding-right: 17px;\" valign=\"top\"><![endif]-->\n" +
                        "                                  <table align=\"left\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"32\" height=\"32\" style=\"width: 32px !important;height: 32px !important;display: inline-block;border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;margin-right: 17px\">\n" +
                        "                                    <tbody>\n" +
                        "                                      <tr style=\"vertical-align: top\">\n" +
                        "                                        <td align=\"left\" valign=\"middle\" style=\"word-break: break-word;border-collapse: collapse !important;vertical-align: top\">\n" +
                        "                                          <a href=\"https://linkedin.com/\" title=\"LinkedIn\" target=\"_blank\">\n" +
                        "                                            <img src=\"https://cdn.tools.unlayer.com/social/icons/circle-black/linkedin.png\" alt=\"LinkedIn\" title=\"LinkedIn\" width=\"32\" style=\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: block !important;border: none;height: auto;float: none;max-width: 32px !important\">\n" +
                        "                                          </a>\n" +
                        "                                        </td>\n" +
                        "                                      </tr>\n" +
                        "                                    </tbody>\n" +
                        "                                  </table>\n" +
                        "                                  <!--[if (mso)|(IE)]></td><![endif]-->\n" +
                        "\n" +
                        "                                  <!--[if (mso)|(IE)]><td width=\"32\" style=\"width:32px; padding-right: 17px;\" valign=\"top\"><![endif]-->\n" +
                        "                                  <table align=\"left\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"32\" height=\"32\" style=\"width: 32px !important;height: 32px !important;display: inline-block;border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;margin-right: 17px\">\n" +
                        "                                    <tbody>\n" +
                        "                                      <tr style=\"vertical-align: top\">\n" +
                        "                                        <td align=\"left\" valign=\"middle\" style=\"word-break: break-word;border-collapse: collapse !important;vertical-align: top\">\n" +
                        "                                          <a href=\"https://instagram.com/\" title=\"Instagram\" target=\"_blank\">\n" +
                        "                                            <img src=\"https://cdn.tools.unlayer.com/social/icons/circle-black/instagram.png\" alt=\"Instagram\" title=\"Instagram\" width=\"32\" style=\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: block !important;border: none;height: auto;float: none;max-width: 32px !important\">\n" +
                        "                                          </a>\n" +
                        "                                        </td>\n" +
                        "                                      </tr>\n" +
                        "                                    </tbody>\n" +
                        "                                  </table>\n" +
                        "                                  <!--[if (mso)|(IE)]></td><![endif]-->\n" +
                        "\n" +
                        "                                  <!--[if (mso)|(IE)]><td width=\"32\" style=\"width:32px; padding-right: 17px;\" valign=\"top\"><![endif]-->\n" +
                        "                                  <table align=\"left\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"32\" height=\"32\" style=\"width: 32px !important;height: 32px !important;display: inline-block;border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;margin-right: 17px\">\n" +
                        "                                    <tbody>\n" +
                        "                                      <tr style=\"vertical-align: top\">\n" +
                        "                                        <td align=\"left\" valign=\"middle\" style=\"word-break: break-word;border-collapse: collapse !important;vertical-align: top\">\n" +
                        "                                          <a href=\"https://youtube.com/\" title=\"YouTube\" target=\"_blank\">\n" +
                        "                                            <img src=\"https://cdn.tools.unlayer.com/social/icons/circle-black/youtube.png\" alt=\"YouTube\" title=\"YouTube\" width=\"32\" style=\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: block !important;border: none;height: auto;float: none;max-width: 32px !important\">\n" +
                        "                                          </a>\n" +
                        "                                        </td>\n" +
                        "                                      </tr>\n" +
                        "                                    </tbody>\n" +
                        "                                  </table>\n" +
                        "                                  <!--[if (mso)|(IE)]></td><![endif]-->\n" +
                        "\n" +
                        "                                  <!--[if (mso)|(IE)]><td width=\"32\" style=\"width:32px; padding-right: 0px;\" valign=\"top\"><![endif]-->\n" +
                        "                                  <table align=\"left\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"32\" height=\"32\" style=\"width: 32px !important;height: 32px !important;display: inline-block;border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;margin-right: 0px\">\n" +
                        "                                    <tbody>\n" +
                        "                                      <tr style=\"vertical-align: top\">\n" +
                        "                                        <td align=\"left\" valign=\"middle\" style=\"word-break: break-word;border-collapse: collapse !important;vertical-align: top\">\n" +
                        "                                          <a href=\"https://email.com/\" title=\"Email\" target=\"_blank\">\n" +
                        "                                            <img src=\"https://cdn.tools.unlayer.com/social/icons/circle-black/email.png\" alt=\"Email\" title=\"Email\" width=\"32\" style=\"outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: block !important;border: none;height: auto;float: none;max-width: 32px !important\">\n" +
                        "                                          </a>\n" +
                        "                                        </td>\n" +
                        "                                      </tr>\n" +
                        "                                    </tbody>\n" +
                        "                                  </table>\n" +
                        "                                  <!--[if (mso)|(IE)]></td><![endif]-->\n" +
                        "\n" +
                        "\n" +
                        "                                  <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\n" +
                        "                                </div>\n" +
                        "                              </div>\n" +
                        "\n" +
                        "                            </td>\n" +
                        "                          </tr>\n" +
                        "                        </tbody>\n" +
                        "                      </table>\n" +
                        "\n" +
                        "                      <!--[if (!mso)&(!IE)]><!-->\n" +
                        "                    </div>\n" +
                        "                    <!--<![endif]-->\n" +
                        "                  </div>\n" +
                        "                </div>\n" +
                        "                <!--[if (mso)|(IE)]></td><![endif]-->\n" +
                        "                <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\n" +
                        "              </div>\n" +
                        "            </div>\n" +
                        "          </div>\n" +
                        "\n" +
                        "\n" +
                        "\n" +
                        "          <div class=\"u-row-container\" style=\"padding: 0px;background-color: transparent\">\n" +
                        "            <div class=\"u-row\" style=\"Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: #34d186;\">\n" +
                        "              <div style=\"border-collapse: collapse;display: table;width: 100%;height: 100%;background-color: transparent;\">\n" +
                        "                <!--[if (mso)|(IE)]><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr><td style=\"padding: 0px;background-color: transparent;\" align=\"center\"><table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"width:600px;\"><tr style=\"background-color: #34d186;\"><![endif]-->\n" +
                        "\n" +
                        "                <!--[if (mso)|(IE)]><td align=\"center\" width=\"600\" style=\"width: 600px;padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\" valign=\"top\"><![endif]-->\n" +
                        "                <div class=\"u-col u-col-100\" style=\"max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;\">\n" +
                        "                  <div style=\"height: 100%;width: 100% !important;\">\n" +
                        "                    <!--[if (!mso)&(!IE)]><!-->\n" +
                        "                    <div style=\"height: 100%; padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;\">\n" +
                        "                      <!--<![endif]-->\n" +
                        "\n" +
                        "                      <table style=\"font-family:'Cabin',sans-serif;\" role=\"presentation\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" border=\"0\">\n" +
                        "                        <tbody>\n" +
                        "                          <tr>\n" +
                        "                            <td style=\"overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Cabin',sans-serif;\" align=\"left\">\n" +
                        "\n" +
                        "                              <div style=\"color: #fafafa; line-height: 180%; text-align: center; word-wrap: break-word;\">\n" +
                        "                                <p style=\"font-size: 14px; line-height: 180%;\"><span style=\"font-size: 16px; line-height: 28.8px; color: #000000;\">Copyrights © Company All Rights Reserved</span></p>\n" +
                        "                              </div>\n" +
                        "\n" +
                        "                            </td>\n" +
                        "                          </tr>\n" +
                        "                        </tbody>\n" +
                        "                      </table>\n" +
                        "\n" +
                        "                      <!--[if (!mso)&(!IE)]><!-->\n" +
                        "                    </div>\n" +
                        "                    <!--<![endif]-->\n" +
                        "                  </div>\n" +
                        "                </div>\n" +
                        "                <!--[if (mso)|(IE)]></td><![endif]-->\n" +
                        "                <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->\n" +
                        "              </div>\n" +
                        "            </div>\n" +
                        "          </div>\n" +
                        "\n" +
                        "\n" +
                        "          <!--[if (mso)|(IE)]></td></tr></table><![endif]-->\n" +
                        "        </td>\n" +
                        "      </tr>\n" +
                        "    </tbody>\n" +
                        "  </table>\n" +
                        "  <!--[if mso]></div><![endif]-->\n" +
                        "  <!--[if IE]></div><![endif]-->\n" +
                        "</body>\n" +
                        "\n" +
                        "</html>";
                messageBodyPart.setContent(htmlText, "text/html");



                Multipart multipart = new MimeMultipart();
                multipart.addBodyPart(messageBodyPart);
                multipart.addBodyPart(attachmentPart);
                message.setContent(multipart );

                Transport.send(message);
                System.out.println("message sent....");

            } catch (MessagingException | IOException ex) {
                ex.printStackTrace();
            }
        }
    }


    public List<Reservation> getReservation() {
        return repository.findAll();
    }

    public int TotalReservations() {
        return repository.findAll().size();
    }


    public int monthlyReservation(int month) {
        List<Reservation> lista = repository.findAll();
        List<Reservation> lista1 = new ArrayList<>();
        for (int i = 0; i < lista.size(); i++) {
            System.out.println(lista.get(i));
            Reservation reser = lista.get(i);


            Date start_date = lista.get(i).getStart_date();
            Calendar s = Calendar.getInstance();

            s.setTime(start_date);
            System.out.println(start_date + "startdate" + s + "clendar");
            System.out.println("month");
            System.out.println(s.get(Calendar.MONTH) + 1);
            System.out.println(s.get(Calendar.MONTH) == month - 1);
            if (s.get(Calendar.MONTH) == month - 1) {
                System.out.println("if is ok");
                lista1.add(reser);


            }
        }
        System.out.println(lista1);
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
            System.out.println(year1 + " year1");
            System.out.println(year2 + " year2");
            System.out.println(week1 + " week1");
            System.out.println(week2 + " week2");

            if (week1 == week2) {
                System.out.println("if is ok");
                lis.add(reser);

            }


        }
        System.out.println(lis);
        System.out.println(lis.size());
        return lis.size();
    }


    public List<Reservation> getUserReservation(String id) {
        return repository.findByUser_id(id);
    }

    public boolean check_reservation(String id) {
        System.out.println("hello");
        if (repository.existsById(id)) {
            Optional<Reservation> res = repository.findById(id);
            System.out.println("hello");
            Date now = new Date(); // This object contains the current date value
            Date end_date = res.get().getEnd_date();
            Date start_date = res.get().getStart_date();
            System.out.println("hello");
            if (now.compareTo(end_date) < 0 & now.compareTo(start_date) > 0) {
                return true;
            }
            return false;
        }
        return false;

    }


    public List<Integer> get_list_monthes(String startDate, String endDate) {
        List<Integer> listMonth = new ArrayList<Integer>();

        String date1 = "2022-01-01";
        String date2 = "2022-11-30";

        DateFormat formater = new SimpleDateFormat("yyyy-MM-dd");

        Calendar beginCalendar = Calendar.getInstance();
        Calendar finishCalendar = Calendar.getInstance();

        try {
            beginCalendar.setTime(formater.parse(date1));
            finishCalendar.setTime(formater.parse(date2));
        } catch (ParseException e) {
            e.printStackTrace();
        }


        while (beginCalendar.before(finishCalendar)) {

            Date date = beginCalendar.getTime();
            Calendar cal4 = Calendar.getInstance();
            cal4.setTime(date);
            System.out.println(  cal4.get(Calendar.MONTH));
            // Add One Month to get next Month
            beginCalendar.add(Calendar.MONTH, 1);
        }
        return listMonth;
    }





    public int range_reservation(String date1_comp, String date2_comp) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String oeStartDateStr = date1_comp;
        //System.out.println("1 ==  "+ oeStartDateStr);
        //String oeEndDateStr = date2_comp;
        //Calendar cal = Calendar.getInstance();
        //Integer year = cal.get(Calendar.YEAR);
        //oeStartDateStr = oeStartDateStr.concat(year.toString());
        //oeEndDateStr = oeEndDateStr.concat(year.toString());

        Date startDate = sdf.parse(date1_comp);
        Date endDate = sdf.parse(date2_comp);
        System.out.println("startDate input =  "+ startDate);
        System.out.println("endDate input =  "+ endDate);


        System.out.println("boucle for ");
        List<Reservation> liste1 = new ArrayList<>();
        List<Reservation> liste = new ArrayList<>();;
        List<Reservation> listRes = repository.findAll();
        for (int i = 0; i < listRes.size(); i++) {
            Reservation reservation = listRes.get(i);
            Date date = reservation.getStart_date();
            //System.out.print("date from DB"+date);


            String currDt = sdf.format(date);
            System.out.println("date li fost  baed mawlet string"+ date);

            if (date.after(startDate) && date.before(endDate)) {
                System.out.println("ok if 1");

                liste.add(reservation);
            }

             if (date.compareTo(endDate) < 0 & date.compareTo(startDate) > 0){
                System.out.println("ok if 2");
                liste1.add(reservation);
            }


            //liste.add(reservation);

            }



            return liste.size();

            }

    public Map<String, String> range77(String date1, String date2) throws ParseException {
        Map<String, String> map= new HashMap<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date startDate = sdf.parse(date1);
        Date endDate = sdf.parse(date2);

        Calendar a = Calendar.getInstance();
        a.setTime(startDate);
        System.out.println(a);
        Calendar b = Calendar.getInstance();
        b.setTime(endDate);
       int begin_month= a.get(Calendar.MONTH);
       System.out.println("begin month =  "+ begin_month);
        int end_month= b.get(Calendar.MONTH);
        System.out.println(" end month  "+  end_month);

        List<Reservation> listRes = repository.findAll();
        for (int j = 0; j < 12; j++) {
            System.out.println("c' est  la valeur de j = " +j );
            if (j >= begin_month  && j <= end_month) {
            List<Reservation> liste3 = new ArrayList<>();
            for (int i = 0; i < listRes.size(); i++) {
                Reservation reservation = listRes.get(i);
                Date date = reservation.getStart_date();
                if (date.after(startDate) && date.before(endDate)) {
                    //liste.add(reservation);
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(date);
                    int month = cal.get(Calendar.MONTH);

                    if (j == month) {
                        System.out.println("j et month equi");

                        liste3.add(reservation);}}
                        if (liste3.size()!=0) {
                            //map. put(String.valueOf(j), String.valueOf(liste3.size()));
                            map. put(String.valueOf(j+1), String.valueOf(liste3.size()));
                        }

            } }

        }
        return map;

        }












    public void delete(String id) {

        //Optional<Reservation> res = repository.findById(id);
        repository.deleteById(id);

    }


}

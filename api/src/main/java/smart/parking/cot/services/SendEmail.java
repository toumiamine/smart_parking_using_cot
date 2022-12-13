package smart.parking.cot.services;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class SendEmail {
    public static void main(String[] args) {
        //provide recipient's email ID
        String to = "mohamedamine.toumi@supcom.tn";
        //provide sender's email ID
        String from = "contact@smart-parking.me";
        //provide Mailtrap's username
        final String username = "imenazzouz";
        //provide Mailtrap's password
        final String password = "MedMed123@";
        //provide Mailtrap's host address
        String host = "mail.privateemail.com";
        //configure Mailtrap's SMTP server details
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", "587");
        //create the Session object
        Session session = Session.getInstance(props,
                new jakarta.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(from, password);
                    }
                });
        try {
            //create a MimeMessage object
            Message message = new MimeMessage(session);
            //set From email field
            message.setFrom(new InternetAddress(from));
            //set To email field
            message.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(to));
            //set email subject field
            message.setSubject("Hello");
            //set the content of the email message
            message.setText("Test test");
            message.setFileName("/WEB-INF/template.pdf");
            //send the email message
            Transport.send(message);
            System.out.println("Email Message Sent Successfully");
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }
}

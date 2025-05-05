
    package in.efficio.utils;

    import java.util.Properties;
    import java.util.logging.Logger;
    import jakarta.mail.Message;
    import jakarta.mail.MessagingException;
    import jakarta.mail.PasswordAuthentication;
    import jakarta.mail.Session;
    import jakarta.mail.Transport;
    import jakarta.mail.internet.InternetAddress;
    import jakarta.mail.internet.MimeMessage;

    public class EmailUtility {
        private static final Logger LOGGER = Logger.getLogger(EmailUtility.class.getName());
        private static final String FROM_EMAIL = "devendragadge80@gmail.com"; // Replace with your email
        private static final String EMAIL_PASSWORD = "ohmssmrlzuzvwsne"; // Replace with your app-specific password
        private static final String SMTP_HOST = "smtp.gmail.com";
        private static final String SMTP_PORT = "587";

        public static void sendEmail(String toEmail, String subject, String content) throws MessagingException {
            LOGGER.info("Attempting to send email to: " + toEmail);
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);

            Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, EMAIL_PASSWORD);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(content);

            LOGGER.info("Sending email...");
            Transport.send(message);
            LOGGER.info("Email sent successfully");
        }
    }
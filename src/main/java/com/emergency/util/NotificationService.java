package com.emergency.util;

// We will no longer import the conflicting Message classes directly
import com.twilio.Twilio;
import com.twilio.type.PhoneNumber;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.services.gmail.Gmail;

import jakarta.activation.DataHandler;
import jakarta.activation.DataSource;
import jakarta.activation.FileDataSource;
import jakarta.mail.Session;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import org.apache.commons.codec.binary.Base64;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.Properties;

public class NotificationService {

    // --- TWILIO SMS CONSTANTS ---
    public static final String ACCOUNT_SID = System.getenv("TWILIO_SID");
    public static final String AUTH_TOKEN = System.getenv("TWILIO_TOKEN");
    public static final String TWILIO_NUMBER = System.getenv("TWILIO_NUMBER");

    // --- OAUTH 2.0 CONSTANTS ---
    private static final String APPLICATION_NAME = "Emergency Alert System";
    private static final JsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();
    private static final String CLIENT_ID = System.getenv("GMAIL_CLIENT_ID");
    private static final String CLIENT_SECRET = System.getenv("GMAIL_CLIENT_SECRET");

    public void sendSms(String to, String body) {
        try {
            Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
            
            // CORRECTED: Using the fully qualified name for Twilio's Message class
            com.twilio.rest.api.v2010.account.Message message = 
                com.twilio.rest.api.v2010.account.Message.creator(
                    new PhoneNumber(to), 
                    new PhoneNumber(TWILIO_NUMBER), 
                    body
                ).create();

            System.out.println("Message sent! SID: " + message.getSid());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void sendEmailWithAttachment(String to, String subject, String body, String attachmentPath, String fromUserEmail, String refreshToken) {
        if (refreshToken == null || refreshToken.isEmpty()) {
            System.err.println("Email skipped: User has not authorized their Google account.");
            return;
        }
        try {
            final NetHttpTransport HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
            Credential credential = new GoogleCredential.Builder()
                .setTransport(HTTP_TRANSPORT).setJsonFactory(JSON_FACTORY).setClientSecrets(CLIENT_ID, CLIENT_SECRET).build();
            credential.setRefreshToken(refreshToken);

            Gmail service = new Gmail.Builder(HTTP_TRANSPORT, JSON_FACTORY, credential).setApplicationName(APPLICATION_NAME).build();
            
            Properties props = new Properties();
            Session session = Session.getDefaultInstance(props, null);
            MimeMessage email = new MimeMessage(session);
            email.setFrom(new InternetAddress(fromUserEmail));
            email.addRecipient(jakarta.mail.Message.RecipientType.TO, new InternetAddress(to));
            email.setSubject(subject);
            
            MimeMultipart multipart = new MimeMultipart();
            MimeBodyPart textPart = new MimeBodyPart();
            textPart.setText(body);
            multipart.addBodyPart(textPart);

            if (attachmentPath != null && !attachmentPath.isEmpty()) {
                MimeBodyPart filePart = new MimeBodyPart();
                DataSource source = new FileDataSource(new File(attachmentPath));
                filePart.setDataHandler(new DataHandler(source));
                filePart.setFileName(new File(attachmentPath).getName());
                multipart.addBodyPart(filePart);
            }
            email.setContent(multipart);

            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            email.writeTo(buffer);
            byte[] rawMessageBytes = buffer.toByteArray();
            String encodedEmail = Base64.encodeBase64URLSafeString(rawMessageBytes);

            // CORRECTED: Using the fully qualified name for Gmail's Message class
            com.google.api.services.gmail.model.Message message = 
                new com.google.api.services.gmail.model.Message();
            
            message.setRaw(encodedEmail);
            service.users().messages().send("me", message).execute();
            System.out.println("Email sent successfully via Gmail API from " + fromUserEmail);
        } catch (Exception e) {
            System.err.println("--- GMAIL API SENDING FAILED ---");
            e.printStackTrace();
        }
    }
}
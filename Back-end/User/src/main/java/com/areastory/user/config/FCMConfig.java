package com.areastory.user.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.apache.commons.io.FileUtils;
import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

@Configuration
public class FCMConfig {
    @Value("classpath:serviceAccountKey.json")
    private Resource resource;

    @PostConstruct
    public void initFirebase() {
        FileInputStream serviceAccount;
        try {
            InputStream inputStream = resource.getInputStream();
            File serviceAccountKey = File.createTempFile("serviceAccountKey", ".json");
            try {
                FileUtils.copyInputStreamToFile(inputStream, serviceAccountKey);
            } finally {
                IOUtils.closeQuietly(inputStream);
            }
            serviceAccount = new FileInputStream(serviceAccountKey);
            FirebaseOptions options = new FirebaseOptions.Builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();
            FirebaseApp.initializeApp(options);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}

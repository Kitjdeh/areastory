package com.areastory.user.util;

import com.areastory.user.db.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

@Component
@RequiredArgsConstructor
public class Sha256Util {

    public String sha256(Long userId) throws NoSuchAlgorithmException {
        String input = Long.toString(userId);
        MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
        byte[] hash = messageDigest.digest(input.getBytes(StandardCharsets.UTF_8));
        StringBuilder haxString = new StringBuilder();

        for (byte b : hash) {
            String hax = Integer.toHexString(0xff & b);
            if (hax.length() == 1) {
                haxString.append('0');
            }
            haxString.append(hax);
        }
        return haxString.toString();
    }
}

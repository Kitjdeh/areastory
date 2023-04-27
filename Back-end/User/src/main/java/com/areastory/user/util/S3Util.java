package com.areastory.user.util;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.util.UUID;

@Component
@RequiredArgsConstructor
@Transactional
public class S3Util {

    private final AmazonS3Client amazonS3Client;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    public String saveUploadFile(MultipartFile multipartFile) throws IOException {
        if (multipartFile == null || multipartFile.isEmpty())
            return null;
        ObjectMetadata objectMetadata = new ObjectMetadata();
        objectMetadata.setContentType(multipartFile.getContentType());
        objectMetadata.setContentLength(multipartFile.getSize());

        String originalFilename = multipartFile.getOriginalFilename(); // test.PNG
        int index = originalFilename.lastIndexOf("."); // 4
        String ext = originalFilename.substring(index + 1); // PNG

        // userId (PK)
        String storeFileName = UUID.randomUUID() + "." + ext; // random + . + PNG
        String key = "profile/" + storeFileName; // 파일 위치(test/) + 및 파일명
        System.out.println("storeFileName : " + storeFileName);
        System.out.println("key : " + key);
        try (InputStream inputStream = multipartFile.getInputStream()) {
            amazonS3Client.putObject(new PutObjectRequest(bucket, key, inputStream, objectMetadata)
                    .withCannedAcl(CannedAccessControlList.PublicRead));
        }

        String storeFileUrl = amazonS3Client.getUrl(bucket, key).toString(); // 버켓 url/ + key(파일위치 + 파일명)
        return storeFileUrl;
    }

    public void deleteFile(String source) {
        amazonS3Client.deleteObject(bucket, source.substring(55));
    }
}

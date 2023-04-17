package com.areastory.article.util;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.areastory.article.exception.NoFileException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.time.LocalDate;
import java.util.Objects;
import java.util.Optional;

@Component
@RequiredArgsConstructor
public class FileUtil {
    private final AmazonS3Client amazonS3Client;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    public String upload(MultipartFile multipartFile, String dirName) throws IOException {

        File uploadFile = convert(multipartFile)
                .orElseThrow(() -> new IllegalArgumentException("MultipartFile -> File로 전환이 실패했습니다."));

        return upload(uploadFile, dirName);
    }

    private String upload(File uploadFile, String dirName) {
        String fileName = dirName + "/" + Math.random() * 1000 + "_" + LocalDate.now() + uploadFile.getName();
        String uploadImageUrl = putS3(uploadFile, fileName);
        uploadFile.delete(); // 로컬에 생성된 File 삭제 (MultipartFile -> File 전환 하며 로컬에 파일 생성됨)

        return uploadImageUrl; // 업로드 된 파일의 S3 URL 주소 반환
    }

    public void deleteFile(String fileUrl) {
        try {
            String fileKey = fileUrl.substring(51);
            if (amazonS3Client.doesObjectExist(bucket, fileKey)) {
                amazonS3Client.deleteObject(bucket, fileKey);
            } else {
                throw new NoFileException();
            }
        } catch (Exception e) {
            throw new NoFileException("파일 삭제 불가");
        }
    }
//
//    //String으로 된 url File로 변경
//    public String urlUpload(String url, String dirName) throws IOException {
//
//        URL profile = new URL(url);
//
//        String fileName = dirName + "/" + Math.random() * 1000 + "_" + "socialprofile"; // 이미지 이름
//        String ext = url.substring(url.lastIndexOf('.') + 1); // 확장자
//        BufferedImage img = ImageIO.read(profile);
//        //파일 저장 경로 생성
//        File uploadFile = new File("upload/" + fileName + "." + ext);
//        //파일 저장 경로 없으면 생성
//        if (!uploadFile.exists()) {
//            uploadFile.mkdirs();
//        }
//
//        //이미지를 파일로 업로드
//        ImageIO.write(img, ext, uploadFile);
//
//        //s3에 저장
//        String uploadImageUrl = putS3(uploadFile, fileName);
//        uploadFile.delete(); // 로컬에 생성된 File 삭제 (MultipartFile -> File 전환 하며 로컬에 파일 생성됨)
//        return uploadImageUrl; // 업로드 된 파일의 S3 URL 주소 반환
//
//    }

    private String putS3(File uploadFile, String fileName) {
        amazonS3Client.putObject(new PutObjectRequest(bucket, fileName, uploadFile).withCannedAcl(
                CannedAccessControlList.PublicRead));
        return amazonS3Client.getUrl(bucket, fileName).toString();
    }

    private Optional<File> convert(MultipartFile file) throws IOException {
        File convertFile = new File(Objects.requireNonNull(file.getOriginalFilename()));
        if (convertFile.createNewFile()) {
            try (FileOutputStream fos = new FileOutputStream(convertFile)) {
                fos.write(file.getBytes());
            }
            return Optional.of(convertFile);
        }

        return Optional.empty();
    }


}

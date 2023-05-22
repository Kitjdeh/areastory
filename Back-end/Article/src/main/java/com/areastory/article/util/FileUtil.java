package com.areastory.article.util;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.areastory.article.exception.CustomException;
import com.areastory.article.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.time.LocalDateTime;
import java.util.Iterator;
import java.util.Objects;
import java.util.Optional;

@Component
@RequiredArgsConstructor
public class FileUtil {
    private final AmazonS3Client amazonS3Client;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    public String upload(MultipartFile multipartFile, String dirName) {
        if (multipartFile == null || multipartFile.isEmpty())
            return null;
        File uploadFile = convert(multipartFile)
                .orElseThrow(() -> new CustomException(ErrorCode.FAIL_CONVERT));

        return upload(uploadFile, dirName);
    }

    public String uploadThumbnail(MultipartFile multipartFile, String dirName) {
        if (multipartFile == null || multipartFile.isEmpty())
            return null;
        File uploadFile = compressImage(multipartFile);
        return upload(uploadFile, dirName);
    }

    private String upload(File uploadFile, String dirName) {
        //테스트 때문에 랜덤 값 제거 => 추후 살리기
        String fileName = dirName + "/" + LocalDateTime.now() + uploadFile.getName();

        String uploadImageUrl = putS3(uploadFile, fileName);
        uploadFile.delete(); // 로컬에 생성된 File 삭제 (MultipartFile -> File 전환 하며 로컬에 파일 생성됨)

        return uploadImageUrl; // 업로드 된 파일의 S3 URL 주소 반환
    }

    public void deleteFile(String fileUrl) {
        try {
            String fileKey = fileUrl.substring(50); // 삭제 시 필요한 키
            String objectName = fileUrl.substring(55); // 파일이 존재하는지 확인하기 위한 키
            if (amazonS3Client.doesObjectExist(bucket, objectName)) {
                amazonS3Client.deleteObject(bucket, fileKey);
            }
        } catch (Exception e) {
            throw new CustomException(ErrorCode.FILE_NOT_FOUND);
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

    private Optional<File> convert(MultipartFile file) {
        File convertFile = new File(Objects.requireNonNull(file.getOriginalFilename()));
        try {
            if (convertFile.createNewFile()) {
                try (FileOutputStream fos = new FileOutputStream(convertFile)) {
                    fos.write(file.getBytes());
                }
                return Optional.of(convertFile);
            }
        } catch (IOException e) {
            throw new CustomException(ErrorCode.FAIL_CONVERT);
        }

        return Optional.empty();
    }

    // 파일 용량 축소
    public File compressImage(MultipartFile file) {
        File compressedImageFile = new File(Objects.requireNonNull(file.getOriginalFilename()));
        try (OutputStream os = new FileOutputStream(compressedImageFile)) {


            float quality = 0.1f; //0.1 ~ 1.0까지 압축되는 이미지의 퀄리티를 지정
            //숫자가 낮을수록 화질과 용량이 줄어든다.
            Iterator<ImageWriter> writers = ImageIO.getImageWritersByFormatName("jpg");

            if (!writers.hasNext())
                throw new IllegalStateException("No writers found");

            ImageWriter writer = (ImageWriter) writers.next();
            ImageOutputStream ios = ImageIO.createImageOutputStream(os);
            writer.setOutput(ios);

            ImageWriteParam param = writer.getDefaultWriteParam();

            param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
            param.setCompressionQuality(quality);
            BufferedImage image;
            if (file.getContentType().equals("image/jpeg")) {
                // JPEG 이미지를 JPG로 변환
                File jpgFile = convertJpegToJpg(file);
                image = ImageIO.read(jpgFile);
            } else {
                // 그 외의 형식은 그대로 사용
                image = ImageIO.read(file.getInputStream());
            }
            writer.write(null, new IIOImage(image, null, null), param);
        } catch (FileNotFoundException e) {
            throw new CustomException(ErrorCode.FILE_NOT_FOUND);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return compressedImageFile;
    }

    private File convertJpegToJpg(MultipartFile jpegFile) throws IOException {
        BufferedImage jpegImage = ImageIO.read(jpegFile.getInputStream());

        File jpgFile = new File(Objects.requireNonNull(jpegFile.getOriginalFilename()));
        BufferedImage jpgImage = new BufferedImage(jpegImage.getWidth(), jpegImage.getHeight(), BufferedImage.TYPE_INT_RGB);
        jpgImage.createGraphics().drawImage(jpegImage, 0, 0, Color.WHITE, null);

        ImageIO.write(jpgImage, "jpg", jpgFile);

        return jpgFile;
    }

}

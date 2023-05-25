import why.Location;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class Article {
    public static void main(String[] args) throws IOException {
        start();
    }

    public static void start() throws IOException {
        List<String> content = new ArrayList<>();
        List<Location> address = new ArrayList<>();
        BufferedReader addressReader = new BufferedReader(new FileReader("data22.txt"));
        String line = "";
        while ((line = addressReader.readLine()) != null) {
            String[] add = line.split(",");
            Location location = new Location();
            location.dosi = add[0];
            location.sigungu = add[1];
            location.dongeupmyeon = add[2];
            address.add(location);
        }
        addressReader.close();

        BufferedReader contentReader = new BufferedReader(new FileReader("content.txt"));
        line = "";
        while ((line = contentReader.readLine()) != null) {
            content.add(line);
        }
        contentReader.close();

        List<Integer> likeCount = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            likeCount.add(i);
        }

        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://3.37.17.94:3306/areastory_tmp?characterEncoding=UTF-8&serverTimezone=UTC",
                "k8a302",
                "ssafy12!");
             Statement stmt = conn.createStatement()) {
            int articleId = 1;
            int userId = 1;
            int contentId = 1;
            int likeId = 1;
            int count = 2;
            int idx = 1;
            for (Location location : address) {
                StringBuilder sql = new StringBuilder("insert into article(article_id, user_id, content, image, thumbnail, daily_like_count, total_like_count, comment_count, dosi, sigungu, dongeupmyeon, public_yn, created_at)" +
                        " values ");
                for (int j = 0; j < count; j++) {
                    sql.append("(").append(articleId).append(", ").append(userId).append(", \"").append(content.get(contentId - 1)).append("\", ")
                            .append("\"https://areastory.s3.ap-northeast-2.amazonaws.com/picture/").append(contentId).append(".jpg\"").append(", ")
                            .append("\"https://areastory.s3.ap-northeast-2.amazonaws.com/thumbnail/").append(contentId).append(".jpg\"")
                            .append(", ").append(likeCount.get(likeId - 1)).append(", ").append(likeCount.get(likeId - 1)).append(", ")
                            .append(0).append(", \"").append(location.dosi).append("\", \"")
                            .append(location.sigungu).append("\", \"").append(location.dongeupmyeon).append("\", ").append(true).append(", ").append("\"2023-05-18 08:32:04.129264\")");
                    if (j != count - 1)
                        sql.append(",");
                    articleId++;
                    userId++;
                    contentId++;
                    likeId++;
                    if (userId == 6)
                        userId = 1;
                    if (contentId == 238)
                        contentId = 1;
                    if (likeId == 5)
                        likeId = 1;
                }
                stmt.executeUpdate(sql.toString());
                if (idx % 10 == 0)
                    System.out.println("article : " + idx + " / " + address.size());
                idx++;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
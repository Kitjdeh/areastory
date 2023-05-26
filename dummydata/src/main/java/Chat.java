import why.ChatRoom;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class Chat {
    public static void main(String[] args) throws IOException {
        start();
    }

    public static void start() throws IOException {
        List<ChatRoom> rooms = new ArrayList<>();
        BufferedReader addressReader = new BufferedReader(new FileReader("chat.txt"));
        String line = "";
        while ((line = addressReader.readLine()) != null) {
            String[] add = line.split(",");
            ChatRoom room = new ChatRoom();
            room.roomName = add[0];
            room.roomId = add[1];
            rooms.add(room);
        }
        addressReader.close();

        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://3.37.17.94:3306/areastory_tmp?characterEncoding=UTF-8&serverTimezone=UTC",
                "k8a302",
                "ssafy12!");
             Statement stmt = conn.createStatement()) {
            int count = 1;
            int idx = 1;
            for (ChatRoom room : rooms) {
                StringBuilder sql = new StringBuilder("insert into chat_room(room_id, room_name, user_count)" +
                        " values ");
                for (int j = 0; j < count; j++) {
                    sql.append("( \"").append(room.roomId).append("\", \"").append(room.roomName).append("\", ").append(0).append(")");
                    if (j != count - 1)
                        sql.append(",");
                }
                stmt.executeUpdate(sql.toString());
                if (idx % 10 == 0)
                    System.out.println("chat : " + idx + " / " + rooms.size());
                idx++;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
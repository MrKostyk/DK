import java.sql.*;

public class TelegramBot {
    private Connection connection;

    public TelegramBot() {
        try {
            connection = DriverManager.getConnection("jdbc:mysql://mysql:3306/your_database", "username", "password");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void saveData(String data) {
        try {
            PreparedStatement statement = connection.prepareStatement("INSERT INTO data_table (data) VALUES (?)");
            statement.setString(1, data);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public String fetchData() {
        StringBuilder result = new StringBuilder();
        try {
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery("SELECT * FROM data_table");
            while (resultSet.next()) {
                result.append(resultSet.getString("data")).append("\n");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result.toString();
    }

    public static void main(String[] args) {
        TelegramBot bot = new TelegramBot();
    }
}
FROM openjdk:11-jre
RUN apt-get update && apt-get install -y mysql-server
COPY TelegramBot.java /
COPY entrypoint.sh /
RUN javac TelegramBot.java
CMD ["bash", "entrypoint.sh"]
#!/bin/bash
service mysql start
java TelegramBot
version: '3'
services:
  app:
    build: .
    depends_on:
      - mysql
  mysql:
    image: mysql:latest
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: your_database
      MYSQL_USER: username
      MYSQL_PASSWORD: password

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;

@ServerEndpoint("/chatSocket")
public class ChatEndpoint {

    // Stores all connected users
    private static final CopyOnWriteArraySet<Session> clients =
            new CopyOnWriteArraySet<>();

    // Stores username for each connected user
    private static final Map<Session, String> usernames =
            new ConcurrentHashMap<>();


    // Called when a user connects
    @OnOpen
    public void onOpen(Session session) {

        clients.add(session);

        String username = getUsername(session);

        usernames.put(session, username);

        System.out.println(username + " joined the chat.");

        broadcast(
                "SYSTEM",
                username + " joined the chat."
        );
    }


    // Called when a user sends a message
    @OnMessage
    public void onMessage(String message,
                          Session session) {

        String username = usernames.get(session);

        if (username == null) {
            return;
        }

        message = message.trim();

        if (message.isEmpty()) {
            return;
        }

        System.out.println(
                username + ": " + message
        );

        broadcast(username, message);
    }


    // Called when user disconnects
    @OnClose
    public void onClose(Session session) {

        String username = usernames.remove(session);

        clients.remove(session);

        if (username != null) {

            System.out.println(
                    username + " left the chat."
            );

            broadcast(
                    "SYSTEM",
                    username + " left the chat."
            );
        }
    }


    // Handles errors
    @OnError
    public void onError(Session session,
                        Throwable throwable) {

        System.out.println(
                "WebSocket Error: "
                + throwable.getMessage()
        );
    }


    // Get username from WebSocket URL
    private String getUsername(Session session) {

        Map<String, java.util.List<String>> parameters =
                session.getRequestParameterMap();

        java.util.List<String> values =
                parameters.get("username");

        if (values != null && !values.isEmpty()) {
            return values.get(0);
        }

        return "Unknown User";
    }


    // Send message to all connected users
    private void broadcast(String username,
                           String message) {

        for (Session client : clients) {

            if (client.isOpen()) {

                String json =
                        "{"
                        + "\"username\":\""
                        + escapeJson(username)
                        + "\","
                        + "\"message\":\""
                        + escapeJson(message)
                        + "\""
                        + "}";

                client.getAsyncRemote()
                      .sendText(json);
            }
        }
    }


    // Prevent JSON problems with quotes and backslashes
    private String escapeJson(String text) {

        return text
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
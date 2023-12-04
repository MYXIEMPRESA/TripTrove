package com.tuapp;

import java.io.IOException;
import java.util.ArrayList;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/chat")
public class ChatServlet {
    private static final ArrayList<Session> sessions = new ArrayList<>();

    @OnOpen
    public void onOpen(Session session) {
        // Se agrega la sesión del usuario a la lista
        sessions.add(session);
    }

    @OnMessage
    public void onMessage(String message, Session senderSession) {
        // Envía el mensaje a todas las sesiones (usuarios) conectadas
        for (Session session : sessions) {
            try {
                session.getBasicRemote().sendText(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @OnClose
    public void onClose(Session session) {
        // Se elimina la sesión del usuario de la lista al cerrar la conexión
        sessions.remove(session);
    }

    @OnError
    public void onError(Throwable throwable) {
        // Maneja errores si ocurren durante la comunicación WebSocket
        throwable.printStackTrace();
    }
}

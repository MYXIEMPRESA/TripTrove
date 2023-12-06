import java.io.IOException;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/proceso")
public class Proceso {

    @OnOpen
    public void onOpen(Session session) {
        System.out.println(session.getId() + " ha abierto una conexión");
        try {
            session.getBasicRemote().sendText("Conexión establecida");
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        System.out.println("Mensaje " + session.getId() + ": " + message);
        try {
            session.getBasicRemote().sendText(message);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session) {
        System.out.println("Sesión " + session.getId() + " ha terminado");
    }
}

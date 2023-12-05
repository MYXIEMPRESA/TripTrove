/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

import java.io.IOException;
import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import javax.websocket.EncodeException;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import org.gerdoc.dao.Mensaje;
import org.gerdoc.util.MensajeDecoder;
import org.gerdoc.util.MensajeEncoder;

/**
 *
 * @author gerdoc
 */

@ServerEndpoint( value = "/webserversocket/{username}", decoders = MensajeDecoder.class, encoders = MensajeEncoder.class)
public class WebServerSocket implements Serializable
{
    private Session session;
    private static Set<WebServerSocket> set = new CopyOnWriteArraySet<WebServerSocket>();
    private static Map<String, String> map = new HashMap<String, String>();

    public WebServerSocket() 
    {
    }

    @OnOpen
    public void onOpen( Session session, @PathParam("username") String username) throws EncodeException, IOException 
    {
        Mensaje mensaje = null;
        this.session = session;
        set.add(this );
        map.put( session.getId( ) , username);
        mensaje = createMensaje( "Chat de tonotos" , username );
        aTodos( mensaje );
        System.out.println("onOpen=" + username );
    }
    
    private static void aTodos(Mensaje mensaje) throws IOException, EncodeException 
    {
 
        set.forEach(endpoint -> 
        {
            synchronized (endpoint) 
            {
                try 
                {
                    endpoint.session.getBasicRemote().
                      sendObject(mensaje);
                } 
                catch (IOException | EncodeException e) 
                {
                    e.printStackTrace();
                }
            }
        });
    }

    @OnError
    public void onError(Throwable t) 
    {
        t.printStackTrace();
    }

    @OnClose
    public void onClose( Session session) throws IOException, EncodeException 
    {
        Mensaje mensaje = null;
        set.remove( this );
        mensaje = createMensaje( "Adios" );
        aTodos(mensaje);
    }

    @OnMessage
    public void onMessage(Session session, Mensaje mensaje) 
    {
        System.out.println("onMessage");
        if( session == null || mensaje == null )
        {
            System.out.println("Sali");
            return;
        }
        printMensaje( mensaje );
        
    }
    
    public Mensaje createMensaje( String text )
    {
        Mensaje mensaje = new Mensaje( );
        mensaje.setDe("soporte" );
        mensaje.setMensaje( text );
        return mensaje;
    }
    
    public Mensaje createMensaje( String text , String para )
    {
        Mensaje mensaje = createMensaje( text );
        mensaje.setPara( para );
        return mensaje;
    } 
    
    public void printMensaje( Mensaje mensaje )
    {
        if( mensaje == null )
        {
            return;
        }
        System.out.println(String.format( "De: %s" , mensaje.getDe( ) ) );
        System.out.println(String.format( "Para: %s" , mensaje.getPara( ) ) );
        System.out.println(String.format( "Mensaje: %s" , mensaje.getMensaje() ) );
    }
    
    
    

    
}

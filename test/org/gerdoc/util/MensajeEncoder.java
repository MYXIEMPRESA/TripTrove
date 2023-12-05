/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package org.gerdoc.util;

import com.google.gson.Gson;
import java.io.Serializable;
import javax.websocket.EncodeException;
import javax.websocket.Encoder;
import javax.websocket.EndpointConfig;
import org.gerdoc.dao.Mensaje;

/**
 *
 * @author gerdoc
 */
public class MensajeEncoder implements Serializable, Encoder.Text<Mensaje>
{

    private static Gson gson = new Gson( );
    @Override
    public void init(EndpointConfig config) 
    {
        
    }

    @Override
    public void destroy() 
    {
    }

    @Override
    public String encode(Mensaje mensaje) throws EncodeException 
    {
        if( mensaje == null )
        {
            return "";
        }
        return gson.toJson(mensaje);
    }
    
}

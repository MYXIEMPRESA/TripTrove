/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package org.gerdoc.util;

import java.io.Serializable;
import javax.websocket.DecodeException;
import javax.websocket.Decoder;
import javax.websocket.EndpointConfig;
import org.gerdoc.dao.Mensaje;
import com.google.gson.Gson;

/**
 *
 * @author gerdoc
 */
public class MensajeDecoder implements Serializable, Decoder.Text<Mensaje>
{
    private static Gson gson = new Gson( );

    @Override
    public Mensaje decode(String json) throws DecodeException 
    {
        return gson.fromJson(json, Mensaje.class);
    }

    @Override
    public boolean willDecode(String json) 
    {
        return json != null && json.length( ) > 0;
    }

    @Override
    public void init(EndpointConfig config) 
    {
    }

    @Override
    public void destroy() 
    {
    }
    
}

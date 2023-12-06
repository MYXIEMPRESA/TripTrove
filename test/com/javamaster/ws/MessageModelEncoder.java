
package com.javamaster.ws;

import com.google.gson.Gson;
import com.javamaster.model.MessageModel;
import javax.websocket.EncodeException;
import javax.websocket.Encoder;
import javax.websocket.EndpointConfig;


public class MessageModelEncoder implements Encoder.Text<MessageModel>{
    
    Gson gson = new Gson();

    @Override
    public String encode(MessageModel message) throws EncodeException {
        return gson.toJson(message);
    }

    @Override
    public void init(EndpointConfig config) {
        }

    @Override
    public void destroy() {
        }
    
}
